package com.kh.kbay.member.controller;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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
	private final BCryptPasswordEncoder bcryptPasswordEncoder;

	@GetMapping("agreeForm.me")
    public String agreeForm() {
        return "member/memberAgree";
    }

	@GetMapping("enrollForm.me")
	public String enrollForm(
	        	@RequestParam(required=false) String marketingAgree
				) {
	    if(marketingAgree == null){
	        marketingAgree = "N";
	    }
	    System.out.println("마케팅 동의 여부 : " + marketingAgree);

	    return "member/memberEnroll";
	}
	
	@ResponseBody
	@GetMapping("idCheck.me")
	public String idCheck(String userId){

	    int count = ms.idCheck(userId);

	    if(count > 0){
	        return "NNNNN"; // 사용불가
	    }else{
	        return "NNNNY"; // 사용가능
	    }
	}
	
	@PostMapping("insertMember.me")
	public String insertMember(Member m, Model model, RedirectAttributes ra) {
		int result = ms.insertMember(m);
	    
	    if(result > 0) {
	        ra.addFlashAttribute("alertMsg", "회원가입 성공");
	        return "redirect:/";
	    } else {
	        model.addAttribute("errorMsg", "회원가입 실패");
	        return "common/errorPage";
	    }
	}

	@GetMapping("insertForm.me")
    public String insertForm() {
        return "member/memberInsert";
    }

	@GetMapping("login")
    public String loginForm() {
        return "member/login";
    }


	

}
