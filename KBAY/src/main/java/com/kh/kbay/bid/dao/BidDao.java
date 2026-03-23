package com.kh.kbay.bid.dao;

import com.kh.kbay.bid.model.vo.Bid;

public interface BidDao {

	int placeBid(Bid req);

	int selectBidCount(int itemNo);

	int selectCurrentPrice(int itemNo);

	int selectMaxPrice(int itemNo);
	
}
