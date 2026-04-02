package com.kh.kbay.delivery.service;

import java.util.HashMap;
import java.util.Map;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.kh.kbay.delivery.dao.DeliveryDao;
import com.kh.kbay.delivery.model.vo.Delivery;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class DeliveryServiceImpl implements DeliveryService {

    private final DeliveryDao dd;

    @Transactional
    @Override
    public int insertDeliveryInfo(Delivery delivery) {
        Delivery existing = dd.selectDeliveryByPaymentNo(delivery.getPaymentNo());
        int result = 0;
        
        if (existing == null) {
            result = dd.insertDelivery(delivery);
            if (result > 0) {
                dd.insertDeliveryDetail(delivery.getDeliveryNo());
            }
        } else {
            delivery.setDeliveryNo(existing.getDeliveryNo());
            result = dd.updateDelivery(delivery);
        }

        if (result > 0) {
            Map<String, Object> params = new HashMap<>();
            params.put("itemNo", delivery.getItemNo());
            params.put("paymentNo", delivery.getPaymentNo());
            
            dd.updatePaymentStatus(params);
            return result;
        }
        
        return 0;
    }

    @Override
    public Delivery selectDeliveryByPaymentNo(int paymentNo) {
        return dd.selectDeliveryByPaymentNo(paymentNo);
    }

    @Transactional
    @Override
    public int updateDeliveryComplete(int paymentNo, int itemNo) {
        Map<String, Object> params = new HashMap<>();
        params.put("paymentNo", paymentNo);
        params.put("itemNo", itemNo);
        
        // 최종 완료
        int res1 = dd.updateItemToFinal(params);
        int res2 = dd.updatePaymentToFinal(params);
        
        return res1 + res2;
    }
}