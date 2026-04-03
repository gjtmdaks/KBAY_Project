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
    private String buyerId;    // MEMBER 테이블 조인으로 가져올 값
    private String statusText; // 배송 상태 한글 텍스트

    private int paymentNo;     // PAYMENT_NO (배송 모달용)
    private String payStatus;  // 'Y'(결제완료), 'S'(배송중), 'P'(최종완료)
    private String receiptUrl;
}
