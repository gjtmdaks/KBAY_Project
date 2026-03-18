package com.kh.kbay.board.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.kh.kbay.board.dao.BoardDao;
import com.kh.kbay.board.model.vo.Board;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class BoardServiceImpl implements BoardService {

	private final BoardDao boardDao;
	
	@Override
	public int selectBoardListCount(Map<String, Object> paramMap) {
		// TODO Auto-generated method stub
		return boardDao.selectBoardListCount(paramMap);
	}

	@Override
	public List<Board> selectList(Map<String, Object> paramMap) {
		// TODO Auto-generated method stub
		return boardDao.selectList(paramMap);
	}

	
}
