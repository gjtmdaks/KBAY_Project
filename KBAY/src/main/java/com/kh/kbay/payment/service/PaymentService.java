package com.kh.kbay.payment.service;

import com.kh.kbay.delivery.model.vo.Delivery;
import com.kh.kbay.payment.model.vo.Payment;

public interface PaymentService {

	void insertPayment(Payment pay);
	
	Payment selectPaymentByItemNo(int itemNo);

	void insertPayment(Payment pay, Delivery delivery);
	
}
