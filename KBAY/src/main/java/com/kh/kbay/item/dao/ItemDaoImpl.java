package com.kh.kbay.item.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.kbay.item.model.vo.Item;
import com.kh.kbay.item.model.vo.ItemCategory;
import com.kh.kbay.item.model.vo.ItemImg;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Repository
@Slf4j
@RequiredArgsConstructor
public class ItemDaoImpl implements ItemDao {
	private final SqlSessionTemplate session;

	@Override
	public int selectItemCount(Map<String, Object> param) {
		return session.selectOne("item.selectItemCount", param);
	}

	@Override
	public List<Item> selectItemList(Map<String, Object> param) {
		return session.selectList("item.selectItemList", param);
	}

	@Override
	public int insertItem(Item item) {
		return session.insert("item.insertItem", item);
	}

	@Override
	public int insertItemImg(ItemImg img) {
		return session.insert("item.insertItemImg", img);
	}

	@Override
	public Item selectItemDetail(int itemNo) {
		return session.selectOne("item.selectItemDetail", itemNo);
	}

	@Override
	public ItemCategory selectItemCategory(int itemCdNo) {
		return session.selectOne("item.selectItemCategory", itemCdNo);
	}

	@Override
	public List<ItemImg> selectItemImgList(int itemNo) {
		return session.selectList("item.selectItemImgList", itemNo);
	}

	@Override
	public int updateItemStatus() {
		return session.update("item.updateItemStatus");
	}

	@Override
	public int incrementViews(int itemNo) {
		return session.update("item.incrementViews", itemNo);
	}
	
	@Override
	public List<Item> selectBestItems(){
		return session.selectList("item.selectBestItems");
	}

	@Override
	public List<Item> findEndedItems() {
		return session.selectList("item.findEndedItems");
	}

	@Override
	public void updateEndItemStatus(int itemNo) {
		session.update("item.updateEndItemStatus", itemNo);
	}
	
    @Override
    public Item selectItemByNo(int itemNo) {
        return session.selectOne("item.selectItemByNo",itemNo);
    }

	@Override
	public int checkWishlist(Map<String, Object> map) {
		return session.selectOne("item.checkWishlist", map);
	}

	@Override
	public void endByBuyNow(Map<String, Object> param) {
		session.update("item.endByBuyNow", param);
	}
}
