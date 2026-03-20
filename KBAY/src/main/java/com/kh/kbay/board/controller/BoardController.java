package com.kh.kbay.board.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import org.springframework.security.core.Authentication;
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

import com.kh.kbay.board.model.vo.BoardImg;
import com.kh.kbay.board.model.vo.BoardPost;
import com.kh.kbay.board.service.BoardService;
import com.kh.kbay.common.PageInfo;
import com.kh.kbay.common.template.Pagination;
import com.kh.kbay.common.util.Utils;
import com.kh.kbay.member.model.vo.Member;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/board")
@RequiredArgsConstructor
public class BoardController {
	private final BoardService bs;
	private final ServletContext application;
	
	//커뮤니티 목록 불류 및 목록을 보여주기
	@GetMapping("/community.me/{boardCdNo}")
    public String communityForm(
			@PathVariable("boardCdNo") int boardCdNo,
			@RequestParam(value="cpage", defaultValue = "1")
			int currentPage,
			Model model ,
			@RequestParam Map<String, Object> paramMap) {
		paramMap.put("boardCdNo", boardCdNo);
		
		int boardLimit = 10;
		int pageLimit = 10;
		int boardListCount = bs.selectBoardListCount(paramMap);
		
		
		PageInfo pi = Pagination.getPageInfo(boardListCount, currentPage, pageLimit, boardLimit);
		log.debug("pi : {}", pi);
		paramMap.put("pi",pi);
		
		int offset = (currentPage - 1) * boardLimit + 1;  // 시작 행 번호 (예: 1페이지면 1)
	    int limit = currentPage * boardLimit;             // 끝 행 번호 (예: 1페이지면 10)
	    
	    paramMap.put("offset", offset);
	    paramMap.put("limit", limit);
		
		List<BoardPost> list = bs.selectList(paramMap);
		model.addAttribute("list",list);
		model.addAttribute("pi",pi);
		
		return "board/board";
    }
	
	// 게시판 등록 띄어주기
	@GetMapping("/insert/{boardCdNo}")
	public String insertBoardForm(
	        @PathVariable("boardCdNo") int boardCdNo,
	        Model model,
	        RedirectAttributes ra,
	        Authentication auth
	        ) {
	    
	    if (auth == null || !auth.isAuthenticated()) {
            ra.addFlashAttribute("alertMsg", "로그인이 필요한 서비스입니다.");
            return "redirect:/member/login";
        }
	    
	    model.addAttribute("boardCdNo", boardCdNo); 
	    
	    return "board/boardWriting";
	}
	// 게시판 등록버튼
	@PostMapping("/insert")
	public String insertBoard(
			@ModelAttribute BoardPost b,
			@RequestParam("boardCdNo") int boardCdNo,
			Model model,
			RedirectAttributes ra,
			@RequestParam(value = "upfile", required = false) List<MultipartFile> upfiles,
			Authentication auth
			) {
		if (auth == null || !auth.isAuthenticated()) {
            ra.addFlashAttribute("alertMsg", "세션이 만료되었습니다. 다시 로그인해주세요.");
            return "redirect:/member/login";
        }
		
		Member loginUser = (Member) auth.getPrincipal();
		
		List<BoardImg> imgList = new ArrayList<>();
		char imgLevel = 'N'; // 첨부파일 삭제 여부(n이 살아있는거)
		
		if(upfiles != null) {
			for(MultipartFile upfile : upfiles) {
				if(upfile.isEmpty()) {
					continue;
				}
				// 첨부파일이 존재한다면 WEB서버 상에 첨부파일 저장
				// Utils.saveFile이 boardCdNo를 String으로 받는다면 String.valueOf()로 변환!
				String changeName = Utils.saveFile(upfile, application, boardCdNo);
				
				// 첨부파일 관리를 위해 DB에 첨부파일 위치정보 저장
				BoardImg bi = new BoardImg();
				bi.setChangeName(changeName);
				bi.setOriginName(upfile.getOriginalFilename());
				bi.setImgLevel(imgLevel);
				imgList.add(bi);
			}
		}
		
		b.setBoardCdNo(boardCdNo);
	    b.setUserNo(loginUser.getUserNo());
		
		log.debug("board : {}", b);
		log.debug("imgList : {}", imgList);
		
		int result = bs.insertBoard(b, imgList);
		
		if(result<=0) {
			throw new RuntimeException("게시즐 작성 실패");
		}
		
		ra.addFlashAttribute("alertMsg","게시글 등록 성공");
		
		return "redirect:/board/community.me/" + boardCdNo;
	}
	
	@GetMapping("/boardDetail/{boardCdNo}")
	public String boardDetail(
			@PathVariable("boardCdNo") String boardCdNo,
			@ModelAttribute BoardPost b,
			Model m
			) {
		m.addAttribute("b",b);
		return "board/boardDetail";
	}

}
