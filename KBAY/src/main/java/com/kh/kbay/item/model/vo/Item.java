package com.kh.kbay.item.model.vo;

import java.util.Date;

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
	private Date startTime;
	private Date endTime;
	private char status;
	private Date createAt;
	private String cuntryNo;
	private int deliveryNo;
}
