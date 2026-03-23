package com.kh.kbay.board.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
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
//	@PostMapping("/insert")
//	public String insertBoard(
//			@ModelAttribute BoardPost b,
//			@RequestParam("boardCdNo") int boardCdNo,
//			Model model,
//			RedirectAttributes ra,
//			@RequestParam(value = "upfile", required = false) List<MultipartFile> upfiles,
//			Authentication auth
//			) {
//		if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
//			ra.addFlashAttribute("alertMsg", "세션이 만료되었습니다. 다시 로그인해주세요.");
//			return "redirect:/member/login";
//		}
//		
//		Member loginUser = (Member) auth.getPrincipal();
//		
//		List<BoardImg> imgList = new ArrayList<>();
//		char imgLevel = 'N'; // 첨부파일 삭제 여부(n이 살아있는거)
//		
//		if(upfiles != null) {
//			for(MultipartFile upfile : upfiles) {
//				if(upfile.isEmpty()) {
//					continue;
//				}
//				// 첨부파일이 존재한다면 WEB서버 상에 첨부파일 저장
//				// Utils.saveFile이 boardCdNo를 String으로 받는다면 String.valueOf()로 변환!
//				String changeName = Utils.saveFile(upfile, application, boardCdNo);
//				
//				// 첨부파일 관리를 위해 DB에 첨부파일 위치정보 저장
//				BoardImg bi = new BoardImg();
//				bi.setChangeName(changeName);
//				bi.setOriginName(upfile.getOriginalFilename());
//				bi.setImgLevel(imgLevel);
//				imgList.add(bi);
//			}
//		}
//		
//		b.setBoardCdNo(boardCdNo);
//	    b.setUserNo(loginUser.getUserNo());
//		
//		log.debug("board : {}", b);
//		log.debug("imgList : {}", imgList);
//		
//		int result = bs.insertBoard(b, imgList);
//		
//		if(result<=0) {
//			throw new RuntimeException("게시즐 작성 실패");
//		}
//		
//		ra.addFlashAttribute("alertMsg","게시글 등록 성공");
//		
//		return "redirect:/board/community.me/" + boardCdNo;
//	}
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
		
		// 🌟 2. 로컬 테스트용 파일 저장 경로 세팅!
		String savePath = "C:/upload/board/"; // 내 PC의 C드라이브에 저장!
		// String serverIp = "localhost:8081"; // 나중에 전체 URL이 필요하다면 사용하세요!
		// String webPath = "/kbay/upload/board/";
		
		File dir = new File(savePath);
		if (!dir.exists()) {
			dir.mkdirs(); // C드라이브에 upload/board 폴더가 없으면 알아서 만들어줍니다!
		}
		
		List<BoardImg> imgList = new ArrayList<>();
		char imgLevel = 'N'; // 첨부파일 삭제 여부(n이 살아있는거)
		
		// 🌟 3. 파일 업로드 로직 (경매 쪽 UUID 방식 적용)
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
					// 물리적인 C드라이브 경로에 파일 쾅! 저장
					file.transferTo(new File(savePath + changeName));
					
					// DB에 넣을 정보 세팅
					BoardImg bi = new BoardImg();
					bi.setChangeName(changeName); // 랜덤으로 바뀐 이름
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
	    
	    if (auth != null && auth.isAuthenticated() && !"anonymousUser".equals(auth.getPrincipal())) {
	    	
	        Member loginUser = (Member) auth.getPrincipal(); 
	        
	        model.addAttribute("loginUser", loginUser);
	    }
	    
	    model.addAttribute("b", b);
	    
	    return "board/boardDetail";
	}

}
