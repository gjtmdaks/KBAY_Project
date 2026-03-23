package com.kh.kbay.bid.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.kh.kbay.bid.model.vo.Bid;
import com.kh.kbay.item.model.vo.Item;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Repository
@Slf4j
@RequiredArgsConstructor
public class BidDaoImpl implements BidDao {
	private final SqlSessionTemplate session;

	@Transactional
	@Override
	public int placeBid(Bid req) {
		// 1. lock
	    session.selectOne("bid.itemLock", req.getItemNo());

	    // 2. 현재가 조회
	    int currentPrice = session.selectOne("bid.selectCurrentPrice", req.getItemNo());

	    // 3. 상태 체크
	    Item item = session.selectOne("item.selectItemDetail", req.getItemNo());
	    if(!"N".equals(item.getStatus())){
	        throw new IllegalStateException("입찰 불가 상태");
	    }

	    // 4. 최소 입찰 검증
	    if(req.getBidPrice() <= currentPrice){
	        throw new IllegalArgumentException("현재가보다 높은 금액을 입력하세요.");
	    }

	    // 6. ranking
	    int ranking = session.selectOne("bid.selectRanking", req);

	    // 5. insert
	    session.insert("bid.insertBid", req);

	    return ranking;
    }

	@Override
	public int selectBidCount(int itemNo) {
		return session.selectOne("bid.selectBidCount", itemNo);
	}

	@Override
	public int selectCurrentPrice(int itemNo) {
		return session.selectOne("bid.selectCurrentPrice", itemNo);
	}

	@Override
	public int selectMaxPrice(int itemNo) {
		return session.selectOne("bid.selectMaxPrice", itemNo);
	}
}
