package com.kh.kbay.item.dao;

import java.util.List;
import java.util.Map;

import com.kh.kbay.item.model.vo.Item;
import com.kh.kbay.item.model.vo.ItemImg;

public interface ItemDao {

	List<Item> selectNowdealList(Map<String, Object> param);

	int selectNowdealItemCount();

	int insertItem(Item item);

	int insertItemImg(ItemImg img);

}
