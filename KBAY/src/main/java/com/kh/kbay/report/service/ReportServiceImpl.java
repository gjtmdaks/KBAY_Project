package com.kh.kbay.report.service;

import org.springframework.stereotype.Service;

import com.kh.kbay.report.dao.ReportDao;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class ReportServiceImpl implements ReportService{
	private final ReportDao rd;
	
}
