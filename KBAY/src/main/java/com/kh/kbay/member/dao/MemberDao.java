package com.kh.kbay.member.dao;

import com.kh.kbay.member.model.vo.Member;

public interface MemberDao {

	Member login(Member m);

	int insertMember(Member m);

	int idCheck(String userId);

	Member loginUserById(String username);

}
