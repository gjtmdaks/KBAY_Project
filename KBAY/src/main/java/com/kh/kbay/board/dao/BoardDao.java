package com.kh.kbay.board.dao;

import java.util.List;
import java.util.Map;

import com.kh.kbay.board.model.vo.BoardImg;
import com.kh.kbay.board.model.vo.BoardPost;

public interface BoardDao {

	int selectBoardListCount(Map<String, Object> paramMap);

	List<BoardPost> selectList(Map<String, Object> paramMap);

	int insertBoard(BoardPost b);

	int insertBoardImgList(List<BoardImg> imgList);

	BoardPost selectBoardDetail(int boardNo);

	List<BoardImg> selectBoardImg(int boardNo);

	int deleteBoard(int boardNo);

}
