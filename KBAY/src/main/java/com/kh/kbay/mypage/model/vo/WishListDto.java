package com.kh.kbay.mypage.model.vo;

import lombok.Data;

//찜 목록 DTO
@Data
public class WishListDto {
	private int itemNo;
	private String itemTitle;
	private int currentPrice;
}
