package com.kh.kbay.mypage.model.vo;

import java.util.Date;

import lombok.Data;

//입찰 목록 DTO
@Data
public class BidListDto {

    private int itemNo;
    private String itemTitle;
    private int currentPrice;
    private int bidPrice;

    private String status;      // Y/N/E
    private String statusText;  // 시작 전 / 진행 중 / 종료
    private int bidCount;
    private int views;
    private Date endTime;
    private String payStatus;
    private String sellerId;

    private String imgUrl;
    
    private String rankingText; // 최고입찰자 / 차순위입찰자
    private String sellerName; //판매자 이름(낙찰페이지에서 사용)
}
