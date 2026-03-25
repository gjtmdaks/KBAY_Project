package com.kh.kbay.bid.service;

import java.util.List;

import com.kh.kbay.bid.model.vo.Bid;

public interface BidService {

	int placeBid(Bid req);

	int selectBidCount(int itemNo);

	int selectCurrentPrice(int itemNo);

	int selectMaxPrice(int itemNo);
	
	List<Bid> selectBidHistory(int itemNo);

}
