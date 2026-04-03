package com.kh.kbay.mypage.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.kbay.bid.model.vo.Bid;
import com.kh.kbay.board.model.vo.BoardPost;
import com.kh.kbay.item.model.vo.Item;
import com.kh.kbay.member.model.vo.Member;
import com.kh.kbay.mypage.model.vo.BidListDto;
import com.kh.kbay.mypage.model.vo.Faq;
import com.kh.kbay.mypage.model.vo.FaqCategory;
import com.kh.kbay.mypage.model.vo.FaqImg;
import com.kh.kbay.mypage.model.vo.ReplyListDto;
import com.kh.kbay.mypage.model.vo.SaleListDto;
import com.kh.kbay.report.model.vo.Report;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Repository
@Slf4j
@RequiredArgsConstructor
public class MypageDaoImpl implements MypageDao {

	private final SqlSessionTemplate session;

	@Override
	public int selectAccidentCount(int userNo) {
		return session.selectOne("mypage.selectAccidentCount", userNo);
	}

	@Override
	public List<Bid> getBidList(int userNo) {
		return session.selectList("mypage.selectBidList", userNo);
	}

	@Override
	public List<Item> getSaleList(int userNo) {
		return session.selectList("mypage.selectSaleList", userNo);
	}

	@Override
	public List<Item> getWishList(int userNo) {
		return session.selectList("mypage.selectWishList", userNo);
	}

	@Override
	public List<BoardPost> getBoardList(int userNo) {
		return session.selectList("mypage.selectBoardList", userNo);
	}

	@Override
	public List<BoardPost> getBoardListByCategory(Map<String, Object> param) {
		return session.selectList("mypage.getBoardListByCategory", param);
	}

	@Override
	public List<ReplyListDto> getReplyList(int userNo) {
		return session.selectList("mypage.selectReplyList", userNo);
	}

	@Override
	public List<Report> getReportList(int userNo) {
		return session.selectList("mypage.selectReportList", userNo);
	}

	@Override
	public int updateUser(Member user) {
		return session.update("mypage.updateUser", user);
	}

	@Override
	public Member selectUserByNo(int userNo) {
		return session.selectOne("mypage.selectUserByNo", userNo);
	}

	@Override
	public List<Report> getReportedList(int userNo) {
		return session.selectList("mypage.selectReportedList", userNo);
	}
	
	public List<Faq> getFaqList(int userNo) {
	    return session.selectList("mypage.getFaqList", userNo);
	}

	public int insertFaq(Faq faq) {
	    return session.insert("mypage.insertFaq", faq);
	}

	public List<FaqCategory> getCategoryList() {
	    return session.selectList("mypage.getCategoryList");
	}

	public Faq getFaqDetail(int id) {
	    return session.selectOne("mypage.getFaqDetail", id);
	}

	@Override
	public void insertFaqFile(FaqImg fi) {
	    session.insert("mypage.insertFaqFile", fi);
	}

	@Override
	public List<FaqImg> selectFaqFiles(int faqId) {
		return session.selectList("mypage.selectFaqFiles", faqId);
	}
	@Override
    public List<BidListDto> getWonList(Map<String, Object> map) {
        return session.selectList("mypage.selectWonList", map);
    }

	@Override
	public List<SaleListDto> getSellerPaymentList(Map<String, Object> map) {
		return session.selectList("mypage.getSellerPaymentList", map);
	}
	
	@Override
	public int increaseSellerLike(int itemNo) {
	    return session.update("member.increaseSellerLike", itemNo);
	}
	
	@Override
	public int updatePassword(Map<String, Object> map) {
	    return session.update("mypage.updatePassword", map);
	}
	
	@Override
	public int deleteMember(int userNo) {
	    return session.update("mypage.deleteMember", userNo);
	}
	
}
