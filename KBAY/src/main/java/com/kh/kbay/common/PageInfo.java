package com.kh.kbay.common;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PageInfo {
	private int boardListCount; // 총 게시글 개수
    private int currentPage;    // 현재 페이지 번호
    private int pageLimit;      // 하단 페이징 바에 보여질 숫자 개수 (예: 1~10)
    private int boardLimit;     // 한 페이지에 보여질 게시글 개수 (예: 10개)
    private int maxPage;        // 가장 마지막 페이지 번호
    private int startPage;      // 페이징 바의 시작 번호
    private int endPage;        // 페이징 바의 끝 번호

    private int limit;
    private int offset;
    private int totalCount;

    public static PageInfo of(int page, int totalCount, int limit) {
        int offset = (page - 1) * limit;
        int maxPage = (int)Math.ceil((double)totalCount / limit);
        return new PageInfo(page, limit, offset, totalCount, maxPage);
    }

	public PageInfo(int page, int limit, int offset, int totalCount, int maxPage) {
		this.currentPage = page;
		this.limit = limit;
		this.offset = offset;
		this.totalCount = totalCount;
		this.maxPage = maxPage;
	}
}
