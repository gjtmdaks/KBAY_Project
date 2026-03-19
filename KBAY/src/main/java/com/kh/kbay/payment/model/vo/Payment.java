package com.kh.kbay.payment.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class Payment {
	private int paymentNo;
	private int resultNo;
	private String paymentMethod;
	private String paymentStatus;
	private Date paymentTime;
	private String payCode;
}
