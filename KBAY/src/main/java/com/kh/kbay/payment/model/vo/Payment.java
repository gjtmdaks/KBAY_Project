package com.kh.kbay.payment.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data

public class Payment {
	
	private int paymentNo;
	private int resultNo;
	private int buyerNo;
	private int amount;
	private String paymentMethod;
	private String paymentStatus;
	private Date paymentTime;
}
