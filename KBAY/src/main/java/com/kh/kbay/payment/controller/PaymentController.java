package com.kh.kbay.payment.controller;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.Base64;

import org.springframework.beans.factory.annotation.Value;
import org.json.JSONObject;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.kbay.item.model.vo.Item;
import com.kh.kbay.item.service.ItemService;
import com.kh.kbay.member.model.vo.Member;
import com.kh.kbay.payment.service.PaymentService;

import lombok.RequiredArgsConstructor;



@Controller
@RequestMapping("/payment")
@RequiredArgsConstructor
public class PaymentController {

    private final PaymentService ps;
    private final ItemService is;
    
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
            Model model) throws Exception {

        // 2. 이제 필드에 주입된 secretKey를 사용하므로 에러가 사라집니다.
        String basicAuth = "Basic " + Base64.getEncoder().encodeToString((secretKey + ":").getBytes());
        
        JSONObject obj = new JSONObject();
        obj.put("orderId", orderId);
        obj.put("amount", amount);
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
            // 결제 서비스 호출하여 DB 업데이트
            ps.updatePaymentStatus(itemNo);
            return "redirect:/mypage/wonList"; // 성공 후 다시 마이페이지로
        } else {
            model.addAttribute("message", "결제 승인 실패: " + response.body());
            return "common/errorPage";
        }
    }
 // 결제 실패 처리
    @GetMapping("/fail")
    public String paymentFail(
            @RequestParam String message,
            @RequestParam String code,
            Model model) {
        model.addAttribute("errorMsg", "결제 실패: " + message + " (에러코드: " + code + ")");
        return "common/errorPage";
    }
}

