package com.kh.kbay.item.dao;

import java.util.List;
import java.util.Map;

import com.kh.kbay.item.model.vo.Item;
import com.kh.kbay.item.model.vo.ItemCategory;
import com.kh.kbay.item.model.vo.ItemImg;

public interface ItemDao {

	int selectItemCount(Map<String, Object> param);

	List<Item> selectItemList(Map<String, Object> param);

	int insertItem(Item item);

	int insertItemImg(ItemImg img);

	Item selectItemDetail(int itemNo);

	ItemCategory selectItemCategory(int itemCdNo);

	List<ItemImg> selectItemImgList(int itemNo);

}
