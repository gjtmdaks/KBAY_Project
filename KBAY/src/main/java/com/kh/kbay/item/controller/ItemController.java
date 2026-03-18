package com.kh.kbay.item.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.kh.kbay.item.model.vo.Item;
import com.kh.kbay.item.service.ItemService;

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
	
	@GetMapping("enddeal")
	public String endDealItem(
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
	    
		return "item/endDeal";
	}
	
	@GetMapping("yetdeal")
	public String yetDealItem(
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
	    
		return "item/yetDeal";
	}
}
