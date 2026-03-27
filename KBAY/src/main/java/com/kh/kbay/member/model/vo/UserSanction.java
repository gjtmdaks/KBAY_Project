package com.kh.kbay.member.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class UserSanction {
	private int sanctionNo;
	private Date sanctionedAt;
	private Date suspendEndDate;
	private int userNo;
}
