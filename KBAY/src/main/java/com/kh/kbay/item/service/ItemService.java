package com.kh.kbay.item.service;

import java.util.List;

import com.kh.kbay.item.model.vo.Item;

public interface ItemService {

	List<Item> selectNowdealList(int limit, int offset);

	int selectNowdealItemCount();

}
