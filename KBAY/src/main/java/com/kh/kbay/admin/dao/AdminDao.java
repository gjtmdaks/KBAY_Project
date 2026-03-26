package com.kh.kbay.admin.dao;

import java.util.List;
import java.util.Map;

import com.kh.kbay.board.model.vo.BoardPost;
import com.kh.kbay.item.model.vo.Item;
import com.kh.kbay.member.model.vo.Member;

public interface AdminDao {

	int selectMemberListCount(Map<String, Object> safeMap);

	List<Member> selectMemberList(Map<String, Object> safeMap);

	Member selectMemberDetail(int userNo);

	List<Item> selectUserItemList(int userNo);

	List<BoardPost> selectUserPostList(int userNo);

}
