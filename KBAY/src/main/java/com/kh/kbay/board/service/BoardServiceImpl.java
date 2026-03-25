package com.kh.kbay.board.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.kh.kbay.board.dao.BoardDao;
import com.kh.kbay.board.model.vo.BoardImg;
import com.kh.kbay.board.model.vo.BoardPost;
import com.kh.kbay.board.model.vo.Reply;

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
			
			boardDao.insertBoardImgList(imgList);
		}
		
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

	@Override
	public int deleteBoard(int boardNo) {
		// TODO Auto-generated method stub
		return boardDao.deleteBoard(boardNo);
	}

	@Override
	public int insertReply(Map<String, Object> paramMap) {
		// TODO Auto-generated method stub
		return boardDao.insertReply(paramMap);
	}
	
	@Override
	public List<Reply> selectReplyList(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return boardDao.selectReplyList(map);
	}
	
	
	@Override
	public int deleteReply(int replyNo) {
		// TODO Auto-generated method stub
		return boardDao.deleteReply(replyNo);
	}

	@Override
	public int selectReplyCount(int boardNo) {
		// TODO Auto-generated method stub
		return boardDao.selectReplyCount(boardNo);
	}

	@Override
	public int updateBoard(BoardPost b, List<Integer> deleteImgs, List<BoardImg> newImgList) {
		// TODO Auto-generated method stub
		
		int result = boardDao.updateBoard(b);
		if(result == 0) {
			throw new RuntimeException("게시글 변경 실패");
		}
		
		if(deleteImgs != null && !deleteImgs.isEmpty()) {
			// 삭제할 파일 번호 리스트를 DAO에 통째로 넘겨서 삭제 (또는 상태 'Y' 변경)
			int deleteResult = boardDao.deleteBoardImgList(deleteImgs);
			if(deleteResult == 0) {
				throw new RuntimeException("기존 첨부파일 삭제 실패");
			}
		}
		
		if(newImgList != null && !newImgList.isEmpty()) {
			for(BoardImg bi : newImgList) {
				bi.setBoardNo(b.getBoardNo());
			}
			
			int insertResult = boardDao.insertBoardImgList(newImgList);
			if(insertResult == 0) {
				throw new RuntimeException("새 첨부파일 추가 실패");
			}
		}
		return result;
	}

	@Override
	public void updateViewCount(int boardNo) {
		// TODO Auto-generated method stub
		boardDao.updateViewCoun(boardNo);
	}

	


	

	

	
}
