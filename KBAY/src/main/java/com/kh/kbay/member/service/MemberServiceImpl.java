package com.kh.kbay.member.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.kh.kbay.member.dao.MemberDao;
import com.kh.kbay.member.model.vo.Member;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service("securityServiceImpl")
@Slf4j
@RequiredArgsConstructor
public class MemberServiceImpl implements UserDetailsService, MemberService {
	private final MemberDao md;
	
	
	
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		Member loginUser = md.loginUserById(username);

		if (loginUser == null) {
			throw new UsernameNotFoundException(username + "을 찾을 수 없습니다.");
		}

		return loginUser;
	}

	@Override
	public Member login(Member m) {
		return md.login(m);
	}

	@Autowired
	private BCryptPasswordEncoder bcryptPasswordEncoder;
	
	@Override
	public int insertMember(Member m) {
		
		String encPwd = bcryptPasswordEncoder.encode(m.getUserPwd());
		
		m.setUserPwd(encPwd);
		
		if(m.getAuthority() == null) {
			m.setAuthority("ROLE_USER");
		}
		return md.insertMember(m);
	}

	@Override
	public int idCheck(String userId) {
		return md.idCheck(userId);
	}
}
