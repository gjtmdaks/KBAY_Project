package com.kh.kbay.member.service;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import javax.mail.internet.MimeMessage;

import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
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
    
    // 신규 최상위 입찰자가 나타났을 때 메일 전송
    @Async
    @Override
    public void sendOutbidEmail(String email, String itemTitle, int newPrice) {
        try {
            MimeMessage msg = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(msg, true, "utf-8");
            
            helper.setFrom("dustkd1693@gmail.com", "K-Bay 경매알림");
            helper.setTo(email);
            helper.setSubject("[K-Bay] 입찰 순위 변동 알림입니다.");
            
            String content = "<h3>입찰 알림</h3>"
                           + "<p>회원님이 입찰하신 <b>[" + itemTitle + "]</b> 상품에 더 높은 금액의 입찰자가 나타났습니다.</p>"
                           + "<p>새로운 현재가: <span style='color:red;'>" + String.format("%,d", newPrice) + "원</span></p>"
                           + "<p>낙찰을 위해 다시 입찰에 참여해보세요!</p>";
            
            helper.setText(content, true);
            mailSender.send(msg);
            log.info("비동기 알림 메일 발송 완료: {}", email);
        } catch (Exception e) {
            log.error("메일 발송 중 오류 발생", e);
        }
    }
    
	
}

