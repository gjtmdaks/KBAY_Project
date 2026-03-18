package com.kh.kbay.item.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.kh.kbay.item.dao.ItemDao;
import com.kh.kbay.item.model.vo.Item;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class ItemServiceImpl implements ItemService {
	private final ItemDao id;

	@Override
	public List<Item> selectAuctionList() {
		return id.selectAuctionList();
	}
}
