package com.kh.kbay.delivery.model.vo;

import java.util.Date;
import lombok.Data;

@Data
public class Delivery {
    private int deliveryNo;
    private int paymentNo;
    private int itemNo;
    private String buyerId;
    private String sellerId;
    private String receiverName;
    private String receiverPhone;
    private String postCode;
    private String address;
    private String addressDetail;
    private String deliveryRequest;
    private String courier;      // 택배사
    private String trackingNo;   // 운송장번호
    
    private String status;       // 배송상태 (준비중/배송중/완료)
    private Date shippedDate;
}