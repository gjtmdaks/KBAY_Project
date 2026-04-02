<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div class="checkout-container" style="max-width: 600px; margin: 50px auto; padding: 20px; border: 1px solid #ddd; background: white; border-radius: 12px;">
    <h3>결제하기 - ${item.itemTitle}</h3>
    <hr>
    
    <div class="delivery-section" style="margin-bottom: 30px;">
        <h4>배송 정보</h4>
        <div style="display: flex; flex-direction: column; gap: 10px;">
            <input type="text" id="receiverName" placeholder="수령인 성함" style="padding: 10px; border: 1px solid #ccc; border-radius: 4px;">
            <input type="text" id="receiverPhone" placeholder="연락처 (- 없이 입력)" style="padding: 10px; border: 1px solid #ccc; border-radius: 4px;">
            <div style="display: flex; gap: 5px;">
                <input type="text" id="postCode" placeholder="우편번호" readonly style="flex: 1; padding: 10px; border: 1px solid #ccc; border-radius: 4px;">
                <button type="button" onclick="searchAddress()" style="padding: 10px; background: #666; color: white; border: none; border-radius: 4px; cursor: pointer;">주소 찾기</button>
            </div>
            <input type="text" id="address" placeholder="기본 주소" readonly style="padding: 10px; border: 1px solid #ccc; border-radius: 4px;">
            <input type="text" id="addressDetail" placeholder="상세 주소" style="padding: 10px; border: 1px solid #ccc; border-radius: 4px;">
            <textarea id="deliveryRequest" placeholder="배송 요청사항 (선택)" style="padding: 10px; border: 1px solid #ccc; border-radius: 4px; height: 60px; resize: none;"></textarea>
        </div>
    </div>

    <div id="payment-method"></div>
    <div id="agreement"></div>
    
    <button id="payment-request-button" style="width:100%; padding:15px; background:#3282f6; color:white; border:none; border-radius:8px; font-size:18px; cursor:pointer; margin-top: 20px;">
        <fmt:formatNumber value="${item.currentPrice}" pattern="#,###"/>원 결제하기
    </button>
</div>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://js.tosspayments.com/v2/standard"></script>
<script>
function searchAddress() {
    new daum.Postcode({
        oncomplete: function(data) {
            document.getElementById('postCode').value = data.zonecode;
            document.getElementById('address').value = data.address;
            document.getElementById('addressDetail').focus();
        }
    }).open();
}

async function initPayment() {
    const tossPayments = TossPayments("test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm");
    const widgets = tossPayments.widgets({ customerKey: "USER_${loginUser.userNo}" });
    const price = parseInt("${item.currentPrice}".replace(/,/g, ""));

    await widgets.setAmount({ currency: "KRW", value: price });

    await Promise.all([
        widgets.renderPaymentMethods({ selector: "#payment-method", variantKey: "DEFAULT" }),
        widgets.renderAgreement({ selector: "#agreement", variantKey: "AGREEMENT" })
    ]);

    document.getElementById("payment-request-button").addEventListener("click", async () => {
        const rName = document.getElementById("receiverName").value;
        const rPhone = document.getElementById("receiverPhone").value;
        const pCode = document.getElementById("postCode").value;
        const addr = document.getElementById("address").value;
        const addrDetail = document.getElementById("addressDetail").value;
        const req = document.getElementById("deliveryRequest").value;

        if(!rName || !rPhone || !pCode || !addr) {
            alert("배송 정보를 모두 입력해주세요.");
            return;
        }

        await widgets.requestPayment({
            orderId: "ORDER_${item.itemNo}_" + new Date().getTime(),
            orderName: "${item.itemTitle}",
            successUrl: window.location.origin + "${pageContext.request.contextPath}/payment/success?itemNo=${item.itemNo}" 
                        + "&receiverName=" + encodeURIComponent(rName)
                        + "&receiverPhone=" + encodeURIComponent(rPhone)
                        + "&postCode=" + encodeURIComponent(pCode)
                        + "&address=" + encodeURIComponent(addr)
                        + "&addressDetail=" + encodeURIComponent(addrDetail)
                        + "&deliveryRequest=" + encodeURIComponent(req),
            failUrl: window.location.origin + "${pageContext.request.contextPath}/payment/fail",
            customerEmail: "${loginUser.userEmail}",
            customerName: "${loginUser.userName}"
        });
    });
}
initPayment();
</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />