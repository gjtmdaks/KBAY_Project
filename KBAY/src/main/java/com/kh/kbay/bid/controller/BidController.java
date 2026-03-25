package com.kh.kbay.bid.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.kh.kbay.bid.model.vo.Bid;
import com.kh.kbay.bid.service.BidService;
import com.kh.kbay.member.model.vo.Member;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
@RequestMapping("/bid")
@RequiredArgsConstructor
public class BidController {
	private final BidService bs;
	
	@PostMapping
	public Map<String, Object> bid(
	        @RequestBody Bid req,
	        HttpServletRequest request,
	        Authentication auth){

	    Map<String, Object> result = new HashMap<>();

	    // 1. 로그인 체크
	    if(auth == null || !auth.isAuthenticated()) {
	        result.put("result", "FAIL");
	        result.put("message", "LOGIN_REQUIRED");
	        return result;
	    }

	    try {
	        Member user = (Member) auth.getPrincipal();
	        req.setUserNo(user.getUserNo());
	        
	        //입찰 시점 IP 주소 추출
	        String ip = request.getHeader("X-Forwarded-For");
	        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
	            ip = request.getHeader("Proxy-Client-IP");
	        }
	        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
	            ip = request.getRemoteAddr();
	        }
	        
	        // 로컬 테스트 IP 주소
	        if("0:0:0:0:0:0:0:1".equals(ip)) {
	            ip = "127.0.0.1";
	        }
	        
	        req.setBidIp(ip);
	        int ranking = bs.placeBid(req);
	        
	        result.put("result", "SUCCESS");
	        result.put("ranking", ranking);

	    } catch (IllegalArgumentException e) {
	        // 👉 입찰 금액 문제
	        result.put("result", "FAIL");
	        result.put("message", e.getMessage());

	    } catch (IllegalStateException e) {
	        // 👉 상태 문제 (종료 등)
	        result.put("result", "FAIL");
	        result.put("message", e.getMessage());

	    } catch (Exception e) {
	        // 👉 기타 에러
	        log.error("입찰 오류", e);
	        result.put("result", "FAIL");
	        result.put("message", "서버 오류");
	    }

	    return result;
	}
	
	@GetMapping("/price/{itemNo}")
	public Map<String, Object> getPrice(@PathVariable int itemNo){

	    Map<String, Object> result = new HashMap<>();

	    int currentPrice = bs.selectCurrentPrice(itemNo);
	    int bidCount = bs.selectBidCount(itemNo);

	    result.put("currentPrice", currentPrice);
	    result.put("bidCount", bidCount);

	    return result;
	}
	
	@GetMapping("/history/{itemNo}")
	public List<Bid> getBidHistory(@PathVariable int itemNo) {
	    return bs.selectBidHistory(itemNo);
	}
}
