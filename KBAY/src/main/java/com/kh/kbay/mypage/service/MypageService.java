package com.kh.kbay.mypage.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import com.kh.kbay.board.model.vo.BoardPost;
import com.kh.kbay.member.model.vo.Member;
import com.kh.kbay.mypage.model.vo.BidListDto;
import com.kh.kbay.mypage.model.vo.Faq;
import com.kh.kbay.mypage.model.vo.FaqCategory;
import com.kh.kbay.mypage.model.vo.FaqImg;
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

	List<Faq> getFaqList(int userNo);

	List<FaqCategory> getCategoryList();

	int insertFaq(Faq faq, List<MultipartFile> files);

	Faq getFaqDetail(int id);

	List<FaqImg> getFaqFiles(int id);
	
	List<BidListDto> getWonList(Map<String, Object> map);
	
	List<SaleListDto> getSellerPaymentList(Map<String, Object> map);

	int increaseSellerLike(int itemNo);
	
	int updatePassword(int userNo, String encPwd);
	

}
