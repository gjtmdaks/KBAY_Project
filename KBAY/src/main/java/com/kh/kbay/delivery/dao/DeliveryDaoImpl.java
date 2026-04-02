package com.kh.kbay.delivery.dao;

import java.util.Map;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;
import com.kh.kbay.delivery.model.vo.Delivery;
import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class DeliveryDaoImpl implements DeliveryDao {

    private final SqlSessionTemplate session;

    @Override
    public int insertDelivery(Delivery delivery) {
        return session.insert("delivery.insertDelivery", delivery);
    }

    @Override
    public int insertDeliveryDetail(int deliveryNo) {
        return session.insert("delivery.insertDeliveryDetail", deliveryNo);
    }

    @Override
    public int updatePaymentStatus(Map<String, Object> params) {
        return session.update("delivery.updatePaymentStatus", params);
    }
    
    @Override
    public Delivery selectDeliveryByPaymentNo(int paymentNo) {
        return session.selectOne("delivery.selectDeliveryByPaymentNo", paymentNo);
    }

    @Override
    public int updateItemToFinal(Map<String, Object> params) {
        return session.update("delivery.updateItemToFinal", params);
    }

    @Override
    public int updatePaymentToFinal(Map<String, Object> params) {
        return session.update("delivery.updatePaymentToFinal", params);
    }
    
    @Override
    public int updateDelivery(Delivery delivery) {
        return session.update("delivery.updateDelivery", delivery); // 이 부분 추가
    }
}