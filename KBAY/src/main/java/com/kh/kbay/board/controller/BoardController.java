package com.kh.kbay.board.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/")
@RequiredArgsConstructor
public class BoardController {
	@RequestMapping("community.me")
    public String agreeForm() {
        return "board/board";
    }

}
