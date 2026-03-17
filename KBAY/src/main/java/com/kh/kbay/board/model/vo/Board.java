package com.kh.kbay.board.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Board {
	// Board 테이블
	private String boardContent;
	private int boardNo;
	private Date boardDate;
	private String boardTitle;
	private int boardCdNo;
	private int userNo;
	private int boardCount;
}
