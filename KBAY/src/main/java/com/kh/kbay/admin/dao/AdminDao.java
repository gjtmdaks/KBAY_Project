package com.kh.kbay.admin.dao;

import java.util.List;
import java.util.Map;

import com.kh.kbay.board.model.vo.BoardPost;
import com.kh.kbay.board.model.vo.Reply;
import com.kh.kbay.item.model.vo.Item;
import com.kh.kbay.member.model.vo.Member;
import com.kh.kbay.report.model.vo.Report;

public interface AdminDao {

	int selectMemberListCount(Map<String, Object> safeMap);

	List<Member> selectMemberList(Map<String, Object> safeMap);

	Member selectMemberDetail(int userNo);

	List<Item> selectUserItemList(int userNo);

	List<BoardPost> selectUserPostList(int userNo);

	List<Reply> selectUserReplyList(int userNo);

	// USER_SANCTION에 기록
	int insertSuspendUserSanctionRecord(Map<String, Object> paramMap);
	// MEMBER의 제제 상태 여부 변경
	int updateSuspendUserStatusUpdate(Map<String, Object> paramMap);
	
	// 영구 정지
	int updateUserStatusDelete(int userNo);

	List<Report> selectUserReportList(int userNo);



}
