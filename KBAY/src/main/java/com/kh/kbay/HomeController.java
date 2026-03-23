package com.kh.kbay;

import java.util.List;
import java.util.Locale;

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
@RequestMapping("/")
@RequiredArgsConstructor
public class HomeController {
	private final ItemService is;
	
	@GetMapping("/")
	public String home(Locale locale, Model model) {
		List<Item> bestList = is.selectBestItems();
		model.addAttribute("bestList", bestList);
		return "home";
	}

}
