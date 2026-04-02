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
	private int bidCount;
	private String bidStatus; // 낙찰 포기/박탈 여부 (N, F 등)
	private String bidType;
	
	private long requestTime;

	public Bid(int itemNo, int bidPrice, int userNo, int ranking) {
		this.itemNo = itemNo;
		this.bidPrice = bidPrice;
		this.userNo = userNo;
		this.ranking = ranking;
	}
}
