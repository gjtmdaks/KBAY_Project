package com.kh.kbay.board.model.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class BoardImg {
	private int boardNo;
	private char imgLevel;
	private String originName;
	private String changeName;
	private int boardImgNo;
}
