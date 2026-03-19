package com.kh.kbay.common;

import lombok.Data;

@Data
public class PageInfo {
	private int boardListCount; // 총 게시글 갯수
	private int reportListCount; // 문의 게시글 총 갯수
	private int currentPage;
	private int pageLimin;
	private int boardLimit;
	
	private int maxPage;
	private int startPage;
	private int endPage;
	
}
