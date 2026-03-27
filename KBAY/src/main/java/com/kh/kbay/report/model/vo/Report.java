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
	private char status;
	private Date createAt;
	
	// 화면에 보여줄 신고 유형
    private String reportCategoryName;
}
