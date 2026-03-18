package com.kh.kbay.item.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.kbay.item.model.vo.Item;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Repository
@Slf4j
@RequiredArgsConstructor
public class ItemDaoImpl implements ItemDao {
	private final SqlSessionTemplate session;

	@Override
	public List<Item> selectAuctionList() {
		return session.selectList("item.selectAuctionList");
	}
	
}
