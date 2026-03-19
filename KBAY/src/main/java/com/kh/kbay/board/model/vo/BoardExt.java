package com.kh.kbay.board.model.vo;

import java.util.List;

import lombok.Data;

@Data
public class BoardExt extends BoardPost {
	// 보드 상세보기용
	private List<BoardImg> imgList;
	private String userName;
}
