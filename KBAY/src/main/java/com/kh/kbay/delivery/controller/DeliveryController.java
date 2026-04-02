package com.kh.kbay.delivery.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.kbay.delivery.model.vo.Delivery;
import com.kh.kbay.delivery.service.DeliveryService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/delivery")
@RequiredArgsConstructor
public class DeliveryController {

    private final DeliveryService ds;

    @PostMapping("register.de")
    public String registerDelivery(Delivery delivery, RedirectAttributes ra) {
        int result = ds.insertDeliveryInfo(delivery);
        
        if(result > 0) {
            ra.addFlashAttribute("alertMsg", "운송장 정보가 등록되었습니다.");
        } else {
            ra.addFlashAttribute("alertMsg", "등록에 실패했습니다.");
        }
        return "redirect:/mypage/paymentList"; 
    }
    
    @GetMapping(value="getAddr.de", produces="application/json; charset=utf-8")
    @ResponseBody
    public Delivery getDeliveryAddr(@RequestParam("paymentNo") int paymentNo) {
        return ds.selectDeliveryByPaymentNo(paymentNo);
    }
    
    @PostMapping(value="complete.de", produces="text/plain; charset=utf-8")
    @ResponseBody
    public String completeDelivery(int paymentNo, int itemNo) {
        int result = ds.updateDeliveryComplete(paymentNo, itemNo);
        return (result > 0) ? "success" : "fail";
    }
}