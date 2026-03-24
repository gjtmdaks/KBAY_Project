package com.kh.kbay.member.controller;

import java.util.Map;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
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
	        ra.addFlashAttribute("alertMsg", "회원가입에 성공했습니다!");
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

	@GetMapping("mypage.me")
	public String myPageForm() {
		return "mypage/mypageHome";
	}
	
	@GetMapping("verify")
	public String verifyPage() {
	    return "member/verify";
	}
	
	@PostMapping("verify")
	@ResponseBody
	public String verifySuccess(
			@RequestBody Map<String, String> param,
            Authentication auth) {
		String name = param.get("name");
	    String rrn1 = param.get("rrn1");
	    String rrn2 = param.get("rrn2");

	    // ✅ 여기서 실제로는 외부 API (PASS / 아임포트) 써야됨
	    // 지금은 테스트용으로 단순 체크

	    System.out.println(rrn1.length());
	    System.out.println(rrn2.length());
	    
	    if(rrn1.length() == 6 && rrn2.length() == 7) {

	        Member loginUser = (Member) auth.getPrincipal();

	        // 1️. DB 업데이트
	        ms.updateAuth(loginUser.getUserNo());

	        // 2️. 최신 사용자 정보 다시 조회
	        Member updatedUser = ms.loadUserByUsername(loginUser.getUserId());

	        // 3️. 새로운 Authentication 생성
	        Authentication newAuth = new UsernamePasswordAuthenticationToken(
	                updatedUser,
	                auth.getCredentials(),
	                updatedUser.getAuthorities()
	        );

	        // 4️. SecurityContext 갱신
	        SecurityContextHolder.getContext().setAuthentication(newAuth);

	        return "success";
	    }
	    return "fail";
	}
	    
	@ResponseBody
	@GetMapping("sendMail.me")
	public String sendMail(String email) {
	    int count = ms.emailCheck(email);
	    
	    if (count > 0) {
	        return "duplicated"; 
	    }
	    
	    return ms.sendAuthEmail(email); 
	}

	    @ResponseBody
	    @PostMapping("checkCode.me")
	    public String checkCode(String email, String inputCode) {
	        // 사용자가 입력한 코드와 DB에 저장된 코드를 비교하는 로직
	         boolean isMatch = ms.verifyCode(email, inputCode);
	        
	        return isMatch ? "success" : "fail";
	        
	    }

	
}
