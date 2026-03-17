package com.kh.kbay.notification.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kh.kbay.notification.service.NotificationService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/noti")
@RequiredArgsConstructor
public class NotificationController {
	private final NotificationService ns;
	
}
