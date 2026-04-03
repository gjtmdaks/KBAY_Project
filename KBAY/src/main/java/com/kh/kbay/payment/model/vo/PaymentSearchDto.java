package com.kh.kbay.payment.model.vo;

import lombok.Data;

@Data
public class PaymentSearchDto {
    String keyword;
    String filter;
    String sort;
}
