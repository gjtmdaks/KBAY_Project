package com.kh.kbay.item.model.vo;


import java.util.List;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class Item {
	private int itemNo;
	private int itemCdNo;
	private int userNo;
	private String itemTitle;

	private int itemSize;
	private String itemContent;
	private int startPrice;
	private char directBuy;
	private int buyNowPrice;
	private int currentPrice;
	private String startTime;
	private String endTime;
	private String status;
	private String createAt;
	private String countryNo;
	private int deliveryNo;
	
	private List<ItemImg> imgList;
    private String thumbnail;
}
