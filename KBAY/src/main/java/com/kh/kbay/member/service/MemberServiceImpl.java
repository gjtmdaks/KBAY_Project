package com.kh.kbay.member.service;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
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
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Member login(Member m) {
		Member loginUser = md.login(m);

	    if(loginUser != null && loginUser.getUserPwd().equals(m.getUserPwd())) {
	        return loginUser;
	    }

	    return null;
	}

	@Override
	public int insertMember(Member m) {
		return md.insertMember(m);
	}

	@Override
	public int idCheck(String userId) {
		return md.idCheck(userId);
	}
}
