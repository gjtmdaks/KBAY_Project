package com.kh.kbay.bid.service;

import org.springframework.stereotype.Service;

import com.kh.kbay.bid.dao.BidDao;
import com.kh.kbay.bid.model.vo.Bid;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class BidServiceImpl implements BidService {
	private final BidDao bd;

	@Override
	public int placeBid(Bid req) {
		return bd.placeBid(req);
	}
	
}
