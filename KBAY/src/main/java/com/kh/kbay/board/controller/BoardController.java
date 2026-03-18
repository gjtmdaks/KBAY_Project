package com.kh.kbay.board.controller;

import java.util.List;
import java.util.Map;

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

import com.kh.kbay.board.model.vo.Board;
import com.kh.kbay.board.service.BoardService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/board")
@RequiredArgsConstructor
public class BoardController {
	private final BoardService bs;
	
	//커뮤니티 목록 불류
	@GetMapping("/community.me/{boardCdNo}")
    public String communityForm(
			@PathVariable("boardCdNo") int boardCdNo,
			@RequestParam(value="currentPage", defaultValue = "1")
			int currentPage,
			Model model ,
			@RequestParam Map<String, Object> paramMap) {
		paramMap.put("boardCdNo", boardCdNo);
		
		int boardLimit = 10;
		int pageLimit = 10;
		int listCount = BoardService.selectListCount(paramMap);
		
		PageInfo pi =
				Pagination.getPageInfo(listCount, currentPage, pageLimit, boardLimit);
		log.debug("pi : {}", pi);
//		log.info("pi : {}", pi);
		paramMap.put("pi",pi);
		
		List<Board> list = boardService.selectList(paramMap);
		model.addAttribute("list",list);
		model.addAttribute("pi",pi);
//		model.addAttribute("param",paramMap); // 추가로할필요가 없음 삭제해도 좋음
		
		return "board/boardListView";
        return "board/board";
    }
	
	// 게시판 등록
	@PostMapping("/insert")
	public String insertBoard(
			@ModelAttribute Board b,
			@PathVariable("boardCd") String boardCd,
			Model model,
			RedirectAttributes ra,
			@RequestParam(value = "upfile", required = false) List<MultipartFile> upfiles
			) {
		
		
		
		return boardCd;
		
	}
	
	@GetMapping("/insert/{boardCd}")
	public String enrollForm(
			@PathVariable("boardCd") String boardCd,
			@ModelAttribute Board b,
			Model m
			) {
		m.addAttribute("b",b);
		return "board/boardEnrollForm";
	}


}
