package com.kh.kbay.bid.model.vo;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Bid {
	// 입찰 기록 테이블
	private int bidNo; 
	private int itemNo; 
	private int userNo; 
	private String userId;
	private int bidPrice;
	private Date bidTime;
	private int ranking;
	private String bidIp;
	private String itemTitle;
	private String bidType;

	public Bid(int itemNo, int bidPrice, int userNo, int ranking) {
		this.itemNo = itemNo;
		this.bidPrice = bidPrice;
		this.userNo = userNo;
		this.ranking = ranking;
	}
}
