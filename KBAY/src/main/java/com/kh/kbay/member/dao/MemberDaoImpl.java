package com.kh.kbay.member.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.kbay.member.model.vo.Member;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Repository
@Slf4j
@RequiredArgsConstructor
public class MemberDaoImpl implements MemberDao {
	private final SqlSessionTemplate session;

	@Override
	public Member login(Member m) {
		return session.selectOne("member.login", m);
	}

	@Override
	public int insertMember(Member m) {
		return session.insert("member.insertMember", m);
	}

	@Override
	public int idCheck(String userId) {
		return session.selectOne("member.idCheck", userId);
	}

	@Override
	public Member loginUserById(String userId) {
		return session.selectOne("member.loginUserById", userId);
	}
	
}
