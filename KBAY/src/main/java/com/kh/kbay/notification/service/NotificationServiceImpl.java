package com.kh.kbay.notification.service;

import org.springframework.stereotype.Service;

import com.kh.kbay.notification.dao.NotificationDao;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class NotificationServiceImpl implements NotificationService {
	private final NotificationDao nd;
	
}
