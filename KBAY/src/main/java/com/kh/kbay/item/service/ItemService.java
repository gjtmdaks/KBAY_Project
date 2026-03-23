package com.kh.kbay.item.service;

import java.util.List;

import com.kh.kbay.common.PageInfo;
import com.kh.kbay.item.model.vo.Item;
import com.kh.kbay.item.model.vo.ItemCategory;

public interface ItemService {

	int selectItemCount(String type, String keyword);

	List<Item> selectItemList(String type, String keyword, PageInfo pi);

	int insertItem(Item item);

	Item selectItemDetail(int itemNo);

	ItemCategory selectItemCategory(int itemCdNo);

	int updateItemStatus();

}
