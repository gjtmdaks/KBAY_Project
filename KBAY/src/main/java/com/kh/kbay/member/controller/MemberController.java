package com.kh.kbay.member.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kh.kbay.member.model.vo.Member;
import com.kh.kbay.member.service.MemberService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/")
@RequiredArgsConstructor
public class MemberController {
	private final MemberService ms;

	@GetMapping("agreeForm.me")
    public String agreeForm() {
        return "member/memberAgree";
    }

	@GetMapping("enrollForm.me")
    public String enrollForm() {
        return "member/memberEnroll";
    }

	@GetMapping("loginForm.me")
    public String loginForm() {
        return "member/login";
    }

	@PostMapping("login")
    public String loginForm(Member m, Model model) {
//		Member loginUser = ms.login(m);

	    if(/*loginUser == null*/true) {
            model.addAttribute("errorMsg", "로그인 실패");
            return "common/errorPage";
        }

        return "redirect:/";
    }
}
