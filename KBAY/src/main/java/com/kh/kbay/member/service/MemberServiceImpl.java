package com.kh.kbay.member.service;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import javax.mail.internet.MimeMessage;

import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.kbay.member.dao.MemberDao;
import com.kh.kbay.member.model.vo.Member;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service("SecurityServiceImpl")
@Slf4j
@RequiredArgsConstructor
public class MemberServiceImpl implements UserDetailsService, MemberService {
	private final MemberDao md;
    private final BCryptPasswordEncoder passwordEncoder;
    private final JavaMailSender mailSender;

    @Override
    public Member loadUserByUsername(String userId) throws UsernameNotFoundException {
        Member loginUser = md.loginUserById(userId);
        if (loginUser == null) {
            throw new UsernameNotFoundException(userId + "을 찾을 수 없습니다.");
        }
        return loginUser;
    }

    @Override
    @Transactional
    public int insertMember(Member m) {
        String encPwd = passwordEncoder.encode(m.getUserPwd());
        m.setUserPwd(encPwd);
        if(m.getAuthority() == 0) {
            m.setAuthority(1); 
        }
        int result = md.insertMember(m);
        
        if(result > 0) {
            log.info("회원가입 성공: {} - 인증 데이터 삭제", m.getUserEmail());
            md.deleteAuthCode(m.getUserEmail()); 
        }
        
        return result;
    }

	@Override
	public Member login(Member m) {
		return md.login(m);
	}
	@Override
	public int idCheck(String userId) {
		return md.idCheck(userId);
	}

	@Override
	public void updateAuth(int userNo) {
		md.updateAuth(userNo);
	}
	
	@Override
	public int emailCheck(String email) {
		return md.emailCheck(email);
	}
	
	@Override
    public String sendAuthEmail(String email) {
        Random r = new Random();
        String authCode = String.format("%06d", r.nextInt(1000000));
        
        Map<String, String> map = new HashMap<>();
        map.put("email", email);
        map.put("authCode", authCode);
        
        md.saveAuthCode(map);

        try {
            MimeMessage msg = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(msg, true, "utf-8");
            
            helper.setFrom("dustkd1693@gmail.com", "K-Bay 가입본인인증메일");
            helper.setTo(email);
            helper.setSubject("[K-Bay] 회원가입 인증번호입니다.");
            helper.setText("인증번호는 [" + authCode + "] 입니다.");
            
            mailSender.send(msg);
            return "success";
        } catch (Exception e) {
            e.printStackTrace();
            return "fail";
        }
    }

    @Override
    public boolean verifyCode(String email, String inputCode) {
        Map<String, String> map = new HashMap<>();
        map.put("email", email);
        map.put("inputCode", inputCode);
        
        int result = md.verifyCode(map);
        return result > 0;
    }
    
    
	
}

