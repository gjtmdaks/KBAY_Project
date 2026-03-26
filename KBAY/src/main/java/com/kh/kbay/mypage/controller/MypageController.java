package com.kh.kbay.mypage.controller;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kh.kbay.member.model.vo.Member;
import com.kh.kbay.mypage.model.vo.MyPageSummary;
import com.kh.kbay.mypage.service.MypageService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/mypage")
@RequiredArgsConstructor
public class MypageController {
	private final MypageService ms;
	
	@GetMapping("mypage.me")
	public String myPageForm(Authentication auth, Model model) {
	    Member loginUser = (Member) auth.getPrincipal();

	    MyPageSummary summary = ms.getSummary(loginUser.getUserNo());
	    int accidentCount = ms.getAccidentCount(loginUser.getUserNo());

	    model.addAttribute("summary", summary);
	    model.addAttribute("accidentCount", accidentCount);
	    model.addAttribute("user", loginUser);

	    return "mypage/mypageHome";
	}
}
