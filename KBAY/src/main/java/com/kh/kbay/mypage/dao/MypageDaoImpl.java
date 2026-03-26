package com.kh.kbay.mypage.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.kbay.mypage.model.vo.MyPageSummary;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Repository
@Slf4j
@RequiredArgsConstructor
public class MypageDaoImpl implements MypageDao {

	private final SqlSessionTemplate session;

	@Override
    public MyPageSummary selectSummary(int userNo) {
        return session.selectOne("mypage.selectSummary", userNo);
    }

	@Override
	public int selectAccidentCount(int userNo) {
		return session.selectOne("mypage.selectAccidentCount", userNo);
	}

}
