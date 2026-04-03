package com.kh.kbay.member.dao;

import java.util.Date;
import java.util.Map;

import com.kh.kbay.member.model.vo.Member;

public interface MemberDao {

	Member login(Member m);

	int insertMember(Member m);

	int idCheck(String userId);
	
	Member loginUserById(String userId);

	void updateAuth(int userNo);

	int emailCheck(String email);

	int verifyCode(Map<String, String> map);

	void saveAuthCode(Map<String, String> map);
	
	int deleteAuthCode(String email);

    Member selectMemberByUserNo(int userNo);

	Date selectSuspendEndDate(int userNo);

	void updateReleaseSuspend(int userNo);

	int deleteMailCode();

	
}
