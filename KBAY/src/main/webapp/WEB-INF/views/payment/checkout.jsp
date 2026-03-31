<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div class="checkout-container" style="max-width: 600px; margin: 50px auto; padding: 20px; border: 1px solid #ddd;">
    <h3>결제하기 - ${item.itemTitle}</h3>
    <p>결제 금액: <strong><fmt:formatNumber value="${item.currentPrice}" pattern="#,###"/>원</strong></p>
    
    <div id="payment-method"></div>
    <div id="agreement"></div>
    
    <button id="payment-request-button" style="width:100%; padding:15px; background:#3282f6; color:white; border:none; border-radius:8px; font-size:18px; cursor:pointer;">
        ${item.currentPrice}원 결제하기
    </button>
</div>

<script src="https://js.tosspayments.com/v2/standard"></script>
<script>
    async function initPayment() {
        const tossPayments = TossPayments("test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm"); // 테스트 클라이언트 키
        const widgets = tossPayments.widgets({ customerKey: "USER_${loginUser.userNo}" });

        // 결제 금액 설정
        await widgets.setAmount({
            currency: "KRW",
            value: ${item.currentPrice}
        });

        // 위젯 렌더링
        await Promise.all([
            widgets.renderPaymentMethods({ selector: "#payment-method", variantKey: "DEFAULT" }),
            widgets.renderAgreement({ selector: "#agreement", variantKey: "AGREEMENT" })
        ]);

        document.getElementById("payment-request-button").addEventListener("click", async () => {
            await widgets.requestPayment({
                orderId: "ORDER_" + ${item.itemNo} + "_" + new Date().getTime(),
                orderName: "${item.itemTitle}",
                successUrl: window.location.origin + "${pageContext.request.contextPath}/payment/success?itemNo=${item.itemNo}",
                failUrl: window.location.origin + "${pageContext.request.contextPath}/payment/fail",
                customerEmail: "${loginUser.userEmail}",
                customerName: "${loginUser.userName}"
            });
        });
    }
    initPayment();
</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />