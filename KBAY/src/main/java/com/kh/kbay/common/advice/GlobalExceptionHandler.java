package com.kh.kbay.common.advice;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.HashMap;
import java.util.Map;

@RestControllerAdvice // @Controller + @ResponseBody (JSON 응답용)
public class GlobalExceptionHandler {

    /**
     * JSON 파싱 에러 처리 (예: int 범위를 넘어서는 큰 숫자 입력 시)
     */
    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<Map<String, Object>> handleJsonParseException(HttpMessageNotReadableException e) {
        Map<String, Object> result = new HashMap<>();
        
        result.put("result", "FAIL");
        // 사용자에게 보여줄 메시지
        result.put("message", "입력한 금액이 허용 범위를 넘었거나 형식이 올바르지 않습니다.");
        
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(result);
    }
}