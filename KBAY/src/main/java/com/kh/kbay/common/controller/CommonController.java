package com.kh.kbay.common.controller;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class CommonController {

    @GetMapping("/security/accessDenied")
    public String accessDenied(Authentication auth) {
        log.error("===== [권한 거부 발생] =====");
        if (auth != null) {
            log.error("아이디: {}, 권한: {}", auth.getName(), auth.getAuthorities());
        }
        return "common/errorPage";
    }
}