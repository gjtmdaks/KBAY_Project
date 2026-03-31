package com.kh.kbay.wish.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.kh.kbay.member.model.vo.Member;
import com.kh.kbay.wish.service.WishService;

@RestController
@RequestMapping("/wishlist")
public class WishController {

    @Autowired
    private WishService ws;

    @PostMapping("/toggle")
    public ResponseEntity<Map<String, String>> toggleWishlist(@RequestBody Map<String, Object> param,
            Authentication auth) {

        if (auth == null || !(auth.getPrincipal() instanceof Member)) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        Member loginUser = (Member) auth.getPrincipal();
        
        int userNo = loginUser.getUserNo();
        int itemNo = Integer.parseInt(String.valueOf(param.get("itemNo")));

        Map<String, Object> map = new HashMap<>();
        map.put("userNo", userNo);
        map.put("itemNo", itemNo);

        String result = ws.toggleWishlist(map);

        Map<String, String> response = new HashMap<>();
        response.put("result", result);

        return ResponseEntity.ok(response);
    }
}