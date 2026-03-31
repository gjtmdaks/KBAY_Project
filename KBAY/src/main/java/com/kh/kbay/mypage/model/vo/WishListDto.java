package com.kh.kbay.mypage.model.vo;

import java.util.Date;

import lombok.Data;

//찜 목록 DTO
@Data
public class WishListDto {

    private int itemNo;
    private String itemTitle;
    private int currentPrice;
    
    private int bidCount;
    private int views;
    private Date endTime;
    private String sellerId;
    private String imgUrl;
    private String payStatus;
    // 선택
    private String statusText;
    private String status;
}
