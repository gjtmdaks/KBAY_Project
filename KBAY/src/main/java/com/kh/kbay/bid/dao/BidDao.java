package com.kh.kbay.bid.dao;

import java.util.List;
import java.util.Map;

import com.kh.kbay.bid.model.vo.Bid;

public interface BidDao {

	int placeBid(Bid req);

	int selectBidCount(int itemNo);

	int selectCurrentPrice(int itemNo);

	int selectMaxPrice(int itemNo);

	List<Bid> selectBidHistory(int itemNo, com.kh.kbay.common.PageInfo pi);

	Bid findTopBid(int itemNo);

	Bid findSecondBid(int itemNo);

	void updateRanking(int itemNo);

	void updateBidStatus(Map<String,Object> param);

	void insertBid(Bid req);

	void forceTopRanking(Map<String, Object> param);

	void endByBuyNow(Map<String, Object> param);
	
}
