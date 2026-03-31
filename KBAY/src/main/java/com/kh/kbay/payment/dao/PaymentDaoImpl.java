package com.kh.kbay.payment.dao;

import org.mybatis.spring.SqlSessionTemplate;

import org.springframework.stereotype.Repository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;


@Slf4j
@Repository
@RequiredArgsConstructor
public class PaymentDaoImpl implements PaymentDao {
    private final SqlSessionTemplate session;

    @Override
    public int updatePaymentStatus(int itemNo) {
        return session.update("payment.updatePaymentStatus", itemNo);
    }
}
