package com.kh.kbay.board.dao;

import java.util.List;
import java.util.Map;

import com.kh.kbay.board.model.vo.BoardPost;

public interface BoardDao {

	int selectBoardListCount(Map<String, Object> paramMap);

	List<BoardPost> selectList(Map<String, Object> paramMap);

}
