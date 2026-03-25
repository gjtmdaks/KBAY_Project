package com.kh.kbay.admin.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminController {
//	@Autowired
//    private AdminService adminService;

    @GetMapping("/adminpage.me") // 아까 헤더에서 연결한 관리자페이지 주소
    public String adminPage(Model model) {
        
//        // 1. 오늘 가입한 사람 수 조회 (DB 쿼리 실행)
//        int newMembers = adminService.getTodayNewMembersCount();
//        
//        // 2. 현재 진행중인 경매 수 조회
//        int activeAuctions = adminService.getActiveAuctionsCount();
//        
//        // 3. 미처리 신고 내역 수 조회
//        int unprocessedReports = adminService.getUnprocessedReportsCount();
//        
//        // 4. JSP(화면)로 데이터 넘겨주기 (변수명이 JSP의 ${} 안의 이름과 같아야 함)
//        model.addAttribute("todayNewMembers", newMembers);
//        model.addAttribute("activeAuctionsCount", activeAuctions);
//        model.addAttribute("unprocessedReportsCount", unprocessedReports);
        
        return "admin/admin"; // manager.jsp 경로
    }
}
