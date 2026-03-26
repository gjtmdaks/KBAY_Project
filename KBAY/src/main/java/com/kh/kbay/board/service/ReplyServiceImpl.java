package com.kh.kbay.board.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.kh.kbay.board.dao.ReplyDao;
import com.kh.kbay.board.model.vo.Reply;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class ReplyServiceImpl implements ReplyService {
	private final ReplyDao rd;
	
	@Override
	public int insertReply(Map<String, Object> paramMap) {
		return rd.insertReply(paramMap);
	}
	
	@Override
	public List<Reply> selectReplyList(Map<String, Object> map) {
		return rd.selectReplyList(map);
	}
	
	@Override
	public int deleteReply(int replyNo) {
		return rd.deleteReply(replyNo);
	}

	@Override
	public int selectReplyCount(int boardNo) {
		return rd.selectReplyCount(boardNo);
	}

	@Override
	public int updateReply(Reply r) {
		return rd.updateReply(r);
	}

	@Override
	public Reply selectReply(int replyNo) {
		return rd.selectReply(replyNo);
	}
	
}
