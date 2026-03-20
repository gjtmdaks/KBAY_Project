package com.kh.kbay.board.controller;

import java.util.List;
import java.util.Map;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.kbay.board.model.vo.BoardPost;
import com.kh.kbay.board.service.BoardService;
import com.kh.kbay.common.PageInfo;
import com.kh.kbay.common.template.Pagination;
import com.kh.kbay.member.model.vo.Member;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/board")
@RequiredArgsConstructor
public class BoardController {
	private final BoardService bs;
	
	@GetMapping("/community.me/{boardCdNo}")
    public String communityForm(
			@PathVariable("boardCdNo") int boardCdNo,
			@RequestParam(value="currentPage", defaultValue = "1")
			int currentPage,
			Authentication auth,
			Model model ,
			@RequestParam Map<String, Object> paramMap) {
		
		log.info("===== 게시판 접근 권한 확인 시작 =====");
		if (auth != null) {
			log.info("로그인 유저: {}", auth.getName());
			log.info("보유 권한: {}", auth.getAuthorities());
			Member loginUser = (Member) auth.getPrincipal();
			log.info("유저 번호: {}", loginUser.getUserNo());
		} else {
			log.warn("인증 정보 없음 (비로그인 상태)");
		}
		
		paramMap.put("boardCdNo", boardCdNo);
		
		int boardLimit = 10;
		int pageLimit = 10;
		int boardListCount = bs.selectBoardListCount(paramMap);
		
		PageInfo pi = null;
		paramMap.put("pi", pi);
		
		List<BoardPost> list = bs.selectList(paramMap);
		model.addAttribute("list", list);
		model.addAttribute("pi", pi);
		
		return "board/board";
    }
	
	@PostMapping("/insert")
	public String insertBoard(
			@ModelAttribute BoardPost b,
			@PathVariable("boardCd") String boardCd,
			Authentication auth,
			Model model,
			RedirectAttributes ra,
			@RequestParam(value = "upfile", required = false) List<MultipartFile> upfiles
			) {
		
		if (auth == null || !auth.isAuthenticated()) {
			log.warn("등록 시도 거부: 인증되지 않은 사용자");
			ra.addFlashAttribute("alertMsg", "로그인이 필요한 서비스입니다.");
			return "redirect:/member/login";
		}

		Member loginUser = (Member) auth.getPrincipal();
		log.info("게시글 등록 유저 번호: {}", loginUser.getUserNo());
		b.setUserNo(loginUser.getUserNo());
		
		return "board/boardWriting";
	}
	
	@GetMapping("/insert/{boardCd}")
	public String enrollForm(
			@PathVariable("boardCd") String boardCd,
			@ModelAttribute BoardPost b,
			Authentication auth,
			RedirectAttributes ra,
			Model m
			) {
		
		if (auth == null || !auth.isAuthenticated()) {
			log.warn("등록 폼 접근 거부: 인증되지 않은 사용자");
			ra.addFlashAttribute("alertMsg", "로그인이 필요한 서비스입니다.");
			return "redirect:/member/login";
		}
		
		m.addAttribute("b", b);
		return "board/boardEnrollForm";
	}


}