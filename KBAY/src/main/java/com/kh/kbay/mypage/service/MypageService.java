package com.kh.kbay.mypage.service;

import java.util.List;

import com.kh.kbay.board.model.vo.BoardPost;
import com.kh.kbay.item.model.vo.Item;
import com.kh.kbay.mypage.model.vo.BidListDto;
import com.kh.kbay.mypage.model.vo.ReplyListDto;
import com.kh.kbay.mypage.model.vo.WishListDto;
import com.kh.kbay.report.model.vo.Report;

public interface MypageService {
	
	int getAccidentCount(int userNo);

	List<BidListDto> getBidList(int userNo);

	List<Item> getSaleList(int userNo);

	List<WishListDto> getWishList(int userNo);

	List<BoardPost> getBoardList(int userNo);

	List<ReplyListDto> getReplyList(int userNo);

	List<Report> getReportList(int userNo);

}
