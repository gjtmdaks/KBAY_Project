package com.kh.kbay.item.dao;

import java.util.List;

import com.kh.kbay.item.model.vo.Item;

public interface ItemDao {

	List<Item> selectAuctionList();

}
