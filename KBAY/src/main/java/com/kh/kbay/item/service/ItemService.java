package com.kh.kbay.item.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.kh.kbay.common.PageInfo;
import com.kh.kbay.item.model.vo.Item;
import com.kh.kbay.item.model.vo.ItemCategory;

public interface ItemService {
	int selectItemCount(String type, String keyword);

	List<Item> selectItemList(String type, String keyword, PageInfo pi);

	int insertItem(Item item);

	Item selectItemDetail(int itemNo, HttpServletRequest request, HttpServletResponse response);

	ItemCategory selectItemCategory(int itemCdNo);

	int updateItemStatus();
	
	List<Item> selectBestItems();

	List<Item> findEndedItems();

	void updateEndItemStatus(int itemNo);

    Item selectItemByNo(int itemNo);

	int checkWishlist(Map<String, Object> map);
}
