package com.kh.kbay.bid.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Result {
	// 신고 테이블
	private int reportNo;
	private Date createAt; // 신고 시각
	private int reportCdNo; // 신고 카테고리 번호
	private int tragetNo;
	private int tragetType; // 신고당한 게시물 타입
	private int reportorNo; //
	private char status; // 처리상태
}
