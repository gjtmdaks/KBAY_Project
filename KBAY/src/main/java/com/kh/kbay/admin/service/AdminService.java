package com.kh.kbay.admin.service;

import java.util.List;
import java.util.Map;

import com.kh.kbay.board.model.vo.BoardPost;
import com.kh.kbay.board.model.vo.Reply;
import com.kh.kbay.item.model.vo.Item;
import com.kh.kbay.member.model.vo.Member;
import com.kh.kbay.mypage.model.vo.Faq;
import com.kh.kbay.mypage.model.vo.FaqImg;
import com.kh.kbay.report.model.vo.Report;

public interface AdminService {
	
	// 1. 현재 총 가입자 수
	int selectTotalMemberCount();
	// 2. 진행 중인 경매
	int selectActiveAuctionsCount();
	// 3. 미처리 신고 내역 건수 조회
	int selectUnprocessedReportsCount();

	int selectMemberListCount(Map<String, Object> safeMap);

	List<Member> selectMemberList(Map<String, Object> safeMap);

	Member selectMemberDetail(int userNo);

	List<Item> selectUserItemList(int userNo);

	List<BoardPost> selectUserPostList(int userNo);

	List<Reply> selectUserReplyList(int userNo);
	
	// 계정의 정지와 강제 탈퇴
	int suspendUser(Map<String, Object> paramMap);

	int deleteUser(int userNo);
	
	//회원이 받은 신고 내역 조회
	List<Report> selectUserReportList(int userNo);
	
	// 신고 내역 처리 부분
	int selectReportListCount(Map<String, Object> paramMap);
	List<Report> selectReportList(Map<String, Object> paramMap);
	
	Map<String, Object> selectReportTargetInfo(Map<String, Object> paramMap);
	List<Map<String, Object>> selectReportStats(Map<String, Object> paramMap);
	
	int updateReportProcess(Map<String, Object> paramMap);

	// count
	int selectInquiryListCount(Map<String, Object> paramMap);

	// list
	List<Faq> selectInquiryList(Map<String, Object> paramMap);

	// detail
	Faq selectInquiryDetail(int faqId);

	// file
	List<FaqImg> selectInquiryFiles(int faqId);

	// answer
	int insertInquiryAnswer(Map<String, Object> paramMap);

}
