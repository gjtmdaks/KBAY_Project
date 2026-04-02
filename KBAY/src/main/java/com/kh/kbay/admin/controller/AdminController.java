package com.kh.kbay.admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.kbay.admin.service.AdminService;

import com.kh.kbay.bid.model.vo.Bid;
import com.kh.kbay.bid.model.vo.BidLogVo;
import com.kh.kbay.board.model.vo.BoardPost;
import com.kh.kbay.board.model.vo.Reply;
import com.kh.kbay.common.PageInfo;
import com.kh.kbay.common.template.Pagination;
import com.kh.kbay.item.model.vo.Item;
import com.kh.kbay.member.model.vo.Member;
import com.kh.kbay.mypage.model.vo.Faq;
import com.kh.kbay.mypage.model.vo.FaqImg;
import com.kh.kbay.report.model.vo.Report;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminController {
	
	private final AdminService adminService;
	

    @GetMapping("/adminPage.me") // 아까 헤더에서 연결한 관리자페이지 주소
    public String adminPage(Model model) {
        
    	// 1. 현재 총 가입자 수 조회
        int totalMembers = adminService.selectTotalMemberCount();
        
        // 2. 진행 중인 경매 건수 조회
        int activeAuctions = adminService.selectActiveAuctionsCount();
        
        // 3. 미처리 신고 내역 건수 조회
        int unprocessedReports = adminService.selectUnprocessedReportsCount();
        
        // JSP가 기다리고 있는 이름표(EL 변수명)에 맞춰서 모델에 담기!
        model.addAttribute("todayNewMembers", totalMembers); 
        model.addAttribute("activeAuctionsCount", activeAuctions);
        model.addAttribute("unprocessedReportsCount", unprocessedReports);
        
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
    
    // 신고 내역 처리 부분
    @GetMapping("/adminReportList")
    public String adminReportList(
            @RequestParam(value="cpage", defaultValue = "1") int currentPage,
            @RequestParam(value="reportStatus", defaultValue = "ALL") String reportStatus,
            @RequestParam(value="targetType", defaultValue = "ALL") String targetType,
            Model model) {
        
        // 1. 화면에서 넘어온 검색 필터(상태, 유형)를 맵에 쏙 담기
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("reportStatus", reportStatus);
        paramMap.put("targetType", targetType);
        
        // 2. 페이징 설정 (한 페이지에 10개씩 보여주기)
        int boardLimit = 10;
        int pageLimit = 5;
        
        // 3. 필터 조건에 맞는 전체 신고 건수 조회 (서비스 호출)
        int listCount = adminService.selectReportListCount(paramMap);
        
        // 4. 페이징 계산기 실행
        PageInfo pi = Pagination.getPageInfo(listCount, currentPage, pageLimit, boardLimit);
        
        // 5. DB에서 가져올 시작/끝 번호 계산
        int offset = (currentPage - 1) * boardLimit + 1;
        int limit = currentPage * boardLimit;
        
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        
        // 6. 진짜 신고 목록 데이터 가져오기 (서비스 호출)
        List<Report> reportList = adminService.selectReportList(paramMap);
        
        // 7. JSP(화면)로 예쁘게 포장해서 보내기!
        model.addAttribute("reportList", reportList);
        model.addAttribute("pi", pi);
        // (참고: 검색 파라미터는 JSP에서 ${param.reportStatus} 로 바로 꺼내 쓰므로 모델에 안 담아도 됩니다!)
        
        return "admin/adminReportList";
    }
    
    @GetMapping("/reportDetail")
    @ResponseBody
    public Map<String, Object> reportDetail(
            @RequestParam("targetType") String targetType,
            @RequestParam("targetNo") int targetNo) {
        
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("targetType", targetType);
        paramMap.put("targetNo", targetNo);
        
        Map<String, Object> targetInfo = adminService.selectReportTargetInfo(paramMap);
        List<Map<String, Object>> reportStats = adminService.selectReportStats(paramMap);
        
        int totalReportCount = 0;
        if(reportStats != null) {
            for(Map<String, Object> stat : reportStats) {
                Object countObj = stat.get("REPORT_COUNT");
                if (countObj == null) countObj = stat.get("REPORTCOUNT");
                if (countObj == null) countObj = stat.get("reportCount");
                
                if (countObj != null) {
                    totalReportCount += Integer.parseInt(String.valueOf(countObj));
                }
            }
        }
        
        // Model 대신 Map에 담아서 리턴합니다! (프론트의 AJAX가 이 데이터를 받음)
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("targetType", targetType);
        resultMap.put("targetNo", targetNo);
        resultMap.put("targetInfo", targetInfo);
        resultMap.put("reportStats", reportStats);
        resultMap.put("totalReportCount", totalReportCount);
        
        return resultMap;
    }
    
    @PostMapping("/processReport")
    @ResponseBody
    public String processReport(
            @RequestParam("targetType") String targetType,
            @RequestParam("targetNo") int targetNo,
            @RequestParam("action") String action) {
        
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("targetType", targetType);
        paramMap.put("targetNo", targetNo);
        paramMap.put("action", action);
        
        // 서비스 호출 (성공하면 1 이상 반환)
        int result = adminService.updateReportProcess(paramMap);
        
        return result > 0 ? "SUCCESS" : "FAIL";
    }
    
    // 문의 리스트
    @GetMapping("/adminInquiryList")
    public String adminInquiryList(
            @RequestParam(value="cpage", defaultValue="1") int currentPage,
            @RequestParam(value="status", defaultValue="ALL") String status,
            Model model) {

        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("status", status);

        int boardLimit = 10;
        int pageLimit = 5;

        int listCount = adminService.selectInquiryListCount(paramMap);

        PageInfo pi = Pagination.getPageInfo(listCount, currentPage, pageLimit, boardLimit);

        int offset = (currentPage - 1) * boardLimit + 1;
        int limit = currentPage * boardLimit;

        paramMap.put("offset", offset);
        paramMap.put("limit", limit);

        List<Faq> list = adminService.selectInquiryList(paramMap);

        model.addAttribute("list", list);
        model.addAttribute("pi", pi);

        return "admin/adminInquiryList";
    }

    // 문의 상세
    @ResponseBody
    @GetMapping("/inquiryDetail")
    public Map<String, Object> inquiryDetail(@RequestParam("faqId") int faqId) {
    	
        Map<String, Object> result = new HashMap<>();

        Faq faq = adminService.selectInquiryDetail(faqId);
        List<FaqImg> fileList = adminService.selectInquiryFiles(faqId);

        result.put("faq", faq);
        result.put("fileList", fileList);

        return result;
    }

    // 답변 등록
    @PostMapping("/insertInquiryAnswer")
    @ResponseBody
    public String insertInquiryAnswer(@RequestBody Map<String, Object> param){
        int result = adminService.insertInquiryAnswer(param);
        return result > 0 ? "SUCCESS" : "FAIL";
    }
    

    
    //경매 관리(종료 및 취소)
    @GetMapping("/adminAuctionCancel")
    public String adminAuctionCancel(
    		@RequestParam(value="cp", defaultValue="1") int cp, // 페이지 번호
            Model model) {
        
    	int boardLimit = 10;
        int pageLimit = 5;
    	
        int listCount = adminService.selectAuctionListCount();
        
        PageInfo pi = Pagination.getPageInfo(listCount, cp, pageLimit, boardLimit);
        
        int offset = (cp - 1) * boardLimit + 1;
        int limit = cp * boardLimit;
        
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);

        // 💡 paramMap을 괄호 안에 넣어서 서비스로 전달!
        List<Item> itemList = adminService.selectAdminAuctionList(paramMap);
        
        // JSP로 데이터 전달
        model.addAttribute("itemList", itemList);
        model.addAttribute("pi", pi);
        
        return "admin/adminAuctionCancel";
    }
    // 입찰 기록 전용 컨트롤러
    @GetMapping("/bidHistory")
    @ResponseBody
    public List<Bid> getBidHistory(@RequestParam("itemNo") int itemNo) {
        return adminService.selectBidHistory(itemNo);
    }
    // 경매 강제 취소 (AJAX 처리)
    @PostMapping("/auctionCancel")
    @ResponseBody
    public String auctionCancel(
    		@RequestParam("itemNo") int itemNo
    		) {
        
        // 서비스 호출 (상태를 'C'로 업데이트)
        int result = adminService.updateAuctionStatus(itemNo);
        
        // DB 업데이트가 1줄 이상 성공했다면 "success" 리턴
        if(result > 0) {
            return "success";
        } else {
            return "fail";
        }
    }
    
 // 낙찰 취하 페이지
    @GetMapping("/adminSuccession")
    public String adminSuccession(
            @RequestParam(value="page", defaultValue="1") int page,
            Model model) {
        
    	int totalCount = adminService.selectSuccessionCount();
        
        // 2. 페이징 계산기 (무조건 pi 라는 이름으로 담으세요)
        PageInfo pi = PageInfo.of(page, totalCount, 10);
        
        // 3. 리스트 조회
        List<Item> successionList = adminService.selectSuccessionList(pi);
        
        // 🚨 [핵심] JSP가 읽을 수 있게 바구니에 담기
        model.addAttribute("successionList", successionList);
        model.addAttribute("pi", pi);
        
        return "admin/adminSuccession";
    }

    // 강제 유찰 처리 (상태를 'O'로 변경)
    @PostMapping("/forceFail")
    @ResponseBody
    public String forceFail(@RequestParam("itemNo") int itemNo) {
        
        // 아이템 상태를 'O'로 바꾸고, 필요하다면 낙찰자들의 BID_STATUS도 정리
        int result = adminService.updateForceFail(itemNo);
        
        return result > 0 ? "success" : "fail";
    }

    // 🚨 차순위 강제 승계 처리 (수정됨!)
    @PostMapping("/forceSuccession")
    @ResponseBody
    public String forceSuccession(@RequestParam("itemNo") int itemNo) {
        try {
            // 서비스에서 1, 2, 3 중 하나의 결과를 받아옵니다.
            int result = adminService.updateForceSuccession(itemNo);
            
            // 우리가 설계한 3가지 응답 신호!
            if (result == 1) return "success";   // 승계 성공
            if (result == 2) return "empty";     // 일반 입찰인데 남은 사람이 없어 유찰됨
            if (result == 3) return "now_fail";  // 즉시 낙찰자라 차순위 없이 바로 유찰됨
            
            return "fail";
        } catch (Exception e) {
            e.printStackTrace(); // 에러 로그 확인용
            return "fail"; // 서비스에서 RuntimeException이 터지면 무조건 실패 처리
        }
    }
    // 낙찰 취하 페이지 끝
    
    // 입찰 로그 영역
    // 아이템 리스트
    @GetMapping("/logs")
    public String bidLogsPage(Model model) {
    	List<Map<String, Object>> list = adminService.selectItemListForAdmin();
    	
        model.addAttribute("list", list);
        return "admin/bidLogList";
    }

    // 입찰 로그 상세 (AJAX)
    @GetMapping("/logs/{itemNo}")
    @ResponseBody
    public List<BidLogVo> getBidLogs(@PathVariable int itemNo) {
        return adminService.selectBidLogsByItem(itemNo);
    }
    
    @GetMapping(value="/users", produces="application/json; charset=UTF-8")
    @ResponseBody
    public List<Member> getUserList() {
        return adminService.getUserList();
    }
    
    @GetMapping(value="/logs/user/{userNo}", produces="application/json; charset=UTF-8")
    @ResponseBody
    public List<Bid> getUserBidLogs(@PathVariable int userNo) {
    	List<Bid> list = adminService.getUserBidLogs(userNo);
        return list;
    }
}
