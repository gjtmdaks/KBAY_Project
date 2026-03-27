package com.kh.kbay.mypage.service;

import java.util.List;

import com.kh.kbay.board.model.vo.BoardPost;
import com.kh.kbay.item.model.vo.Item;
import com.kh.kbay.member.model.vo.Member;
import com.kh.kbay.mypage.model.vo.BidListDto;
import com.kh.kbay.mypage.model.vo.ReplyListDto;
import com.kh.kbay.mypage.model.vo.SaleListDto;
import com.kh.kbay.mypage.model.vo.WishListDto;
import com.kh.kbay.report.model.vo.Report;

public interface MypageService {
	
	int getAccidentCount(int userNo);

	List<BidListDto> getBidList(int userNo);

	List<SaleListDto> getSaleList(int userNo);

	List<WishListDto> getWishList(int userNo);

	List<BoardPost> getBoardList(int userNo);

	List<BoardPost> getBoardListByCategory(int userNo, Integer category);

	List<ReplyListDto> getReplyList(int userNo);

	List<Report> getReportList(int userNo);

	int updateUser(Member user);

	Member selectUserByNo(int userNo);

	List<Report> getReportedList(int userNo);

}
