package com.kh.kbay.mypage.service;

import com.kh.kbay.mypage.model.vo.MyPageSummary;

public interface MypageService {

	MyPageSummary getSummary(int userNo);
	
	int getAccidentCount(int userNo);

}
