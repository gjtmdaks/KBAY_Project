package com.kh.kbay.notification.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data

public class Notification {
	
	private int notiNo;
	private int notiCdNo;
	private int userNo;
	private String message;
	private char isRead;
	private Date createAt;
}
