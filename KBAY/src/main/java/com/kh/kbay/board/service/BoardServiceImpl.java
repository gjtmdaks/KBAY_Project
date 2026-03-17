package com.kh.kbay.board.service;

import org.springframework.stereotype.Service;

import com.kh.kbay.board.dao.BoardDao;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class BoardServiceImpl implements BoardService {
	private final BoardDao bd;
}
