package com.kh.kbay.common.controller;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@ControllerAdvice
public class ExceptionController {

    @ExceptionHandler(Exception.class)
    public ModelAndView handleException(Exception e) throws Exception {
        log.error("에러 발생 원인 : ", e);
        

        ModelAndView mav = new ModelAndView();
        mav.addObject("errorMsg", "서비스 이용 중 예상치 못한 오류가 발생했습니다.");
        mav.setViewName("common/errorPage");
        return mav;
    }
}