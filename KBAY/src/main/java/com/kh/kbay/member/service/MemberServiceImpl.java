package com.kh.kbay.member.service;

import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

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

    @Override
    public Member loadUserByUsername(String userId) throws UsernameNotFoundException {
        Member loginUser = md.loginUserById(userId);
        if (loginUser == null) {
            throw new UsernameNotFoundException(userId + "을 찾을 수 없습니다.");
        }
        return loginUser;
    }

    @Override
    public int insertMember(Member m) {
        String encPwd = passwordEncoder.encode(m.getUserPwd());
        m.setUserPwd(encPwd);
        if(m.getAuthority() == 0) {
            m.setAuthority(1); 
        }
        
        return md.insertMember(m);
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
}

