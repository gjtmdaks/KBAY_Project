package com.kh.kbay.board.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.kbay.board.model.vo.Board;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Repository
@Slf4j
@RequiredArgsConstructor
public class BoardDaoImpl implements BoardDao {
	
	private final SqlSessionTemplate session;
	
	@Override
	public int selectBoardListCount(Map<String, Object> paramMap) {
		// TODO Auto-generated method stub
		return session.selectOne("board.selectBoardListCount",paramMap);
	}

	@Override
	public List<Board> selectList(Map<String, Object> paramMap) {
		// TODO Auto-generated method stub
		return session.selectList("selectList",paramMap);
	}
	
}
