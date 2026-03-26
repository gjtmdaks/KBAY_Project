package com.kh.kbay.admin.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.kh.kbay.admin.dao.AdminDao;
import com.kh.kbay.board.model.vo.BoardPost;
import com.kh.kbay.item.model.vo.Item;
import com.kh.kbay.member.model.vo.Member;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class AdminServiceImpl implements AdminService {
	
	private final AdminDao ad; // 🌟 이 친구(DAO)에게 일을 시켜야 합니다!
	
	@Override
	public int selectMemberListCount(Map<String, Object> safeMap) {
		// 전체 회원 수 가져오기
		return ad.selectMemberListCount(safeMap);
	}

	@Override
	public List<Member> selectMemberList(Map<String, Object> safeMap) {
		// 페이징된 회원 목록 가져오기
		return ad.selectMemberList(safeMap);
	}

	@Override
	public Member selectMemberDetail(int userNo) {
		// 특정 회원 1명의 상세 정보 가져오기
		return ad.selectMemberDetail(userNo);
	}

	@Override
	public List<Item> selectUserItemList(int userNo) {
		// 회원이 등록한 경매 물품 목록 가져오기
		return ad.selectUserItemList(userNo);
	}

	@Override
	public List<BoardPost> selectUserPostList(int userNo) {
		// 회원이 작성한 게시글 목록 가져오기 (게시판 VO 이름이 BoardPost 군요!)
		return ad.selectUserPostList(userNo);
	}

}
