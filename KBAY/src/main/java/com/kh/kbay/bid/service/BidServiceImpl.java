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

	    // 🔥 Redis 없을 때 fallback
	    if (redissonClient == null) {

	        // DB만 사용 (트랜잭션 + select for update 추천)
	        int ranking = bd.placeBid(req);

	        // Redis 없으므로 pub/sub 생략
	        log.info("Redis 없음 → DB 기반 입찰 처리");

	        return ranking;
	    }

	    // 🔥 Redis 있을 때만 실행
	    String lockKey = "bid:item:" + req.getItemNo();
	    RLock lock = redissonClient.getLock(lockKey);

	    try {
	        boolean available = lock.tryLock(3, 5, TimeUnit.SECONDS);

	        if (!available) {
	            throw new IllegalStateException("입찰 폭주");
	        }

	        int ranking = bd.placeBid(req);

	        // 메시지 생성
	        Bid msg = new Bid(
	                req.getItemNo(),
	                req.getBidPrice(),
	                req.getUserNo(),
	                ranking
	        );

	        // 🔥 publisher도 null 체크
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
