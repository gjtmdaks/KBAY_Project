package com.kh.kbay.board.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.kbay.board.model.vo.BoardImg;
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
//	private final ServletContext application;
	
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
		
		// 1. 시큐리티 로그인 체크
		if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
			ra.addFlashAttribute("alertMsg", "세션이 만료되었습니다. 다시 로그인해주세요.");
			return "redirect:/member/login";
		}
		
		Member loginUser = (Member) auth.getPrincipal();
		
		// 2. 로컬 테스트용 파일 저장 경로
		String savePath = "C:/upload/board/"; 
		String serverIp = "192.168.10.25:8081";
		String webPath = "/kbay/upload/board/";
		
		File dir = new File(savePath);
		if (!dir.exists()) {
			dir.mkdirs();
		}
		
		List<BoardImg> imgList = new ArrayList<>();
		char imgLevel = 'N'; // 첨부파일 삭제 여부(n이 살아있는거)
		
		// 3. 파일 업로드 로직 (경매 쪽 UUID 방식 적용)
		if(upfiles != null) {
			for(MultipartFile file : upfiles) {
				if(file.isEmpty()) {
					continue;
				}
				
				// 원본 파일명 추출
				String originName = file.getOriginalFilename();
				// 확장자 추출 (예: .jpg, .png)
				String ext = originName.substring(originName.lastIndexOf("."));
				// 절대 겹치지 않는 랜덤 이름 생성 (UUID)
				String changeName = UUID.randomUUID().toString() + ext;
				
				try {
					// 물리적인 C드라이브 경로에 저장
					file.transferTo(new File(savePath + changeName));
					
					// DB에 넣을 정보 세팅
					BoardImg bi = new BoardImg();
					bi.setChangeName("http://" + serverIp + webPath + changeName); // 이미지 이름에 경로가 추가 된 이름
					bi.setOriginName(originName); // 사용자가 올린 원래 이름
					bi.setImgLevel(imgLevel);
					imgList.add(bi);
					
				} catch (IOException e) {
					e.printStackTrace();
					throw new RuntimeException("파일 업로드 중 에러 발생!");
				}
			}
		}
		
		// 4. 게시글 정보 세팅
		b.setBoardCdNo(boardCdNo);
		b.setUserNo(loginUser.getUserNo());
		
		log.debug("board : {}", b);
		log.debug("imgList : {}", imgList);
		
		// 5. DB에 Insert
		int result = bs.insertBoard(b, imgList);
		
		if(result <= 0) {
			throw new RuntimeException("게시글 작성 실패");
		}
		
		ra.addFlashAttribute("alertMsg","게시글 등록 성공");
		
		return "redirect:/board/community.me/" + boardCdNo;
	}
	
	// 보드 자세히 보기
	@GetMapping("/boardDetail/{boardNo}") 
	public String boardDetail(
	        @PathVariable("boardNo") int boardNo, 
	        Model model,
	        Authentication auth
	        ) {
	    
	    // DB에서 데이터 가져오기
	    BoardPost b = bs.selectBoardDetail(boardNo);
	    List<BoardImg> bList = bs.selectBoardImg(boardNo);
	    
	    if (auth != null && auth.isAuthenticated() && !"anonymousUser".equals(auth.getPrincipal())) {
	    	
	        Member loginUser = (Member) auth.getPrincipal(); 
	        
	        model.addAttribute("loginUser", loginUser);
	    }
	    
	    model.addAttribute("b", b);
	    model.addAttribute("bList", bList);
	    
	    return "board/boardDetail";
	}
	
	// 게시글 삭제
	@GetMapping("/deletePost")
	public String deleteBoard(
			@RequestParam("boardNo") int boardNo,
			@RequestParam(value = "boardCdNo", defaultValue = "1") int boardCdNo,
			RedirectAttributes ra
			) {
		int result = bs.deleteBoard(boardNo);
		
		if(!(result > 0)) {
			ra.addFlashAttribute("alertMsg", "게시글 삭제에 실패했습니다.");
			return "redirect:/board/detail?boardNo=" + boardNo;
		}
		ra.addFlashAttribute("alertMsg", "게시글이 성공적으로 삭제되었습니다.");
		return "redirect:/board/community.me/" + boardCdNo;
	}
	
	// 게시글 업데이트
	@GetMapping("/updateBoard/{boardNo}")
	public String updateBoard(
			@PathVariable("boardNo") int boardNo, 
	        Model model,
	        Authentication auth,
	        RedirectAttributes ra
			) {
		
		// 혹시 모를 방어 요소
		if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
			ra.addFlashAttribute("alertMsg", "로그인이 필요한 서비스입니다.");
			return "redirect:/member/login";
		}
		
		BoardPost b = bs.selectBoardDetail(boardNo);
		List<BoardImg> bList = bs.selectBoardImg(boardNo);
		
		// 게시글 유저 방어
		Member loginUser = (Member) auth.getPrincipal();
		if (b.getUserNo() != loginUser.getUserNo()) {
			ra.addFlashAttribute("alertMsg", "본인의 게시글만 수정할 수 있습니다.");
			return "redirect:/board/boardDetail/" + boardNo;
		}
		
		model.addAttribute("b", b);
		model.addAttribute("bList", bList);
		
		return "board/boardUpdate";
	}
	
	@ResponseBody
	@PostMapping("/insertReply")
	public String insertReply(
			@RequestParam("boardNo") int boardNo,
			@RequestParam("commentContent") String commentContent,
			Authentication auth
			) {
		
		// 1. 로그인 안 한 사람이 AJAX를 쏘면 컷! (보안)
		if (auth == null || !auth.isAuthenticated()) {
			return "fail";
		}
		
		Member loginUser = (Member) auth.getPrincipal();
		
		// 2. 파라미터로 받은 내용들을 댓글 객체나 Map에 담기.
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("boardNo", boardNo);
		paramMap.put("commentContent", commentContent);
		paramMap.put("userNo", loginUser.getUserNo());
		
		// 3. DB에 INSERT
		int result = bs.insertReply(paramMap); 
        
//		int result = 1; // 테스트를 위해 임시로 무조건 성공하게 만듭니다.
		
		if(result > 0) {
			return "success"; // JS의 if(result === "success") 부분으로 쏙 들어갑니다!
		} else {
			return "fail";
		}
	}
}
