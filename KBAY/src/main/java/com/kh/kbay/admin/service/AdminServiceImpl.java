package com.kh.kbay.admin.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.kbay.admin.dao.AdminDao;
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

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class AdminServiceImpl implements AdminService {
	
	private final AdminDao ad;
	
	@Override
	public int selectTotalMemberCount() {
		return ad.selectTotalMemberCount();
	}

	@Override
	public int selectActiveAuctionsCount() {
		return ad.selectActiveAuctionsCount();
	}

	@Override
	public int selectUnprocessedReportsCount() {
		return ad.selectUnprocessedReportsCount();
	}
	
	@Override
	public int selectMemberListCount(Map<String, Object> safeMap) {
		// 전체 회원 수 가져오기
		return ad.selectMemberListCount(safeMap);
	}

	@Override
	public List<Member> selectMemberList(Map<String, Object> safeMap) {
		// 페이징된 회원 목록 가져오기
		return ad.selectMemberList(safeMap);
	}

	@Override
	public Member selectMemberDetail(int userNo) {
		// 특정 회원 1명의 상세 정보 가져오기
		return ad.selectMemberDetail(userNo);
	}

	@Override
	public List<Item> selectUserItemList(int userNo) {
		// 회원이 등록한 경매 물품 목록 가져오기
		return ad.selectUserItemList(userNo);
	}

	@Override
	public List<BoardPost> selectUserPostList(int userNo) {
		// 회원이 작성한 게시글 목록 가져오기 (게시판 VO 이름이 BoardPost 군요!)
		return ad.selectUserPostList(userNo);
	}

	@Override
	public List<Reply> selectUserReplyList(int userNo) {
		return ad.selectUserReplyList(userNo);
	}
	
	// 계정의 정지
	@Transactional
	@Override
	public int suspendUser(Map<String, Object> paramMap) {
        int result1 = ad.insertSuspendUserSanctionRecord(paramMap); // USER_SANCTION 제제 기록 기입
        int result2 = ad.updateSuspendUserStatusUpdate(paramMap); // MEMBER의 제제 상태 여부 변경
        
        return (result1 > 0 && result2 > 0) ? 1 : 0; 
    }
	
	// 강제 탈퇴
	@Override
	public int deleteUser(int userNo) {
        // 영구 정지: MEMBER의 STATUS='Y', DELETE_YN='Y' 로 변경
        return ad.updateUserStatusDelete(userNo);
    }
	
	// 회원이 받은 신고 내역
	@Override
	public List<Report> selectUserReportList(int userNo) {
		return ad.selectUserReportList(userNo);
	}
	
	// 신고 내역 처리 부분
	@Override
	public int selectReportListCount(Map<String, Object> paramMap) {
		return ad.selectReportListCount(paramMap);
	}
	
	@Override
	public List<Report> selectReportList(Map<String, Object> paramMap) {
		return ad.selectReportList(paramMap);
	}

	@Override
	public Map<String, Object> selectReportTargetInfo(Map<String, Object> paramMap) {
		return ad.selectReportTargetInfo(paramMap);
	}

	@Override
	public List<Map<String, Object>> selectReportStats(Map<String, Object> paramMap) {
		return ad.selectReportStats(paramMap);
	}

	@Override
	public int updateReportProcess(Map<String, Object> paramMap) {
		int result = 0;
		String action = (String) paramMap.get("action");
		
		// 1. [강제 삭제]를 선택했다면? -> 원본 글 지우는 DAO 호출!
		if ("DELETE".equals(action)) {
			result = ad.updateTargetDeleteStatus(paramMap);
		}
		
		// 2. [강제 삭제]든 [정상 유지]든 무조건 실행! -> 신고 완료 처리 DAO 호출!
		int reportResult = ad.updateReportKeepStatus(paramMap);
		
		return result + reportResult;
	}

	@Override
	public int selectInquiryListCount(Map<String, Object> paramMap) {
	    return ad.selectInquiryListCount(paramMap);
	}

	@Override
	public List<Faq> selectInquiryList(Map<String, Object> paramMap) {
	    return ad.selectInquiryList(paramMap);
	}

	@Override
	public Faq selectInquiryDetail(int faqId) {
	    return ad.selectInquiryDetail(faqId);
	}

	@Override
	public List<FaqImg> selectInquiryFiles(int faqId) {
	    return ad.selectInquiryFiles(faqId);
	}

	@Override
	public int insertInquiryAnswer(Map<String, Object> paramMap) {
	    return ad.insertInquiryAnswer(paramMap);
	}
	
    @Override
    public List<Map<String, Object>> selectItemListForAdmin() {
        return ad.selectItemListForAdmin();
    }

    @Override
    public List<BidLogVo> selectBidLogsByItem(int itemNo) {
        return ad.selectBidLogsByItem(itemNo);
    }

	// 경매 관리(종료 및 취소) 영역
	@Override
	public int selectAuctionListCount() {
		return ad.selectAuctionListCount();
	}
	
	@Override
	public List<Item> selectAdminAuctionList(Map<String, Object> paramMap) {
		return ad.selectAdminAuctionList(paramMap);
	}
	
	@Override
	public List<Bid> selectBidHistory(int itemNo) {
		return ad.selectBidHistory(itemNo);
	}
	
	@Override
	public int updateAuctionStatus(int itemNo) {
		return ad.updateAuctionStatus(itemNo);
	}// n -> c
	
    @Override
    public List<Member> getUserList() {
        return ad.getUserList();
    }

    @Override
    public List<Bid> getUserBidLogs(int userNo) {
        return ad.getUserBidLogs(userNo);
    }
    
 // 낙찰 취하 페이지
	@Override
	public int selectSuccessionCount() {
		// TODO Auto-generated method stub
		return ad.selectSuccessionCount();
	}
	@Override
	public List<Item> selectSuccessionList(PageInfo pi) {
		// TODO Auto-generated method stub
		return ad.selectSuccessionList(pi);
	}
	@Override
	public int updateForceFail(int itemNo) {
		// TODO Auto-generated method stub
		return ad.updateForceFail(itemNo);
	}
	@Transactional // 둘 중 하나라도 실패하면 원상복구!
	@Override
	public int updateForceSuccession(int itemNo) {
	    // 1. 현재 1등 입찰자를 박탈('F') 시킴
	    int result1 = ad.updateCurrentBidderFail(itemNo);
	    
	    // 2. 해당 아이템의 결제 기한을 7일 연장
	    int result2 = ad.updateDeadlineExtend(itemNo);
	    
	    // 두 작업이 모두 성공해야만 최종 성공(1)으로 판정
	    if (result1 > 0 && result2 > 0) {
	        return 1; 
	    } else {
	    	throw new RuntimeException("승계 처리 중 문제가 발생하여 롤백합니다.");
	    }
	}

}
