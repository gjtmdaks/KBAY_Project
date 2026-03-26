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
		return session.selectOne("boardPost.selectBoardListCount",paramMap);
	}

	@Override
	public List<BoardPost> selectList(Map<String, Object> paramMap) {
		return session.selectList("boardPost.selectList",paramMap);
	}

	@Override
	public int insertBoard(BoardPost b) {
		return session.insert("boardPost.insertBoard", b);
	}

	@Override
	public int insertBoardImgList(List<BoardImg> imgList) {
		return session.insert("boardPost.insertBoardImgList", imgList);
	}

	@Override
	public BoardPost selectBoardDetail(int boardNo) {
		return session.selectOne("boardPost.selectBoardDetail", boardNo);
	}

	@Override
	public List<BoardImg> selectBoardImg(int boardNo) {
		return session.selectList("boardPost.selectBoardImg", boardNo);
	}

	@Override
	public int deleteBoard(int boardNo) {
		return session.delete("boardPost.deleteBoard", boardNo);
	}

	@Override
	public int updateBoard(BoardPost b) {
		return session.update("boardPost.updateBoard", b);
	}

	@Override
	public int deleteBoardImgList(List<Integer> deleteImgs) {
		return session.update("boardPost.deleteBoardImgList", deleteImgs);
	}

	@Override
	public void updateViewCoun(int boardNo) {
		session.update("boardPost.updateViewCoun", boardNo);
	}

	@Override
	public List<String> getAllImageNames() {
		return session.selectList("boardPost.getAllImageNames");
	}
	
}
