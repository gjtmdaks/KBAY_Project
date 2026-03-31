package com.kh.kbay.member.controller;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.databind.ObjectMapper;
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
    public String loginForm(
    		HttpServletRequest request, 
            Model model, 
            @RequestParam(value = "error", required = false) String error) {
		
		if (error != null) {
            HttpSession session = request.getSession();
            // 시큐리티가 세션에 저장해둔 에러 객체 꺼내기
            Exception exception = (Exception) session.getAttribute("SPRING_SECURITY_LAST_EXCEPTION");
            
            String errorMessage = "아이디 또는 비밀번호가 일치하지 않습니다."; // 기본값
            
            if (exception != null) {
                // 우리가 예외로 던졌던 "이 계정은 임시 정지된 계정입니다." 문자열을 가져옴
                errorMessage = exception.getMessage();
                
                // ★ 중요: 한번 화면에 띄울 거니까 세션에서 에러를 지워줍니다!
                session.removeAttribute("SPRING_SECURITY_LAST_EXCEPTION");
            }
            
            model.addAttribute("loginErrorMsg", errorMessage);
        }
		
        return "member/login";
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

	    String impUid = param.get("imp_uid");

	    try {
	        // 1️. 아임포트 토큰 발급
	        String accessToken = getAccessToken();

	        // 2️. imp_uid로 인증 정보 조회
	        Map<String, Object> certInfo = getCertificationInfo(impUid, accessToken);

	        if(certInfo != null) {

	        	Member loginUser = (Member) auth.getPrincipal();

	        	String certName = certInfo.get("name") != null 
	        		    ? ((String) certInfo.get("name")).trim() 
	        		    : "";

	        	String certPhone = certInfo.get("phone") != null 
	        		    ? ((String) certInfo.get("phone")).replaceAll("-", "") 
	        		    : "";

	            String dbName = loginUser.getUserName().trim();
	            String dbPhone = loginUser.getUserPhone().replaceAll("-", "");
	        	

	            if(dbName.equals(certName) && dbPhone.equals(certPhone)) {

	                // 인증 성공
	                ms.updateAuth(loginUser.getUserNo());

	            } else {
	                return "mismatch"; // 불일치
	            }

	            // 4️. SecurityContext 갱신
	            Member updatedUser = ms.loadUserByUsername(loginUser.getUserId());

	            Authentication newAuth =
	                new UsernamePasswordAuthenticationToken(
	                    updatedUser,
	                    auth.getCredentials(),
	                    updatedUser.getAuthorities()
	                );

	        	System.out.println("newAuth : "+newAuth);

	            SecurityContextHolder.getContext().setAuthentication(newAuth);

	            return "success";
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return "fail";
	}
	
	private String getAccessToken() throws Exception {

	    URL url = new URL("https://api.iamport.kr/users/getToken");

	    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
	    conn.setRequestMethod("POST");
	    conn.setRequestProperty("Content-Type", "application/json");
	    conn.setDoOutput(true);

	    String body = "{"
	    	    + "\"imp_key\":\"6004241332626301\","
	    	    + "\"imp_secret\":\"pk4V18nJwVfp4aLZ8zj4Kza4pddCGw2NObUIKBXAnAB9cxnoXVpbw2QQZGItzRYVrPqgcaBmkOWDvSp0\""
	    	    + "}";
	    // 1. 먼저 body 작성
	    try (OutputStream os = conn.getOutputStream()) {
	        os.write(body.getBytes("UTF-8"));
	        os.flush();
	    }

	    // 2. 그 다음 응답 코드 확인
	    int responseCode = conn.getResponseCode();

	    BufferedReader br;

	    if (responseCode == 200) {
	        br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
	    } else {
	        br = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
	    }

	    StringBuilder sb = new StringBuilder();
	    String line;

	    while ((line = br.readLine()) != null) {
	        sb.append(line);
	    }

	    String response = sb.toString();

	    // JSON 파싱해서 access_token 추출 (Jackson 추천)
	    return extractToken(response);
	}
	
	private Map<String, Object> getCertificationInfo(String impUid, String token) throws Exception {

	    URL url = new URL("https://api.iamport.kr/certifications/" + impUid);

	    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
	    conn.setRequestMethod("GET");
	    conn.setRequestProperty("Authorization", token);

	    BufferedReader br = new BufferedReader(
	        new InputStreamReader(conn.getInputStream()));

	    StringBuilder sb = new StringBuilder();
	    String line;

	    while ((line = br.readLine()) != null) {
	        sb.append(line);
	    }

	    String response = sb.toString();

	    // JSON 파싱 (name, phone 등 확인 가능)
	    return parseCertification(response);
	}
	
	private String extractToken(String response) throws Exception {

	    ObjectMapper mapper = new ObjectMapper();

	    Map<String, Object> map = mapper.readValue(response, Map.class);

	    Object responseObj = map.get("response");

	    if (responseObj == null) {
	        throw new RuntimeException("response null: " + response);
	    }

	    Map<String, Object> res = (Map<String, Object>) responseObj;

	    Object tokenObj = res.get("access_token");

	    if (tokenObj == null) {
	        throw new RuntimeException("access_token 없음: " + response);
	    }

	    return tokenObj.toString();
	}
	
	private Map<String, Object> parseCertification(String response) throws Exception {

	    ObjectMapper mapper = new ObjectMapper();

	    Map<String, Object> map = mapper.readValue(response, Map.class);

	    return (Map<String, Object>) map.get("response");
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
