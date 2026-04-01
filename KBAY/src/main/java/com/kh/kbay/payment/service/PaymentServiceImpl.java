package com.kh.kbay.payment.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.kbay.payment.dao.PaymentDao;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class PaymentServiceImpl implements PaymentService {
    private final PaymentDao pd;

    @Transactional
    @Override
    public void updatePaymentStatus(int itemNo) {
        pd.updatePaymentStatus(itemNo);
    }
}
