package com.kh.kbay.notification.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Repository
@Slf4j
@RequiredArgsConstructor
public class NotificationDaoImpl implements NotificationDao {
	private final SqlSessionTemplate session;
	
}
