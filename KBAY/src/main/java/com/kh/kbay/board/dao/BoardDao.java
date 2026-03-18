package com.kh.kbay.board.dao;

import java.util.List;
import java.util.Map;

import com.kh.kbay.board.model.vo.Board;

public interface BoardDao {

	int selectBoardListCount(Map<String, Object> paramMap);

	List<Board> selectList(Map<String, Object> paramMap);

}
