package com.kh.kbay.item.service;

import org.springframework.stereotype.Service;

import com.kh.kbay.item.dao.ItemDao;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class ItemServiceImpl implements ItemService {
	private final ItemDao id;
}
