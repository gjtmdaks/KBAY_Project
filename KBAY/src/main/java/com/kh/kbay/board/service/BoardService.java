package com.kh.kbay.board.service;

import java.util.List;
import java.util.Map;

import com.kh.kbay.board.model.vo.BoardImg;
import com.kh.kbay.board.model.vo.BoardPost;

public interface BoardService {
	
	int selectBoardListCount(Map<String, Object> paramMap);

	List<BoardPost> selectList(Map<String, Object> paramMap);

	int insertBoard(BoardPost b, List<BoardImg> imgList);

	BoardPost selectBoardDetail(int boardNo);

	
}
