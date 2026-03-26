package com.kh.kbay.admin.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.kbay.board.model.vo.BoardPost;
import com.kh.kbay.item.model.vo.Item;
import com.kh.kbay.member.model.vo.Member;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Repository
@Slf4j
@RequiredArgsConstructor
public class AdminDaoImpl implements AdminDao {
	
	private final SqlSessionTemplate session;

	@Override
	public int selectMemberListCount(Map<String, Object> safeMap) {
		// TODO Auto-generated method stub
		return session.selectOne("adminMapper.selectMemberListCount", safeMap);
	}

	@Override
	public List<Member> selectMemberList(Map<String, Object> safeMap) {
		// TODO Auto-generated method stub
		return session.selectList("adminMapper.selectMemberList", safeMap);
	}

	@Override
	public Member selectMemberDetail(int userNo) {
		// TODO Auto-generated method stub
		return session.selectOne("adminMapper.selectMemberDetail", userNo);
	}

	@Override
	public List<Item> selectUserItemList(int userNo) {
		// TODO Auto-generated method stub
		return session.selectList("adminMapper.selectUserItemList", userNo);
	}

	@Override
    public List<BoardPost> selectUserPostList(int userNo) {
        // sqlSession(또는 session)을 사용해서 XML 쿼리를 부르는 곳
        return session.selectList("adminMapper.selectUserPostList", userNo);
    }
	
	
	
}
