package com.kh.kbay.mypage.controller;

import java.util.List;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kh.kbay.board.model.vo.BoardPost;
import com.kh.kbay.item.model.vo.Item;
import com.kh.kbay.member.model.vo.Member;
import com.kh.kbay.mypage.model.vo.BidListDto;
import com.kh.kbay.mypage.model.vo.ReplyListDto;
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

    // 입찰
    @GetMapping("bidList")
    public String bidList(Authentication auth, Model model) {
        Member user = (Member) auth.getPrincipal();
        
        List<BidListDto> list = ms.getBidList(user.getUserNo());
        
        model.addAttribute("list", list);
        return "mypage/bidList";
    }

    // 판매
    @GetMapping("saleList")
    public String saleList(Authentication auth, Model model) {
        Member user = (Member) auth.getPrincipal();
        
        List<Item> list = ms.getSaleList(user.getUserNo());
        
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
    public String boardList(Authentication auth, Model model) {
        Member user = (Member) auth.getPrincipal();
        
        List<BoardPost> list = ms.getBoardList(user.getUserNo());
        
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

    // 신고
    @GetMapping("reportList")
    public String reportList(Authentication auth, Model model) {
        Member user = (Member) auth.getPrincipal();
        
        List<Report> list = ms.getReportList(user.getUserNo());
        
        model.addAttribute("list", list);
        return "mypage/reportList";
    }
}
