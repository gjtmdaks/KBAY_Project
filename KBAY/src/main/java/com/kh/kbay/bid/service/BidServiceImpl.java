package com.kh.kbay.bid.service;

import org.springframework.stereotype.Service;

import com.kh.kbay.bid.dao.BidDao;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class BidServiceImpl {
	private final BidDao bd;
	
}
