package com.kh.kbay.payment.model.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class Payment {
    private int payNo;
    private int itemNo;
    private String orderId;
    private String paymentKey;
    private long totalAmount;
    private String method;
    private String receiptUrl;
    private String approvedAt;
    private String payStatus;
    private String createDate;
    
    private String orderName;
    
    private String itemTitle;
    private String imgUrl;
    private int userNo;
    private String userName;
}
