package com.kh.kbay.payment.controller;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.kbay.delivery.model.vo.Delivery;
import com.kh.kbay.delivery.service.DeliveryService;
import com.kh.kbay.item.model.vo.Item;
import com.kh.kbay.item.service.ItemService;
import com.kh.kbay.member.model.vo.Member;
import com.kh.kbay.payment.model.vo.Payment;
import com.kh.kbay.payment.service.PaymentService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;


@Slf4j
@Controller
@RequestMapping("/payment")
@RequiredArgsConstructor
public class PaymentController {

    private final PaymentService ps;
    private final ItemService is;
    private final DeliveryService ds;
    @Value("${toss.secret.key}") 
    private String secretKey;
    
    // 결제 체크아웃 페이지 이동
    @GetMapping("/checkout")
    
    public String checkout(@RequestParam("itemNo") int itemNo, Authentication auth, RedirectAttributes ra, Model model) {
        Item item = is.selectItemByNo(itemNo);
        
        if (auth == null) {
            ra.addFlashAttribute("alertMsg", "세션이 만료되었습니다. 다시 로그인해주세요.");
            return "redirect:/member/login";
        }
        model.addAttribute("item", item);
        model.addAttribute("loginUser", (Member) auth.getPrincipal());
        return "payment/checkout"; // jsp 위치도 payment 폴더로 이동
    }
    
    
    // 결제 승인 성공 처리
    @GetMapping("/success")
    public String paymentSuccess(
            @RequestParam String paymentKey,
            @RequestParam String orderId,
            @RequestParam String amount,
            @RequestParam int itemNo,
            @RequestParam String receiverName,
            @RequestParam String receiverPhone,
            @RequestParam String postCode,
            @RequestParam String address,
            @RequestParam String addressDetail,
            @RequestParam String deliveryRequest,
            Authentication auth,
            Model model) {

        try {
            String basicAuth = "Basic " + Base64.getEncoder().encodeToString((secretKey + ":").getBytes(StandardCharsets.UTF_8));
            
            JSONObject obj = new JSONObject();
            obj.put("orderId", orderId);
            obj.put("amount", Long.parseLong(amount)); 
            obj.put("paymentKey", paymentKey);

            HttpClient client = HttpClient.newHttpClient();
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create("https://api.tosspayments.com/v1/payments/confirm"))
                    .header("Authorization", basicAuth)
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(obj.toString()))
                    .build();

            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() == 200) {
                JSONObject jsonResponse = new JSONObject(response.body());
                Member loginUser = (Member) auth.getPrincipal();
                Item item = is.selectItemByNo(itemNo);
                
                // VO 세팅
                Payment pay = new Payment();
                pay.setItemNo(itemNo);
                pay.setOrderId(orderId);
                pay.setPaymentKey(paymentKey);
                pay.setTotalAmount(jsonResponse.getLong("totalAmount"));
                pay.setMethod(jsonResponse.getString("method"));
                pay.setApprovedAt(jsonResponse.getString("approvedAt"));
                
                // 영수증 URL 추출
                String receiptUrl = "";
                if(jsonResponse.has("receipt")) {
                    receiptUrl = jsonResponse.getJSONObject("receipt").optString("url");
                }
                pay.setReceiptUrl(receiptUrl);
                
                //초기 주소 정보만 저장
                Delivery delivery = new Delivery();
                delivery.setItemNo(itemNo);
                delivery.setBuyerId(String.valueOf(loginUser.getUserNo()));
                delivery.setSellerId(String.valueOf(item.getUserNo()));
                delivery.setReceiverName(receiverName);
                delivery.setReceiverPhone(receiverPhone);
                delivery.setPostCode(postCode);
                delivery.setAddress(address);
                delivery.setAddressDetail(addressDetail);
                delivery.setDeliveryRequest(deliveryRequest);
                
                ps.insertPayment(pay, delivery);
              

                
                model.addAttribute("receiptUrl", receiptUrl);
                model.addAttribute("paymentData", jsonResponse.toMap());
                
                return "payment/receipt"; 
            }else {
                JSONObject errorObj = new JSONObject(response.body());
                model.addAttribute("errorMsg", "결제 승인 실패: " + errorObj.optString("message"));
                return "common/errorPage";
            }
        } catch (Exception e) {
            log.error("결제 승인 중 오류 발생", e);
            model.addAttribute("errorMsg", "처리 중 오류가 발생했습니다.");
            return "common/errorPage";
        }
    }
    
 // 결제 실패 처리
    @GetMapping("/fail")
    public String paymentFail(
            @RequestParam String message,
            @RequestParam String code,
            Model model) {
        
        log.error("결제 실패 - 코드: {}, 메시지: {}", code, message);
        
        model.addAttribute("errorMsg", "결제 실패: " + message + " (에러코드: " + code + ")");
        return "common/errorPage"; 
    }
    
    //상세 페이지 이동
    @GetMapping("/receipt/{itemNo}")
    public String viewReceipt(@PathVariable("itemNo") int itemNo, Model model) {
        Payment pay = ps.selectPaymentByItemNo(itemNo);
        
        if (pay == null) {
            model.addAttribute("errorMsg", "결제 내역을 찾을 수 없습니다.");
            return "common/errorPage";
        }
        
        model.addAttribute("paymentData", pay);
        model.addAttribute("receiptUrl", pay.getReceiptUrl());
        
        return "payment/receipt";
    }

    // 모달로 결제 내역 조회(AJAX)
    @GetMapping(value="/api/detail/{itemNo}", produces="application/json; charset=utf-8")
    @ResponseBody
    public Map<String, Object> getPaymentAndDeliveryDetail(@PathVariable("itemNo") int itemNo) {
        Map<String, Object> map = new HashMap<>();
        
        // 결제 정보 조회
        Payment pay = ps.selectPaymentByItemNo(itemNo);
        map.put("payment", pay);
        
        // 배송 정보 조회
        if(pay != null) {
            Delivery delivery = ds.selectDeliveryByPaymentNo(pay.getPayNo());
            map.put("delivery", delivery);
        }
        
        return map;
    }
    
    
}

