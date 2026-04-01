<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/common/header.jsp" />

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/payment/receipt.css">

<div class="receipt-wrapper">
    <div class="receipt-card">
        <div class="receipt-header">
            <div class="success-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="20 6 9 17 4 12"></polyline>
                </svg>
            </div>
            <h2>결제가 완료되었습니다!</h2>
            <p class="subtitle">낙찰받으신 물품의 결제가 정상적으로 처리되었습니다.</p>
        </div>

        <div class="receipt-body">
            <div class="item-summary">
                <span class="label">결제 상품</span>
                <strong class="value">${paymentData.orderName}</strong>
            </div>
            
            <div class="price-major">
                <span class="label">최종 결제 금액</span>
                <strong class="amount">
                    <fmt:formatNumber value="${paymentData.totalAmount}" pattern="#,###"/>
                    <span class="unit">원</span>
                </strong>
            </div>

            <div class="detail-list">
                <div class="detail-item">
                    <span class="d-label">주문번호</span>
                    <span class="d-value">${paymentData.orderId}</span>
                </div>
                <div class="detail-item">
                    <span class="d-label">결제수단</span>
                    <span class="d-value">${paymentData.method}</span>
                </div>
                <div class="detail-item">
                    <span class="d-label">결제일시</span>
                    <span class="d-value">
                        <c:choose>
                            <c:when test="${paymentData.approvedAt.contains('T')}">
                                ${paymentData.approvedAt.substring(0,10)} ${paymentData.approvedAt.substring(11,19)}
                            </c:when>
                            <c:otherwise>${paymentData.approvedAt}</c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </div>
        </div>

        <div class="receipt-footer">
            <button type="button" class="btn-secondary" onclick="window.open('${receiptUrl}', 'receipt', 'width=500,height=700')">
                공식 영수증 확인
            </button>
            <button type="button" class="btn-primary" onclick="location.href='${pageContext.request.contextPath}/mypage/wonList'">
                낙찰 목록으로 이동
            </button>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />