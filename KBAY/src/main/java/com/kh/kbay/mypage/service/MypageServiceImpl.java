package com.kh.kbay.mypage.service;

import org.springframework.stereotype.Service;

import com.kh.kbay.mypage.dao.MypageDao;
import com.kh.kbay.mypage.model.vo.MyPageSummary;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class MypageServiceImpl implements MypageService {

	private final MypageDao md;

    @Override
    public MyPageSummary getSummary(int userNo) {
        return md.selectSummary(userNo);
    }
    
    @Override
    public int getAccidentCount(int userNo) {
        return md.selectAccidentCount(userNo);
    }

}
