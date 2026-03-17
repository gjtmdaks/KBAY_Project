package com.kh.kbay.bid.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Bid {
	// 입찰 기록 테이블
	
	private int bidNo; 
	private int itemNo; 
	private int userNo; 
	private int bid;
	private Date bidTime;
	private int isWinner;
	
}
