package com.kh.kbay.mypage.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.kh.kbay.board.model.vo.BoardPost;
import com.kh.kbay.item.model.vo.Item;
import com.kh.kbay.item.service.ItemService;
import com.kh.kbay.member.model.vo.Member;
import com.kh.kbay.mypage.model.vo.BidListDto;
import com.kh.kbay.mypage.model.vo.Faq;
import com.kh.kbay.mypage.model.vo.FaqImg;
import com.kh.kbay.mypage.model.vo.ReplyListDto;
import com.kh.kbay.mypage.model.vo.SaleListDto;
import com.kh.kbay.mypage.model.vo.WishListDto;
import com.kh.kbay.mypage.service.MypageService;
import com.kh.kbay.report.model.vo.Report;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/mypage")
@RequiredArgsConstructor
public class MypageController {

    private final MypageService ms;
    private final ItemService is;

    // 메인
    @GetMapping("mypage.me")
    public String mypageHome(Authentication auth, Model model) {
        Member user = (Member) auth.getPrincipal();
        model.addAttribute("user", user);
        model.addAttribute("accidentCount", ms.getAccidentCount(user.getUserNo()));
        return "mypage/mypageHome";
    }
    
    // 내 정보 수정
    @GetMapping("updateStatus")
    public String updateStatus(Authentication auth, Model model) {
    	// 로그인 유저 가져오기
        Member loginUser = (Member) auth.getPrincipal();

        if(loginUser == null) {
            return "redirect:/login"; // 로그인 안했으면 튕김
        }

        // JSP로 전달
        model.addAttribute("user", loginUser);

        return "mypage/updateStatus";
    }
    
    @PostMapping("updateStatus")
    public String updateStatus(Member user, Authentication auth) {

        Member loginUser = (Member) auth.getPrincipal();

        if(loginUser == null){
            return "redirect:/login";
        }

        user.setUserNo(loginUser.getUserNo());

        int result = ms.updateUser(user);

        if(result > 0){

            // 1. DB 재조회
            Member updatedUser = ms.selectUserByNo(loginUser.getUserNo());

            // 2. Authentication 새로 생성
            Authentication newAuth = new UsernamePasswordAuthenticationToken(
                    updatedUser,
                    auth.getCredentials(),
                    auth.getAuthorities()
            );

            // 3. SecurityContext 갱신
            SecurityContextHolder.getContext().setAuthentication(newAuth);

            return "redirect:/mypage/mypage.me";
        }

        return "redirect:/mypage/updateStatus";
    }

    // 입찰
    @GetMapping("bidList")
    public String bidList(Authentication auth, Model model) {
        Member user = (Member) auth.getPrincipal();
        
        System.out.println(user);
        List<BidListDto> list = ms.getBidList(user.getUserNo());
        System.out.println(list);
        model.addAttribute("list", list);
        return "mypage/bidList";
    }

    // 판매
    @GetMapping("saleList")
    public String saleList(Authentication auth, Model model) {
        Member user = (Member) auth.getPrincipal();
        
        List<SaleListDto> list = ms.getSaleList(user.getUserNo());
        
        model.addAttribute("list", list);
        return "mypage/saleList";
    }

    // 찜
    @GetMapping("wishList")
    public String wishList(Authentication auth, Model model) {
        Member user = (Member) auth.getPrincipal();
        
        List<WishListDto> list = ms.getWishList(user.getUserNo());
        
        model.addAttribute("list", list);
        return "mypage/wishList";
    }

    // 게시글
    @GetMapping("boardList")
    public String getBoardList(
            @RequestParam(value="category", required=false) Integer category,
            Authentication auth,
            Model model) {

        Member loginUser = (Member) auth.getPrincipal();

        int userNo = loginUser.getUserNo();

        List<BoardPost> list;

        if(category == null){
            list = ms.getBoardList(userNo);
        } else {
            list = ms.getBoardListByCategory(userNo, category);
        }

        model.addAttribute("list", list);

        return "mypage/boardList";
    }

    // 댓글
    @GetMapping("replyList")
    public String replyList(Authentication auth, Model model) {
        Member user = (Member) auth.getPrincipal();
        
        List<ReplyListDto> list = ms.getReplyList(user.getUserNo());
        
        model.addAttribute("list", list);
        return "mypage/replyList";
    }

    // 신고한 것
    @GetMapping("reportList")
    public String reportList(Authentication auth, Model model) {
        Member user = (Member) auth.getPrincipal();
        
        List<Report> list = ms.getReportList(user.getUserNo());
        
        model.addAttribute("list", list);
        return "mypage/reportList";
    }

    // 신고당한 것
    @GetMapping("reportedList")
    public String reportedList(Authentication auth, Model model) {
        Member user = (Member) auth.getPrincipal();
        
        List<Report> list = ms.getReportedList(user.getUserNo());
        
        model.addAttribute("list", list);
        return "mypage/reportedList";
    }
    
    // 문의 목록
    @GetMapping("faq")
    public String faqList(Authentication auth, Model model) {
        Member user = (Member) auth.getPrincipal();

        List<Faq> list = ms.getFaqList(user.getUserNo());
        model.addAttribute("list", list);

        return "mypage/faq";
    }

    // 문의 작성 페이지
    @GetMapping("faq/write")
    public String faqWriteForm(Authentication auth, Model model) {

        Member loginUser = (Member) auth.getPrincipal();

        model.addAttribute("loginUser", loginUser);
        model.addAttribute("categoryList", ms.getCategoryList());

        return "mypage/faqWrite";
    }

    // 문의 등록
    @PostMapping("faq/insert")
    public String insertFaq(
            Faq faq,
            @RequestParam(value="upfile", required=false) List<MultipartFile> files,
            Authentication auth
    ) {
        Member user = (Member) auth.getPrincipal();
        faq.setUserNo(user.getUserNo());

        ms.insertFaq(faq, files);

        return "redirect:/mypage/faq";
    }

    // 상세
    @GetMapping("faq/detail")
    public String faqDetail(@RequestParam("id") int id, Model model) {

        model.addAttribute("faq", ms.getFaqDetail(id));
        
        List<FaqImg> fileList = ms.getFaqFiles(id);
        model.addAttribute("fileList", fileList); // ★ 추가
        

        return "mypage/faqDetail";
    }
 // 낙찰 물품 조회
    @GetMapping("wonList")
    public String wonList(
            Authentication auth, 
            @RequestParam(value="sort", defaultValue="latest") String sort, 
            Model model) {
        
        Member user = (Member) auth.getPrincipal();
        
        // 정렬 정보를 담은 Map 생성
        Map<String, Object> map = new HashMap<>();
        map.put("userNo", user.getUserNo());
        map.put("sort", sort);
        
        List<BidListDto> list = ms.getWonList(map);
        
        model.addAttribute("list", list);
        return "mypage/wonList";
    }
    
 // 결제 페이지 이동
    @GetMapping("checkout")
    public String checkout(@RequestParam("itemNo") int itemNo, Authentication auth, Model model) {
    	Item item = is.selectItemByNo(itemNo); 
        model.addAttribute("item", item);
        model.addAttribute("loginUser", (Member) auth.getPrincipal());
        return "mypage/checkout";
    }

    
}
