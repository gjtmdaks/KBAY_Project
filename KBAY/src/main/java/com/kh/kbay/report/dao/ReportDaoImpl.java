package com.kh.kbay.report.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.kbay.report.model.vo.Report;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Repository
@Slf4j
@RequiredArgsConstructor
public class ReportDaoImpl implements ReportDao{
	private final SqlSessionTemplate session;

	@Override
	public int checkDuplicateReport(Report r) {
		return session.insert("report.checkDuplicateReport", r);
	}

	@Override
	public int insertReport(Report r) {
		return session.insert("report.insertReport", r);
	}
	
}
