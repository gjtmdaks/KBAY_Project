package com.kh.kbay.delivery.service;

import com.kh.kbay.delivery.model.vo.Delivery;

public interface DeliveryService {
    int insertDeliveryInfo(Delivery delivery);

    Delivery selectDeliveryByPaymentNo(int paymentNo);

    int updateDeliveryComplete(int paymentNo, int itemNo);
}