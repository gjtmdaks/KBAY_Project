package com.kh.kbay.board.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class BoardPost {
	// Board 테이블
	private int boardNo;
	private String boardContent;
	private char boardDelete;
	private Date boardDate;
	private int userNo;
	private String boardTitle;
	private int viewCount;
	private int boardCdNo; // board_Cd_No = boardCategoryNo
	
	// db에는 없는 것들
	private String boardWriter;
	private String originalFileName; 
    private String renamedFileName;
}
