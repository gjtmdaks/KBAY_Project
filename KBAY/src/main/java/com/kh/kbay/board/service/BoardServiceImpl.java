package com.kh.kbay.board.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.kh.kbay.board.dao.BoardDao;
import com.kh.kbay.board.model.vo.BoardImg;
import com.kh.kbay.board.model.vo.BoardPost;

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
	public List<BoardPost> selectList(Map<String, Object> paramMap) {
		// TODO Auto-generated method stub
		return boardDao.selectList(paramMap);
	}

	@Override
	public int insertBoard(BoardPost b, List<BoardImg> imgList) {
		int result = boardDao.insertBoard(b);
		if(result == 0) {
			throw new RuntimeException("게시글 등록 실패");
		}
		
		// 2. 첨부파일 데이터 insert
		if(!imgList.isEmpty()) {
			for(BoardImg bi : imgList) {
				bi.setBoardNo(b.getBoardNo());
				
				
				
			}
			result = boardDao.insertBoardImgList(imgList);
			
			if(result != imgList.size()) {
				throw new RuntimeException("첨부파일 등록 에러 발생");
			}
		}
		return result;
	}

	
}
