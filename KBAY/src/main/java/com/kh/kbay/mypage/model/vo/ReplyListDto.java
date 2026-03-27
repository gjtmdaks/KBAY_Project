package com.kh.kbay.mypage.model.vo;

import java.util.Date;

import lombok.Data;

//댓글 목록 DTO
@Data
public class ReplyListDto {
	private int replyNo;
	private String replyContent;
	private Date replyDate;
	private int boardNo;
	private String boardTitle;
}