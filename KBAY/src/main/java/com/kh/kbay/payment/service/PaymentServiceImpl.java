package com.kh.kbay.payment.service;

import org.springframework.stereotype.Service;

import com.kh.kbay.payment.dao.PaymentDao;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class PaymentServiceImpl implements PaymentService {
	private final PaymentDao pd;
	
}
