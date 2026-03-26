package com.kh.kbay.report.dao;

import com.kh.kbay.report.model.vo.Report;

public interface ReportDao {

	int insertReport(Report r);

	int checkDuplicateReport(Report r);

}
