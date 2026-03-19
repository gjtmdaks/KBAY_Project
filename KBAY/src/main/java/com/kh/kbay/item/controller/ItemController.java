package com.kh.kbay.item.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.kbay.item.model.vo.Item;
import com.kh.kbay.item.model.vo.ItemImg;
import com.kh.kbay.item.service.ItemService;
import com.kh.kbay.member.model.vo.Member;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/auction")
@RequiredArgsConstructor
public class ItemController {
	private final ItemService is;
	
	@GetMapping("nowdeal")
	public String nowDealItem(
				@RequestParam(value="page", defaultValue="1") int page,
				Model model) {

		int limit = 16;
	    int offset = (page - 1) * limit;

	    List<Item> list = is.selectNowdealList(limit, offset);
	    int totalCount = is.selectNowdealItemCount();

	    int maxPage = (int)Math.ceil((double)totalCount / limit);

	    model.addAttribute("itemList", list);
	    model.addAttribute("currentPage", page);
	    model.addAttribute("maxPage", maxPage);
	    
		return "item/nowDeal";
	}
	
	@GetMapping("enroll")
	public String itemEnrollForm(HttpSession session, RedirectAttributes ra) {
		Member loginUser = (Member) session.getAttribute("loginUser");
		if(loginUser == null) {
			ra.addFlashAttribute("alertMsg", "세션이 만료되었습니다. 다시 로그인해주세요.");
		    return "redirect:/member/loginForm.me";
		}
		
		return "item/itemEnroll";
	}

	@PostMapping("insert")
	public String insertItem(Item item, MultipartFile[] upfiles, HttpSession session, RedirectAttributes ra) {
		Member loginUser = (Member) session.getAttribute("loginUser");
		if(loginUser == null) {
			ra.addFlashAttribute("alertMsg", "세션이 만료되었습니다. 다시 로그인해주세요.");
		    return "redirect:/member/loginForm.me";
		}

		item.setUserNo(loginUser.getUserNo());
		
		String savePath = "C:/upload/item/";
		String webPath = "/kbay/upload/item/";
		
		File dir = new File(savePath);
		if (!dir.exists()) {
			dir.mkdirs();
		}

		List<ItemImg> imgList = new ArrayList<>();

		for (MultipartFile file : upfiles) {
			if (!file.isEmpty()) {
				String originName = file.getOriginalFilename();
				String ext = originName.substring(originName.lastIndexOf("."));
				String changeName = UUID.randomUUID().toString() + ext;

				try {
					file.transferTo(new File(savePath + changeName));
					
					ItemImg img = new ItemImg();
					img.setImgUrl(webPath + changeName);
					imgList.add(img);
					
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}

		item.setImgList(imgList);
		int result = is.insertItem(item);

		if (result > 0) {
            ra.addFlashAttribute("alertMsg", " 물품이 성공적으로 등록되었습니다!"); 
			return "redirect:/auction/nowdeal";
		} else {
            ra.addFlashAttribute("alertMsg", "물품 등록에 실패했습니다."); 
			return "redirect:/auction/nowdeal";
		}
	}
}
