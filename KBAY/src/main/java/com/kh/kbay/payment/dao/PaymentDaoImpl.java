package com.kh.kbay.payment.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.kbay.payment.model.vo.Payment;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;


@Slf4j
@Repository
@RequiredArgsConstructor
public class PaymentDaoImpl implements PaymentDao {
    private final SqlSessionTemplate session;

    @Override
    public int insertPayment(Payment pay) {
        return session.insert("payment.insertPayment", pay);
    }

    @Override
    public int updatePaymentStatus(int itemNo) {
        return session.update("payment.updatePaymentStatus", itemNo);
    }
    
    @Override
    public Payment selectPaymentByItemNo(int itemNo) {
        return session.selectOne("payment.selectPaymentByItemNo", itemNo);
    }
    
    @Override
    public List<Payment> selectSellerPaymentList(int sellerNo) {
        return session.selectList("payment.selectSellerPaymentList", sellerNo);
    }
}
