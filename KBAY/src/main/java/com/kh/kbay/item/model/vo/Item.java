package com.kh.kbay.item.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class Item {
	private int startPrice;
	private Date startTime;
	private Date endTime;
	private Date createAt;
	private int itemNo;
	private String status;
	private String itemContent;
	private String itemTitle;
	private int itemCdNo;
	private String CreateCountry;
	private int BuyNowPrice;
	private int sellerNo;
	private int currentPrice;
	private char directBuy;
}
