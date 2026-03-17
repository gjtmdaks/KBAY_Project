package com.kh.kbay.bid.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kh.kbay.bid.service.BidService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/bid")
@RequiredArgsConstructor
public class BidController {
	private final BidService bs;
	
}
