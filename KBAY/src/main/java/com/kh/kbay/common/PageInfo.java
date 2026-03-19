package com.kh.kbay.common;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class PageInfo {
    private int currentPage;
    private int limit;
    private int offset;
    private int totalCount;
    private int maxPage;

    public static PageInfo of(int page, int totalCount, int limit) {
        int offset = (page - 1) * limit;
        int maxPage = (int)Math.ceil((double)totalCount / limit);
        return new PageInfo(page, limit, offset, totalCount, maxPage);
    }
}
