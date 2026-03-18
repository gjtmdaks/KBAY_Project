package com.kh.kbay.board.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/board")
@RequiredArgsConstructor
public class BoardController {
//	private final BoardService bs;
	
	@GetMapping("/community.me")
    public String communityForm() {
        return "board/board";
    }
	
	// 게시판 등록
	@GetMapping("/insert")
    public String enrollForm() {
        return "board/boardWriting";
    }


}
