package com.kh.kbay.bid.service;

import com.kh.kbay.bid.model.vo.Bid;

public interface BidService {

	int placeBid(Bid req);

	int selectBidCount(int itemNo);

	int selectCurrentPrice(int itemNo);

	int selectMaxPrice(int itemNo);

}
