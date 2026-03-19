package com.kh.kbay.bid.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Result {
	// 결과(낙찰) 테이블
	private int resultNo;
	private int bidNo;
	private int finalPrice;
	private Date resultTime;
	private char status;
}
