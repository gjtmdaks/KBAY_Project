package com.kh.kbay.bid.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import org.redisson.api.RLock;
import org.redisson.api.RedissonClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.kbay.bid.dao.BidDao;
import com.kh.kbay.bid.model.vo.Bid;
import com.kh.kbay.common.RedisPublisher;

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
    private final RedissonClient redissonClient;
    private final RedisPublisher redisPublisher;

    @Override
    @Transactional
    public int placeBid(Bid req) {
        // 1. Redis가 없는 경우 (Fallback)
        if (redissonClient == null) {
            checkSelfOutbidding(req); // 공통 로직으로 분리 권장
            int ranking = bd.placeBid(req);
            log.info("Redis 없음 → DB 기반 입찰 처리");
            return ranking;
        }

        // 2. Redis가 있는 경우
        String lockKey = "bid:item:" + req.getItemNo();
        RLock lock = redissonClient.getLock(lockKey);

        try {
            boolean available = lock.tryLock(3, 5, TimeUnit.SECONDS);
            if (!available) throw new IllegalStateException("입찰 폭주");

            // 락을 잡은 직후, 최신 상태에서 본인 체크를 수행
            checkSelfOutbidding(req);

            // 입찰 실행 및 랭킹 확인
            int ranking = bd.placeBid(req);
            bd.updateRanking(req.getItemNo());
            
            // 갱신된 '2등 가격'(Vickrey 현재가) 조회
            int vickreyCurrentPrice = bd.selectCurrentPrice(req.getItemNo());
            
            // 🔥현재 1등이 누구인지 다시 확인
            Bid finalTopBid = bd.findTopBid(req.getItemNo());
            int topUserNo = (finalTopBid != null) ? finalTopBid.getUserNo() : req.getUserNo();
            
            // 메시지 생성 
            Bid msg = new Bid(
                    req.getItemNo(),
                    vickreyCurrentPrice,
                    topUserNo, 
                    ranking
            );

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
	public List<Bid> selectBidHistory(int itemNo) {
	    return bd.selectBidHistory(null, itemNo); 
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
	
}
