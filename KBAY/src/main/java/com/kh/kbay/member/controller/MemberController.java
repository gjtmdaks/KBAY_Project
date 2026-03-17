package com.kh.kbay.member.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/")
public class MemberController {

	@RequestMapping("agreeForm.me")
    public String agreeForm() {
        return "member/memberAgree";
    }

	@RequestMapping("enrollForm.me")
    public String enrollForm() {
        return "member/memberEnroll";
    }

	@RequestMapping("loginForm.me")
    public String loginForm() {
        return "member/login";
    }
}
