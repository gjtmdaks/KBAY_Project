package com.kh.kbay.report.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class Report {
	private int reportNo;
	private int userNo;
	private int reportCdNo;
	private String targetType;
	private int targetNo;
	private String status;
	private Date createdAt;
	private String categoryName;
	
	// 화면에 보여줄 신고 유형
    private String reportCategoryName;
    
    private String reporterId;
    private String targetTitle;   // item / board 제목
    private String replyContent;  // 댓글 내용
    private int boardNo;
}