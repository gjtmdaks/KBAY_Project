package com.kh.kbay.admin.dao;

import java.util.List;
import java.util.Map;

import com.kh.kbay.bid.model.vo.Bid;
import com.kh.kbay.bid.model.vo.BidLogVo;
import com.kh.kbay.board.model.vo.BoardPost;
import com.kh.kbay.board.model.vo.Reply;
import com.kh.kbay.common.PageInfo;
import com.kh.kbay.item.model.vo.Item;
import com.kh.kbay.member.model.vo.Member;
import com.kh.kbay.mypage.model.vo.Faq;
import com.kh.kbay.mypage.model.vo.FaqImg;
import com.kh.kbay.report.model.vo.Report;

public interface AdminDao {

	// 가입자수, 진행중인 경매, 신고 내역
	int selectTotalMemberCount();
	
	int selectActiveAuctionsCount();
	
	int selectUnprocessedReportsCount();
	
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
	
	// 신고 내역 처리 부분
	int selectReportListCount(Map<String, Object> paramMap);
	
	List<Report> selectReportList(Map<String, Object> paramMap);
	
	Map<String, Object> selectReportTargetInfo(Map<String, Object> paramMap);
	
	List<Map<String, Object>> selectReportStats(Map<String, Object> paramMap);
	
	int updateTargetDeleteStatus(Map<String, Object> paramMap);
	
	int updateReportKeepStatus(Map<String, Object> paramMap);

	int selectInquiryListCount(Map<String, Object> paramMap);
	
	List<Faq> selectInquiryList(Map<String, Object> paramMap);
	
	Faq selectInquiryDetail(int faqId);
	
	List<FaqImg> selectInquiryFiles(int faqId);
	
	int insertInquiryAnswer(Map<String, Object> paramMap);
	
	// 경매 관리(종료 및 취소) 영역
	int selectAuctionListCount();
	
	List<Item> selectAdminAuctionList(Map<String, Object> paramMap);
	
	List<Bid> selectBidHistory(int itemNo);
	
	int updateAuctionStatus(int itemNo); // n -> c
  
	List<Map<String, Object>> selectItemListForAdmin();
	
	List<BidLogVo> selectBidLogsByItem(int itemNo);
	
    List<Member> getUserList();
    
    List<Bid> getUserBidLogs(int userNo);
    
 // 낙찰 취하 페이지
	int selectSuccessionCount();
	List<Item> selectSuccessionList(PageInfo pi);
	int updateForceFail(int itemNo);
	String selectTopBidType(int itemNo);
	int selectNextBidderCount(int itemNo);
	int updateCurrentBidderFail(int itemNo);
	int updateDeadlineExtend(int itemNo);

	List<Map<String, Object>> selectPaymentList(Map<String, Object> paramMap);
	
}
