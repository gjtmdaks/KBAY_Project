package com.kh.kbay.item.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kh.kbay.item.model.vo.Item;
import com.kh.kbay.item.service.ItemService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/item")
@RequiredArgsConstructor
public class ItemController {
	private final ItemService is;
	
	@GetMapping("yetstart")
	public String yetStartItem(Model model) {

	    List<Item> list = is.selectAuctionList();

	    model.addAttribute("itemList", list);
		return "item/yetStart";
	}
}
