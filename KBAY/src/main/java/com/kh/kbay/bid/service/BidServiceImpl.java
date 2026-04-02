package com.kh.kbay.bid.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import org.mybatis.spring.SqlSessionTemplate;
import org.redisson.api.RLock;
import org.redisson.api.RedissonClient;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.kbay.bid.dao.BidDao;
import com.kh.kbay.bid.model.vo.Bid;
import com.kh.kbay.common.RedisPublisher;
import com.kh.kbay.item.model.vo.Item;
import com.kh.kbay.item.service.ItemService;
import com.kh.kbay.member.dao.MemberDao;
import com.kh.kbay.member.model.vo.Member;
import com.kh.kbay.member.service.MemberService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class BidServiceImpl implements BidService {
	// redis 사용하려면
	// https://github.com/microsoftarchive/redis/releases
	// 여기에서 Redis-x64-3.0.504.zip 다운
	// 압축해제 -> redis-server.exe 실행 -> redis-cli.exe 실행 후 톰캣서버 가동
	private final BidDao bd;
    private final MemberService ms;
    private final MemberDao md;
    private final ItemService is;
    private final RedissonClient redissonClient;
    private final RedisPublisher redisPublisher;
	private final SqlSessionTemplate session;

    private void internalPlaceBidWithLock(Bid req) {

        Item item = is.selectItemByNo(req.getItemNo());
        
        long endTime = item.getEndTime().getTime(); // Date → long

        // 🔥 1. 상태 체크
        if(req.getRequestTime() > endTime){
            throw new IllegalStateException("경매 종료 후 입찰");
        }

        // 🔥 2. 본인 상품 체크
        if (item.getUserNo() == req.getUserNo()) {
            throw new IllegalArgumentException("본인 상품 입찰 불가");
        }

        // 🔥 3. 현재가 조회
        int currentPrice = bd.selectCurrentPrice(req.getItemNo());

        // 🔥 4. 가격 검증
        if (req.getBidPrice() <= currentPrice) {
            throw new IllegalArgumentException("현재가보다 높은 금액 입력 필요");
        }

        // 🔥 5. 1000단위 검증
        if (req.getBidPrice() % 1000 != 0) {
            throw new IllegalArgumentException("1000원 단위만 가능");
        }

        // 🔥 6. 즉시구매가 제한
        if ("Y".equals(item.getDirectBuy())) {
            int buyNowPrice = item.getBuyNowPrice();

            if (req.getBidPrice() >= buyNowPrice) {
                throw new IllegalArgumentException("즉시구매가 이상 입찰 불가");
            }
        }

        // 🔥 7. 자기 재입찰 방지
        checkSelfOutbidding(req);
    }
    
    @Override
    @Transactional
    public int placeBid(Bid req) {
        
        // 1. Redis가 없는 경우 (Fallback)
        if (redissonClient == null) {
    	    session.selectOne("bid.itemLock", req.getItemNo());
        	internalPlaceBidWithLock(req);
            log.info("Redis 없음 → DB 기반 입찰 처리");
            return bd.placeBid(req);
        }

        // 2. Redis가 있는 경우
        String lockKey = "bid:item:" + req.getItemNo();
        RLock lock = redissonClient.getLock(lockKey);

        try {
            boolean available = lock.tryLock(10, 5, TimeUnit.SECONDS);
            if (!available) throw new IllegalStateException("입찰 폭주");

            // 🔥 최신 상태 기준 보안 검증
            internalPlaceBidWithLock(req);
            
            Bid previousTopBid = bd.findTopBid(req.getItemNo());

            // 🔥 일반 입찰 흐름
            int ranking = bd.placeBid(req);

            bd.updateRanking(req.getItemNo());

            // 🔥 메일 알림
            if (ranking == 1 && previousTopBid != null && previousTopBid.getUserNo() != req.getUserNo()) {

                Member outbidUser = md.selectMemberByUserNo(previousTopBid.getUserNo());

                if (outbidUser != null && outbidUser.getUserEmail() != null) {

                    Item item = is.selectItemByNo(req.getItemNo());
                    String itemTitle = (item != null) ? item.getItemTitle() : "경매 상품";

                    ms.sendOutbidEmail(
                            outbidUser.getUserEmail(),
                            itemTitle,
                            req.getBidPrice()
                    );
                }
            }
         // 1. 실제 DB 입찰 수 조회
            int currentBidCount = bd.selectBidCount(req.getItemNo());

            // 2. 현재가 계산
            int vickreyCurrentPrice = bd.selectCurrentPrice(req.getItemNo());

            Bid finalTopBid = bd.findTopBid(req.getItemNo());
            int topUserNo = (finalTopBid != null) ? finalTopBid.getUserNo() : req.getUserNo();

            // 3. 메시지 객체 생성 
            Bid msg = new Bid(
                    req.getItemNo(),
                    vickreyCurrentPrice,
                    topUserNo,
                    ranking
            );
            msg.setBidCount(currentBidCount); 

            if (redisPublisher != null) {
                redisPublisher.publish("bid-channel", msg);
            }

            return ranking;

        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new RuntimeException("락 획득 중 인터럽트 발생", e);
        } finally {
            if (lock != null && lock.isHeldByCurrentThread()) {
                lock.unlock();
            }
        }
    }

    // 중복 로직 방지를 위한 private 메소드
    private void checkSelfOutbidding(Bid req) {
        Bid topBid = bd.findTopBid(req.getItemNo());
        if (topBid != null && topBid.getUserNo() == req.getUserNo()) {
            if (req.getBidPrice() <= topBid.getBidPrice()) {
                throw new IllegalArgumentException("이미 최순위 입찰자입니다. 기존 입찰가(" 
                                                    + String.format("%,d", topBid.getBidPrice()) + "원)보다 높은 금액으로만 증액 가능합니다.");
            }
        }
    }

	@Override
	public int selectBidCount(int itemNo) {
		return bd.selectBidCount(itemNo);
	}

	@Override
	public int selectCurrentPrice(int itemNo) {
		return bd.selectCurrentPrice(itemNo);
	}

	@Override
	public int selectMaxPrice(int itemNo) {
		return bd.selectMaxPrice(itemNo);
	}
	
	@Override
	public List<Bid> selectBidHistory(int itemNo, com.kh.kbay.common.PageInfo pi) {
	    return bd.selectBidHistory(itemNo, pi);
	}

	@Override
	public Bid findSecondBid(int itemNo) {
		return bd.findSecondBid(itemNo);
	}

	@Override
	public Bid findTopBid(int itemNo) {
		return bd.findTopBid(itemNo);
	}

	@Override
	public void updateRanking(int itemNo) {
		bd.updateRanking(itemNo);
	}

	@Override
	public void updateBidStatus(int bidNo, String status) {
		Map<String, Object> param = new HashMap<>();
		param.put("bidNo", bidNo);
		param.put("status", status);
		
		bd.updateBidStatus(param);
	}
	
	private void validateBuyNow(Bid req, Item item) {

	    if (!"N".equals(item.getStatus())) {
	        throw new IllegalStateException("이미 종료된 경매");
	    }

	    if (!"Y".equals(item.getDirectBuy())) {
	        throw new IllegalStateException("즉시구매 불가 상품");
	    }

	    if (item.getUserNo() == req.getUserNo()) {
	        throw new IllegalArgumentException("본인 상품 구매 불가");
	    }
	}
	
	@Transactional
	public void buyNow(Bid req) {

	    String lockKey = "bid:item:" + req.getItemNo();
	    RLock lock = redissonClient.getLock(lockKey);

	    try {
	        lock.lock();

	        Item item = is.selectItemByNo(req.getItemNo());
	        validateBuyNow(req, item);

	        int buyNowPrice = item.getBuyNowPrice();

	        // 🔥 1. 즉시구매 입찰 INSERT
	        req.setBidPrice(buyNowPrice);
	        req.setBidType("NOW");

	        bd.insertBid(req);

	        // 🔥 2. ranking = 1 강제
	        Map<String, Object> param = new HashMap<>();
	        param.put("itemNo", req.getItemNo());
	        param.put("bidNo", req.getBidNo());
	        
	        bd.forceTopRanking(param);

	        // 🔥 3. item 종료 처리
	        is.endByBuyNow(req.getItemNo(), buyNowPrice);
	        
            // 🔥 Redis 알림 (즉시 종료 이벤트)
            Bid msg = new Bid(
                    req.getItemNo(),
                    req.getBidPrice(), // 즉시구매가
                    req.getUserNo(),
                    1
            );

            if (redisPublisher != null) {
                redisPublisher.publish("bid-channel", msg);
            }

	    } finally {
	        lock.unlock();
	    }
	}
	
}
