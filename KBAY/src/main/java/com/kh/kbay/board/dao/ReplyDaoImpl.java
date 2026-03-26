package com.kh.kbay.board.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.kbay.board.model.vo.Reply;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Repository
@Slf4j
@RequiredArgsConstructor

public class ReplyDaoImpl implements ReplyDao {
	private final SqlSessionTemplate session;

	@Override
	public int insertReply(Map<String, Object> paramMap) {
		return session.insert("reply.insertReply", paramMap);
	}
	
	@Override
	public List<Reply> selectReplyList(Map<String, Object> map) {
		return session.selectList("reply.selectReplyList", map);
	}

	@Override
	public int deleteReply(int replyNo) {
		return session.delete("reply.deleteReply" , replyNo);
	}

	@Override
	public int selectReplyCount(int boardNo) {
		return session.selectOne("reply.selectReplyCount" , boardNo);
	}

	@Override
	public int updateReply(Reply r) {
		return session.update("reply.updateReply", r);
	}

	@Override
	public Reply selectReply(int replyNo) {
		return session.selectOne("reply.selectReply", replyNo);
	}
	
}
