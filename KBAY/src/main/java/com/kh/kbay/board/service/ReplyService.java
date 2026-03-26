package com.kh.kbay.board.service;

import java.util.List;
import java.util.Map;

import com.kh.kbay.board.model.vo.Reply;

public interface ReplyService {
	
	int insertReply(Map<String, Object> paramMap);
	
	List<Reply> selectReplyList(Map<String, Object> map);
	
	int deleteReply(int replyNo);
	
	int selectReplyCount(int boardNo);

	int updateReply(Reply r);

	Reply selectReply(int replyNo);

}
