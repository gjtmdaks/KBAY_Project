package com.kh.kbay.mypage.dao;

import java.util.List;

import com.kh.kbay.bid.model.vo.Bid;
import com.kh.kbay.board.model.vo.BoardPost;
import com.kh.kbay.item.model.vo.Item;
import com.kh.kbay.mypage.model.vo.ReplyListDto;
import com.kh.kbay.mypage.model.vo.WishListDto;
import com.kh.kbay.report.model.vo.Report;

public interface MypageDao {

	int selectAccidentCount(int userNo);

	List<Bid> getBidList(int userNo);

	List<Item> getSaleList(int userNo);

	List<WishListDto> getWishList(int userNo);

	List<BoardPost> getBoardList(int userNo);

	List<ReplyListDto> getReplyList(int userNo);

	List<Report> getReportList(int userNo);

}
