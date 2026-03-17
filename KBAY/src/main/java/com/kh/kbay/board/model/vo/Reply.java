package com.kh.kbay.board.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Reply {
	// 댓글
	private int boardNo;
	private String replyContent;
	private int replyNo;
	private Date replyDate;
	private int userNol;
	private char replyDelete; // 삭제여부
}
