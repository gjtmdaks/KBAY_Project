package com.kh.kbay.board.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.kbay.board.model.vo.BoardImg;
import com.kh.kbay.board.model.vo.BoardPost;

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
		return session.selectOne("boardPost.selectBoardListCount",paramMap);
	}

	@Override
	public List<BoardPost> selectList(Map<String, Object> paramMap) {
		// TODO Auto-generated method stub
		return session.selectList("boardPost.selectList",paramMap);
	}

	@Override
	public int insertBoard(BoardPost b) {
		// TODO Auto-generated method stub
		return session.insert("boardPost.insertBoard", b);
	}

	@Override
	public int insertBoardImgList(List<BoardImg> imgList) {
		// TODO Auto-generated method stub
		return session.insert("boardPost.insertBoardImgList", imgList);
	}

	@Override
	public BoardPost selectBoardDetail(int boardNo) {
		// TODO Auto-generated method stub
		return session.selectOne("boardPost.selectBoardDetail", boardNo);
	}

	@Override
	public List<BoardImg> selectBoardImg(int boardNo) {
		// TODO Auto-generated method stub
		return session.selectList("boardPost.selectBoardImg", boardNo);
	}
	
}
