package com.kh.kbay.delivery.dao;

import java.util.Map;
import com.kh.kbay.delivery.model.vo.Delivery;

public interface DeliveryDao {
    int insertDelivery(Delivery delivery);
    
    int insertDeliveryDetail(int deliveryNo);
    
    Delivery selectDeliveryByPaymentNo(int paymentNo);
    
    int updatePaymentStatus(Map<String, Object> params); 
    
    int updateItemToFinal(Map<String, Object> params); 
    
    int updatePaymentToFinal(Map<String, Object> params);

	int updateDelivery(Delivery delivery);
}	