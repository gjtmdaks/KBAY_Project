package com.kh.kbay.payment.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.kbay.delivery.dao.DeliveryDao;
import com.kh.kbay.delivery.model.vo.Delivery;
import com.kh.kbay.payment.dao.PaymentDao;
import com.kh.kbay.payment.model.vo.Payment;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class PaymentServiceImpl implements PaymentService {
    private final PaymentDao pd;
    private final DeliveryDao dd;

    @Transactional 
    @Override
    public void insertPayment(Payment pay) {
        pd.insertPayment(pay);
        
        pd.updatePaymentStatus(pay.getItemNo());
    }
    
    @Override
    public Payment selectPaymentByItemNo(int itemNo) {
        return pd.selectPaymentByItemNo(itemNo);
    }
    
    @Transactional 
    @Override
    public void insertPayment(Payment pay, Delivery delivery) {
        pd.insertPayment(pay);
        
        delivery.setPaymentNo(pay.getPayNo());
        
        dd.insertDelivery(delivery);
      
        dd.insertDeliveryDetail(delivery.getDeliveryNo());
        
        pd.updatePaymentStatus(pay.getItemNo());
    }

	
}