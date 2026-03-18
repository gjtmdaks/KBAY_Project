package com.kh.kbay.member.controller;

import javax.servlet.http.HttpSession;

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
@RequestMapping("/member")
@RequiredArgsConstructor
public class MemberController {
	private final MemberService ms;
	private final HttpSession session;

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
		Member loginUser = ms.login(m);

	    if(loginUser == null) {
            model.addAttribute("errorMsg", "로그인 실패");
            return "common/errorPage";
        }

	    session.setAttribute("loginUser", loginUser);

        return "redirect:/";
    }
	
	@GetMapping("logout.me")
	public String logout(HttpSession session) {

	    session.invalidate();

	    return "redirect:/";
	}
}
