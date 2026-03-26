package com.kh.kbay.mypage.dao;

import com.kh.kbay.mypage.model.vo.MyPageSummary;

public interface MypageDao {

	MyPageSummary selectSummary(int userNo);

	int selectAccidentCount(int userNo);

}
