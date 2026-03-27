package com.kh.kbay.mypage.model.vo;

import java.util.Date;

import lombok.Data;

@Data
public class SaleListDto {
	private int itemNo;
    private String itemTitle;
    private int currentPrice;
    private int bidCount;
    private int views;
    private Date endTime;

    private String imgUrl;
    private String buyerId; // 최고 입찰자
}
