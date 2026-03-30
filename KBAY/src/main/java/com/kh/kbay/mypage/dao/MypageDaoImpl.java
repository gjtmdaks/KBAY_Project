package com.kh.kbay.mypage.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.kbay.bid.model.vo.Bid;
import com.kh.kbay.board.model.vo.BoardPost;
import com.kh.kbay.item.model.vo.Item;
import com.kh.kbay.member.model.vo.Member;
import com.kh.kbay.mypage.model.vo.ReplyListDto;
import com.kh.kbay.mypage.model.vo.WishListDto;
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

}
