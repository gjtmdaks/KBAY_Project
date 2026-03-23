package com.kh.kbay.item.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.kbay.bid.service.BidService;
import com.kh.kbay.common.PageInfo;
import com.kh.kbay.item.model.vo.Item;
import com.kh.kbay.item.model.vo.ItemCategory;
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
	private final BidService bs;
	
	@GetMapping("{type}")
	public String itemList(
	        @PathVariable("type") String type,
	        @RequestParam(value="page", defaultValue="1") int page,
	        @RequestParam(value="keyword", required=false) String keyword,
	        Model model) {

	    int totalCount = is.selectItemCount(type, keyword);
	    PageInfo pi = PageInfo.of(page, totalCount, 16);

	    List<Item> list = is.selectItemList(type, keyword, pi);

	    for(Item i : list) {
	    	int bidCount = bs.selectBidCount(i.getItemNo());
	    	i.setBidCount(bidCount);
	    }
	    
	    model.addAttribute("itemList", list);
	    model.addAttribute("pi", pi);

	    // JSP에서 쓰는 값 따로 넣어줘야 함	
	    model.addAttribute("currentPage", pi.getCurrentPage());
	    model.addAttribute("maxPage", pi.getMaxPage());
	    model.addAttribute("type", type);
	    model.addAttribute("keyword", keyword);

	    return "item/" + type;
	}
	
	@GetMapping("enroll")
    public String itemEnrollForm(Authentication auth, RedirectAttributes ra) {
        if(auth == null || !auth.isAuthenticated()) {
            ra.addFlashAttribute("alertMsg", "로그인이 필요한 서비스입니다.");
            return "redirect:/member/login"; 
        }
        return "item/itemEnroll";
    }

    @PostMapping("insert")
    public String insertItem(Item item, MultipartFile[] upfiles, Authentication auth, RedirectAttributes ra) {
        if (auth == null || !auth.isAuthenticated()) {
            ra.addFlashAttribute("alertMsg", "로그인이 필요한 서비스입니다.");
            return "redirect:/member/login";
        }

        Member loginUser = (Member) auth.getPrincipal();
        
item.setUserNo(loginUser.getUserNo());
		
		String savePath = "C:/upload/item/";
		String serverIp = "192.168.10.25:8081";
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
					img.setImgUrl("http://" + serverIp + webPath + changeName);
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
			return "redirect:/auction/nowDeal";
		} else {
            ra.addFlashAttribute("alertMsg", "물품 등록에 실패했습니다."); 
			return "redirect:/auction/nowDeal";
		}
	}
	
	@GetMapping("/detail/{itemNo}")
	public String itemDetail(
	        @PathVariable("itemNo") int itemNo,
	        Model model,
	        HttpServletRequest request,
	        HttpServletResponse response
	        ) {
		
		Item item = is.selectItemDetail(itemNo, request, response);

	    int bidCount = bs.selectBidCount(itemNo);
	    int currentPrice = bs.selectCurrentPrice(itemNo);
	    int maxPrice = bs.selectMaxPrice(itemNo);
		
		if(item == null) {
			return "common/errorPage"; 
		}
		
		ItemCategory itemCategory = is.selectItemCategory(item.getItemCdNo());

	    model.addAttribute("item", item);
	    model.addAttribute("itemCategory", itemCategory);
	    model.addAttribute("bidCount", bidCount);
	    model.addAttribute("currentPrice", currentPrice);
	    model.addAttribute("maxPrice", maxPrice);
	    model.addAttribute("now", new Date());
		
		return "item/itemDetail";
	}
}