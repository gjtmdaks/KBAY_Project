package com.kh.kbay.bid.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

	    // 5. ranking 세팅 제거
	    req.setBidType("NORMAL");

	    // 6. insert 먼저
	    session.insert("bid.insertBid", req);

	    // 7. 진짜 ranking 계산 (가격 기준)
	    int ranking = session.selectOne("bid.selectRanking", req);

	    // 🔥 8. 현재가 재계산
	    int newCurrentPrice = session.selectOne("bid.selectCurrentPrice", req.getItemNo());

	    // 🔥 9. ITEM 업데이트
	    Map<String, Object> param = new HashMap<>();
	    param.put("itemNo", req.getItemNo());
	    param.put("currentPrice", newCurrentPrice);

	    session.update("bid.updateCurrentPrice", param);

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

	@Override
	public List<Bid> selectBidHistory(int itemNo, com.kh.kbay.common.PageInfo pi) {
	    Map<String, Object> param = new HashMap<>();
	    param.put("itemNo", itemNo);
	    param.put("offset", pi.getOffset());
	    param.put("limit", pi.getLimit());
	    
	    return session.selectList("bid.selectBidHistory", param);
	}

	@Override
	public Bid findTopBid(int itemNo) {
		return session.selectOne("bid.findTopBid", itemNo);
	}

	@Override
	public Bid findSecondBid(int itemNo) {
		return session.selectOne("bid.findSecondBid", itemNo);
	}

	@Override
	public void updateRanking(int itemNo) {
		session.update("bid.updateRanking", itemNo);
	}

	@Override
	public void updateBidStatus(Map<String, Object> param) {
		session.update("bid.updateBidStatus", param);
	}

	@Override
	public void insertBid(Bid req) {
		session.insert("bid.insertBid", req);
	}

	@Override
	public void forceTopRanking(Map<String, Object> param) {
		session.update("bid.forceTopRanking", param);
	}

	@Override
	public void endByBuyNow(Map<String, Object> param) {
		session.update("bid.endByBuyNow", param);
	}
}
