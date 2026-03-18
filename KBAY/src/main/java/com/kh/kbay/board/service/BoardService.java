package com.kh.kbay.board.service;

import java.util.List;
import java.util.Map;

import com.kh.kbay.board.model.vo.Board;

public interface BoardService {
	
	int selectBoardListCount(Map<String, Object> paramMap);

	List<Board> selectList(Map<String, Object> paramMap);

	
}
