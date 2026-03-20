package com.kh.kbay.common.template;

import com.kh.kbay.common.PageInfo;

public class Pagination {

	public static PageInfo getPageInfo(int boardlistCount, int currentPage, int pageLimit, int boardLimit) {
		PageInfo pi = new PageInfo();
		
		int maxPage = (int) Math.ceil(boardlistCount / (double)boardLimit);
		
		// 2. startPage(페이징바의 시작 페이지)
		int startPage = (currentPage -1) / pageLimit * pageLimit + 1;
		
		// 3. endPage(페이징바의 종료 페이지)
		int endPage = startPage + pageLimit - 1; // 1 + 10 -1
		
		if(endPage > maxPage) {
			endPage = maxPage;
		}
		
		pi.setBoardListCount(boardlistCount);
		pi.setCurrentPage(currentPage);
		pi.setPageLimit(pageLimit);
		pi.setBoardLimit(boardLimit);
		pi.setStartPage(startPage);
		pi.setEndPage(endPage);
		pi.setMaxPage(maxPage);
		
		return pi;
	}

}
