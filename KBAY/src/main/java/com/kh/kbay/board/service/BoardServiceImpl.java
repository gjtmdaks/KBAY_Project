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
		
		// 1. 게시글 등록! (성공하면 result에 1이 들어감)
		int result = boardDao.insertBoard(b);
		if(result == 0) {
			throw new RuntimeException("게시글 등록 실패");
		}
		
		// 2. 첨부파일 데이터 insert
		if(!imgList.isEmpty()) {
			for(BoardImg bi : imgList) {
				bi.setBoardNo(b.getBoardNo());
			}
			
			// 🌟 핵심 수정!! result에 덮어씌우지 말고 그냥 실행만 하세요! 🌟
			// result = boardDao.insertBoardImgList(imgList); (❌ 지우세요!)
			boardDao.insertBoardImgList(imgList); // (⭕ 그냥 실행만!)
		}
		
		// 3. 처음에 게시글 등록 성공했던 '1'을 그대로 컨트롤러에 돌려줍니다!
		return result; 
	}

	@Override
	public BoardPost selectBoardDetail(int boardNo) {
		// TODO Auto-generated method stub
		return boardDao.selectBoardDetail(boardNo);
	}

	@Override
	public List<BoardImg> selectBoardImg(int boardNo) {
		// TODO Auto-generated method stub
		return boardDao.selectBoardImg(boardNo);
	}

	
}
