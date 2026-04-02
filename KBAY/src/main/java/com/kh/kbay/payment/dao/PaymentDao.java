package com.kh.kbay.payment.dao;

import java.util.List;

import com.kh.kbay.payment.model.vo.Payment;

public interface PaymentDao {

	int updatePaymentStatus(int itemNo);

	int  insertPayment(Payment pay);

	Payment selectPaymentByItemNo(int itemNo);
		
	List<Payment> selectSellerPaymentList(int sellerNo);

}
