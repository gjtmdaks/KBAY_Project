package com.kh.kbay.item.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.kbay.common.PageInfo;
import com.kh.kbay.item.dao.ItemDao;
import com.kh.kbay.item.model.vo.Item;
import com.kh.kbay.item.model.vo.ItemCategory;
import com.kh.kbay.item.model.vo.ItemImg;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class ItemServiceImpl implements ItemService {
	private final ItemDao id;

	@Override
	public int selectItemCount(String type, String keyword) {
	    Map<String, Object> param = new HashMap<>();
	    param.put("type", type);
	    param.put("keyword", keyword);
	    return id.selectItemCount(param);
	}

	@Override
	public List<Item> selectItemList(String type, String keyword, PageInfo pi) {
	    Map<String, Object> param = new HashMap<>();
	    param.put("type", type);
	    param.put("keyword", keyword);
	    param.put("offset", pi.getOffset());
	    param.put("limit", pi.getLimit());

	    return id.selectItemList(param);
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

	@Override
	public Item selectItemDetail(int itemNo, HttpServletRequest request, HttpServletResponse response) {
		Item item = id.selectItemDetail(itemNo);
		List<ItemImg> imgList = id.selectItemImgList(itemNo);
		
		// --- [조회수 증가 로직 (쿠키 활용)] ---
        Cookie[] cookies = request.getCookies();
        boolean hasVisited = false;

        if (cookies != null) {
            for (Cookie c : cookies) {
                if (c.getName().equals("viewedItems") && c.getValue().contains("[" + itemNo + "]")) {
                    hasVisited = true;
                    break;
                }
            }
        }

        if (!hasVisited) {
            // 1. DB 조회수 1 증가
            id.incrementViews(itemNo); 

            // 2. 쿠키 업데이트
            String cookieValue = "";
            if (cookies != null) {
                for (Cookie c : cookies) {
                    if (c.getName().equals("viewedItems")) {
                        cookieValue = c.getValue();
                    }
                }
            }
            
            Cookie newCookie = new Cookie("viewedItems", cookieValue + "[" + itemNo + "]");
            newCookie.setMaxAge(60 * 60 * 24); // 24시간 유지
            newCookie.setPath(request.getContextPath()); // 해당 프로젝트 경로에서만 유효
            response.addCookie(newCookie);
        }
        
		// 정렬 보장 (혹시 몰라서)
		imgList.sort((a,b) -> a.getItemImgNo() - b.getItemImgNo());

		// 대표이미지
		if(!imgList.isEmpty()){
		    item.setMainImg(imgList.get(0).getImgUrl());
		    item.setSubImgList(imgList.subList(1, imgList.size()));
		}

		item.setImgList(imgList);
		
		return item;
	}

	@Override
	public ItemCategory selectItemCategory(int itemCdNo) {
		return id.selectItemCategory(itemCdNo);
	}

	@Override
	public int updateItemStatus() {
		return id.updateItemStatus();
	}
	
	@Override
	public List<Item> selectBestItems(){
		return id.selectBestItems();
	}

	@Override
	public List<Item> findEndedItems() {
		return id.findEndedItems();
	}

	@Override
	public void updateEndItemStatus(int itemNo) {
		id.updateEndItemStatus(itemNo);
	}
}
