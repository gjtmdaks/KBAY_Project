package com.kh.kbay.mypage.model.vo;

import lombok.Data;

@Data
public class FaqImg {
    private int fileId;
    private int faqId;
    private String originName;
    private String changeName;
    private String filePath;
}
