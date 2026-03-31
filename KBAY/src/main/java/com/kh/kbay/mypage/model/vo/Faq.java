package com.kh.kbay.mypage.model.vo;

import java.util.Date;

import lombok.Data;

@Data
public class Faq {
	private int faqId;
	private int userNo;
	private int categoryId;
	private String title;
	private String content;
	private String filePath;
	private Date createDate;
	private String status;
	private String answerContent;
	private Date answerDate;
    private String categoryName;
    private String userName;
    private String userId;
}
