package com.kh.kbay.item.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.kbay.item.dao.ItemDao;
import com.kh.kbay.item.model.vo.Item;
import com.kh.kbay.item.model.vo.ItemImg;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class ItemServiceImpl implements ItemService {
	private final ItemDao id;

	@Override
	public List<Item> selectNowdealList(int limit, int offset) {
		Map<String, Object> param = new HashMap<>();
	    param.put("limit", limit);
	    param.put("offset", offset);

	    return id.selectNowdealList(param);
	}

	@Override
	public int selectNowdealItemCount() {
		return id.selectNowdealItemCount();
	}
	
	@Transactional
	@Override
	public int insertItem(Item item) {
	    // 1. 상품 정보 INSERT
	    int result = id.insertItem(item);
	    
	    // 2. INSERT 성공했고 이미지가 있다면 이미지도 INSERT
	    if (result > 0 && item.getImgList() != null && !item.getImgList().isEmpty()) {
	        for (ItemImg img : item.getImgList()) {
	            img.setItemNo(item.getItemNo()); // 새롭게 생성된 상품번호를 이미지 객체에 전달
	            id.insertItemImg(img); // 이미지 insert
	        }
	    }
	    return result;
	}
}
