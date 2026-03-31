package com.kh.kbay.item.model.vo;


import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class Item {
	private int itemNo;
	private int itemCdNo;
	private int userNo;
	private String itemTitle;
    private String userName;
	private int itemSize;
	private String itemContent;
	private int startPrice;
	private String directBuy;
	private int buyNowPrice;
	private int currentPrice;
	@DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
	private Date startTime;
	@DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
	private Date endTime;
	private String status;
	private Date createAt;
	private String countryNo;
	private int deliveryNo;
	private int views;
	private List<ItemImg> imgList;
    private String thumbnail;
    private int bidPrice;
    private String payStatus;
    private String mainImg;      // 대표
    private List<ItemImg> subImgList; // 나머지
    private int bidCount;
    
    private String categoryName; // 카테고리 이름
    private String userId; // 유저 아이디
}
