package com.kh.kbay.admin.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

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

@Repository
@Slf4j
@RequiredArgsConstructor
public class AdminDaoImpl implements AdminDao {
	
	private final SqlSessionTemplate session;
	
	@Override
	public int selectTotalMemberCount() {
		return session.selectOne("adminMapper.selectTotalMemberCount");
	}

	@Override
	public int selectActiveAuctionsCount() {
		return session.selectOne("adminMapper.selectActiveAuctionsCount");
	}

	@Override
	public int selectUnprocessedReportsCount() {
		return session.selectOne("adminMapper.selectUnprocessedReportsCount");
	}
	
	@Override
	public int selectMemberListCount(Map<String, Object> safeMap) {
		return session.selectOne("adminMapper.selectMemberListCount", safeMap);
	}

	@Override
	public List<Member> selectMemberList(Map<String, Object> safeMap) {
		return session.selectList("adminMapper.selectMemberList", safeMap);
	}

	@Override
	public Member selectMemberDetail(int userNo) {
		return session.selectOne("adminMapper.selectMemberDetail", userNo);
	}

	@Override
	public List<Item> selectUserItemList(int userNo) {
		return session.selectList("adminMapper.selectUserItemList", userNo);
	}

	@Override
    public List<BoardPost> selectUserPostList(int userNo) {
        // sqlSession(또는 session)을 사용해서 XML 쿼리를 부르는 곳
        return session.selectList("adminMapper.selectUserPostList", userNo);
    }

	@Override
	public List<Reply> selectUserReplyList(int userNo) {
		return session.selectList("adminMapper.selectUserReplyList", userNo);
	}

	@Override
	public int insertSuspendUserSanctionRecord(Map<String, Object> paramMap) {
		return session.insert("adminMapper.insertSuspendUserSanctionRecord", paramMap);
	}

	@Override
	public int updateSuspendUserStatusUpdate(Map<String, Object> paramMap) {
		return session.update("adminMapper.updateSuspendUserStatusUpdate",paramMap);
	}

	@Override
	public int updateUserStatusDelete(int userNo) {
		return session.update("adminMapper.updateUserStatusDelete", userNo);
	}

	@Override
	public List<Report> selectUserReportList(int userNo) {
		return session.selectList("adminMapper.selectUserReportList",userNo);
	}
	
	// 신고 내역 처리 부분
	@Override
	public int selectReportListCount(Map<String, Object> paramMap) {
		return session.selectOne("adminMapper.selectReportListCount", paramMap);
	}
	@Override
	public List<Report> selectReportList(Map<String, Object> paramMap) {
		return session.selectList("adminMapper.selectReportList", paramMap);
	}

	@Override
	public Map<String, Object> selectReportTargetInfo(Map<String, Object> paramMap) {
		return session.selectOne("adminMapper.selectReportTargetInfo", paramMap);
	}

	@Override
	public List<Map<String, Object>> selectReportStats(Map<String, Object> paramMap) {
		return session.selectList("adminMapper.selectReportStats", paramMap);
	}

	@Override
	public int updateTargetDeleteStatus(Map<String, Object> paramMap) {
		return session.update("adminMapper.updateTargetDeleteStatus",paramMap);
	}

	@Override
	public int updateReportKeepStatus(Map<String, Object> paramMap) {
		return session.update("adminMapper.updateReportKeepStatus",paramMap);
	}

	@Override
	public int selectInquiryListCount(Map<String, Object> paramMap) {
	    return session.selectOne("adminMapper.selectInquiryListCount", paramMap);
	}

	@Override
	public List<Faq> selectInquiryList(Map<String, Object> paramMap) {
	    return session.selectList("adminMapper.selectInquiryList", paramMap);
	}

	@Override
	public Faq selectInquiryDetail(int faqId) {
	    return session.selectOne("adminMapper.selectInquiryDetail", faqId);
	}

	@Override
	public List<FaqImg> selectInquiryFiles(int faqId) {
	    return session.selectList("adminMapper.selectInquiryFiles", faqId);
	}

	@Override
	public int insertInquiryAnswer(Map<String, Object> paramMap) {
	    return session.update("adminMapper.insertInquiryAnswer", paramMap);
	}

	// 경매 관리(종료 및 취소) 영역
	@Override
	public int selectAuctionListCount() {
		return session.selectOne("adminMapper.selectAuctionListCount");
	}
	
	@Override
	public List<Item> selectAdminAuctionList(Map<String, Object> paramMap) {
		return session.selectList("adminMapper.selectAdminAuctionList", paramMap);
	}
	
	@Override
	public List<Bid> selectBidHistory(int itemNo) {
		return session.selectList("adminMapper.selectBidHistory", itemNo);
	}
	
	@Override
	public int updateAuctionStatus(int itemNo) {
	    return session.update("adminMapper.updateAuctionStatus", itemNo);
	}// n -> c
	
	@Override
    public List<Map<String, Object>> selectItemListForAdmin() {
        return session.selectList("adminMapper.selectItemListForAdmin");
    }

	@Override
    public List<BidLogVo> selectBidLogsByItem(int itemNo) {
        return session.selectList("adminMapper.selectBidLogsByItem", itemNo);
    }

    @Override
    public List<Member> getUserList() {
        return session.selectList("adminMapper.getUserList");
    }

    @Override
    public List<Bid> getUserBidLogs(int userNo) {
        return session.selectList("adminMapper.getUserBidLogs", userNo);
    }
    
 // 낙찰 취하 페이지
	@Override
	public int selectSuccessionCount() {
		// TODO Auto-generated method stub
		return session.selectOne("adminMapper.selectSuccessionCount");
	}
	@Override
	public List<Item> selectSuccessionList(PageInfo pi) {
		// TODO Auto-generated method stub
		return session.selectList("adminMapper.selectSuccessionList", pi);
	}
	@Override
	public int updateForceFail(int itemNo) {
		// TODO Auto-generated method stub
		return session.update("adminMapper.updateForceFail", itemNo);
	}
	@Override
	public int updateCurrentBidderFail(int itemNo) {
		// TODO Auto-generated method stub
		return session.update("adminMapper.updateCurrentBidderFail", itemNo);
	}
	@Override
	public int updateDeadlineExtend(int itemNo) {
		// TODO Auto-generated method stub
		return session.update("adminMapper.updateDeadlineExtend", itemNo);
	}

	@Override
	public String selectTopBidType(int itemNo) {
		// TODO Auto-generated method stub
		return session.selectOne("adminMapper.selectTopBidType", itemNo);
	}

	@Override
	public int selectNextBidderCount(int itemNo) {
		// TODO Auto-generated method stub
		return session.selectOne("adminMapper.selectNextBidderCount", itemNo);
	}
	
}
