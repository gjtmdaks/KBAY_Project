package com.kh.kbay.board.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.kbay.board.model.vo.Reply;
import com.kh.kbay.board.service.ReplyService;
import com.kh.kbay.member.model.vo.Member;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/reply")
@RequiredArgsConstructor
public class ReplyController {
	private final ReplyService rs;

	// 댓글 등록
	@ResponseBody
	@PostMapping("/insertReply")
	public String insertReply(@RequestParam("boardNo") int boardNo, @RequestParam("replyContent") String replyContent,
			Authentication auth) {

		// 1. 로그인 안 한 사람이 AJAX를 쏘면 컷! (보안)
		if (auth == null || !auth.isAuthenticated()) {
			return "fail";
		}

		Member loginUser = (Member) auth.getPrincipal();

		// 2. 파라미터로 받은 내용들을 댓글 객체나 Map에 담기.
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("boardNo", boardNo);
		paramMap.put("replyContent", replyContent);
		paramMap.put("userNo", loginUser.getUserNo());

		// 3. DB에 INSERT
		int result = rs.insertReply(paramMap);

		if (result > 0) {
			return "success"; // JS의 if(result === "success") 부분으로 쏙 들어갑니다!
		} else {
			return "fail";
		}
	}

	// 댓글 수정
	@PostMapping("/update")
	@ResponseBody
	public String updateReply(Reply r, Authentication auth) {

	    if (auth == null || !auth.isAuthenticated()) return "fail";

	    int loginUser = ((Member) auth.getPrincipal()).getUserNo();

	    Reply origin = rs.selectReply(r.getReplyNo());

	    if (origin == null) return "fail";
	    if (loginUser != origin.getUserNo()) return "fail";

	    int result = rs.updateReply(r);

	    return result > 0 ? "success" : "fail";
	}

	// 댓글 삭제
	@PostMapping("/deleteReply")
	@ResponseBody
	public String deleteReply(@RequestParam("replyNo") int replyNo,
	                          Authentication auth) {

	    if (auth == null || !auth.isAuthenticated()) return "fail";

	    int loginUser = ((Member) auth.getPrincipal()).getUserNo();

	    Reply origin = rs.selectReply(replyNo);

	    if (origin == null) return "fail";
	    if (loginUser != origin.getUserNo()) return "fail";

	    int result = rs.deleteReply(replyNo);

	    return result > 0 ? "success" : "fail";
	}
}
