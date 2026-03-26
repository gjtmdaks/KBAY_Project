package com.kh.kbay.report.controller;

import java.util.Map;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.kbay.member.model.vo.Member;
import com.kh.kbay.report.model.vo.Report;
import com.kh.kbay.report.service.ReportService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/report")
@RequiredArgsConstructor
public class ReportController {
	private final ReportService rs;
	
	@PostMapping("/insert")
	@ResponseBody
	public String insertReport(@RequestBody Map<String, Object> param,
	                          Authentication auth) {

	    if (auth == null) return "fail";

	    int userNo = ((Member)auth.getPrincipal()).getUserNo();

	    int reportCdNo = Integer.parseInt(param.get("reportCdNo").toString());
	    String targetType = param.get("targetType").toString();
	    int targetNo = Integer.parseInt(param.get("targetNo").toString());

	    Report r = new Report();
	    r.setUserNo(userNo);
	    r.setReportCdNo(reportCdNo);
	    r.setTargetType(targetType);
	    r.setTargetNo(targetNo);

	    int result = rs.insertReport(r);

	    return result > 0 ? "success" : "fail";
	}
}
