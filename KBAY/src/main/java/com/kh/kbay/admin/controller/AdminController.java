package com.kh.kbay.admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.kbay.admin.service.AdminService;
import com.kh.kbay.board.model.vo.BoardPost;
import com.kh.kbay.board.model.vo.Reply;
import com.kh.kbay.common.PageInfo;
import com.kh.kbay.common.template.Pagination;
import com.kh.kbay.item.model.vo.Item;
import com.kh.kbay.member.model.vo.Member;
import com.kh.kbay.report.model.vo.Report;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminController {
	
	private final AdminService adminService;
	
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
    
    @GetMapping("/memberList")
    public String memberList(
            @RequestParam(value="cpage", defaultValue = "1") int currentPage, // 현재 페이지
            @RequestParam(required = false) Map<String, Object> paramMap,     // 검색용 파라미터
            Model model
            ) {
        
        // 1. 안전하게 파라미터 맵 준비
        Map<String, Object> safeMap = new HashMap<>();
        if (paramMap != null && !paramMap.isEmpty()) {
            safeMap.putAll(paramMap); 
        }
        
        // 2. 페이징 설정 (한 페이지에 10명씩, 버튼은 5개씩)
        int boardLimit = 10;
        int pageLimit = 5;
        
        // 3. 전체 회원 수 조회 (서비스 호출)
        int listCount = adminService.selectMemberListCount(safeMap);
        
        // 4. 페이징 계산기 실행
        PageInfo pi = Pagination.getPageInfo(listCount, currentPage, pageLimit, boardLimit);
        
        // 5. DB에서 가져올 시작/끝 번호 계산 (MyBatis에서 쓸 것)
        int offset = (currentPage - 1) * boardLimit + 1;
        int limit = currentPage * boardLimit;
        
        safeMap.put("offset", offset);
        safeMap.put("limit", limit);
        
        // 6. 진짜 회원 목록 가져오기 (서비스 호출)
        List<Member> list = adminService.selectMemberList(safeMap);
        
        // 7. JSP(화면)로 모든 데이터 보따리 싸서 보내기!
        model.addAttribute("list", list);  // 회원 목록
        model.addAttribute("pi", pi);      // 페이징 정보
        model.addAttribute("param", safeMap); // 검색어 정보
        
        return "admin/memberList";
    }
    
    @ResponseBody
    @GetMapping("/memberDetail")
    public Member selectMemberDetail(@RequestParam("userNo") int userNo) {
        return adminService.selectMemberDetail(userNo);
    }

    @ResponseBody
    @GetMapping("/userItemList")
    public List<Item> selectUserItemList(@RequestParam("userNo") int userNo) {
        return adminService.selectUserItemList(userNo);
    }

    @ResponseBody
    @GetMapping("/userPostList")
    public List<BoardPost> selectUserPostList(@RequestParam("userNo") int userNo) {
        return adminService.selectUserPostList(userNo);
    }
    
    @ResponseBody
    @GetMapping("/userReplyList")
    public List<Reply> selectUserReplyList(@RequestParam("userNo") int userNo) {
        return adminService.selectUserReplyList(userNo);
    }
    
    // 회원이 받은 신고 내역 조회
    @ResponseBody
    @GetMapping("/userReportList")
    public List<Report> selectUserReportList(@RequestParam("userNo") int userNo) {
        // 서비스 단으로 userNo를 넘겨서 신고 리스트를 받아옵니다.
        return adminService.selectUserReportList(userNo);
    }
    
    // 계정의 정지 요청
    @ResponseBody
    @PostMapping("/suspendUser")
    public String suspendUser(@RequestParam("userNo") int userNo, @RequestParam("days") int days) {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("userNo", userNo);
        paramMap.put("days", days);
        int result = adminService.suspendUser(paramMap);
        return result > 0 ? "success" : "fail";
    }

    // 🚫 계정 강제 탈퇴 요청
    @ResponseBody
    @PostMapping("/deleteUser")
    public String deleteUser(@RequestParam("userNo") int userNo) {
        int result = adminService.deleteUser(userNo);
        return result > 0 ? "success" : "fail";
    }
}
