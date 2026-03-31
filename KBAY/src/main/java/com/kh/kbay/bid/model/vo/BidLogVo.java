package com.kh.kbay.bid.model.vo;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class BidLogVo {
    private int bidNo;
    private int itemNo;
    private int userNo;
    private String userId;
    private int bidPrice;
    private Timestamp bidTime;
    private Integer ranking;
    private String bidIp;
}
