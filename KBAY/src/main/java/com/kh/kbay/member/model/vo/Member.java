package com.kh.kbay.member.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class Member {
	private int userNo;
	private int authority;
	private String userId;
	private String userPwd;
	private String userName;
	private String userAddress;
	private String userPhone;
	private String userEmail;
	private Date userEnrollDate;
	private char userDeleteYn;
	private String userLoginIp;
	private int likeCount;
	private int noPayCount;
}
