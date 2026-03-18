package com.kh.kbay.common;

import lombok.Data;

@Data
public class PageInfo {
	private int listCount; // 총 게시글 갯수
	private int reportListCount; // 문의 게시글 총 갯수
	private int currentPage;
	private int pageLimin;
	private int boardList;
	
	private int maxPage;
	private int startPage;
	private int endPage;
	
}
