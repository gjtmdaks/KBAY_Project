package com.kh.kbay.member.service;

import com.kh.kbay.member.model.vo.Member;

public interface MemberService {
	
	Member loadUserByUsername(String userId);

	Member login(Member m);

	int insertMember(Member m);

	int idCheck(String userId);

	void updateAuth(int userNo);

	String sendAuthEmail(String email);

	int emailCheck(String email);

	boolean verifyCode(String email, String inputCode);
	
    void sendOutbidEmail(String email, String itemTitle, int newPrice);
}
