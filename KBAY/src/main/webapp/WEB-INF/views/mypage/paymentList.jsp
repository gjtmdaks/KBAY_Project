<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>거래 현황</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/mypageCss/mypage.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/mypageCss/paymentList.css">
<style>
.btn-blue:disabled {
	background-color: #ccc;
	cursor: default;
}

.badge-y {
	background: #3282f6 !important;
	color: white;
}

.badge-s {
	background: #e74c3c !important;
	color: white;
}

.badge-p {
	background: #34495e !important;
	color: white;
}
</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />

	<div class="container">
		<jsp:include page="mypageSidebar.jsp" />

		<main class="content">
			<div class="content-title">
				거래 현황 (판매) <select class="sort-select">
					<option>최신 결제순</option>
				</select>
			</div>

			<c:if test="${empty list}">
				<div
					style="text-align: center; padding: 50px; background: white; border-radius: 10px;">
					결제 완료된 내역이 없습니다.</div>
			</c:if>

			<c:forEach var="item" items="${list}">
				<div class="item-card">
					<div class="item-img">
						<img src="${item.imgUrl}" alt="itemImage">
					</div>
					<div class="item-info">
						<span
							class="badge ${item.payStatus eq 'Y' ? 'badge-y' : (item.payStatus eq 'S' ? 'badge-s' : 'badge-p')}">
							${item.statusText} </span>
						<div class="item-name">${item.itemTitle}</div>
						<div class="item-date">구매자 ID: ${item.buyerId}</div>
					</div>
					<div class="item-price-area">
						<span class="price-label">최종 낙찰가</span> <span class="price-value">
							<fmt:formatNumber value="${item.currentPrice}" pattern="#,###" />
							원
						</span>
						<div class="btn-group">
							<c:choose>
								<%-- 1. 결제 완료(Y) --%>
								<c:when test="${item.payStatus eq 'Y'}">
									<button class="btn-blue" onclick="openDeliveryModal(${item.paymentNo}, ${item.itemNo})">배송 정보 입력</button>
								</c:when>

								<%-- 2. 배송 중(S) --%>
								<c:when test="${item.payStatus eq 'S'}">
									<button class="btn-blue"
										onclick="trackDelivery(${item.paymentNo}, ${item.itemNo})">배송
										추적</button>
								</c:when>

								<%-- 3. 최종 완료(P) --%>
								<c:when test="${item.payStatus eq 'P'}">
									<button class="btn-gray" disabled>거래 완료</button>
								</c:when>

								<%-- 4. 취소  --%>
								<c:otherwise>
									<button class="btn-gray" disabled>취소된 거래</button>
								</c:otherwise>
							</c:choose>

							<button class="btn-gray"
								onclick="location.href='${pageContext.request.contextPath}/auction/detail/${item.itemNo}'">상세보기</button>
						</div>
					</div>
				</div>
			</c:forEach>
		</main>
	</div>

	<div id="deliveryModal" class="modal"
		style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.5); z-index: 1000;">
		<div
			style="background: white; width: 450px; margin: 100px auto; padding: 25px; border-radius: 12px; box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);">
			<h3 style="margin-top: 0;">배송지 정보 확인</h3>
			<div id="buyerAddressInfo"
				style="background: #f9f9f9; padding: 15px; margin-bottom: 20px; font-size: 0.95em; border-radius: 8px; line-height: 1.6; border: 1px solid #eee;">
				<p style="margin: 5px 0;">
					<strong>수령인:</strong> <span id="dispName">로딩 중...</span>
				</p>
				<p style="margin: 5px 0;">
					<strong>연락처:</strong> <span id="dispPhone">-</span>
				</p>
				<p style="margin: 5px 0;">
					<strong>주소:</strong> <span id="dispAddr">-</span>
				</p>
				<p style="margin: 5px 0;">
					<strong>요청사항:</strong> <span id="dispReq">-</span>
				</p>
			</div>

			<form
				action="${pageContext.request.contextPath}/delivery/register.de"
				method="post">
				<input type="hidden" name="paymentNo" id="modalPaymentNo"> 
				<input type="hidden" name="itemNo" id="modalItemNo"> 
				<input type="hidden" name="buyerId" id="modalBuyerId"> 
				<input type="hidden" name="sellerId" id="modalSellerId"> 
				<input type="hidden" name="receiverName" id="modalReceiverName"> 
				<input type="hidden" name="receiverPhone" id="modalReceiverPhone">
				<input type="hidden" name="postCode" id="modalPostCode"> 
				<input type="hidden" name="address" id="modalAddress"> 
				<input type="hidden" name="addressDetail" id="modalAddressDetail">
				<input type="hidden" name="deliveryRequest" id="modalDeliveryRequest">
			 <input type="hidden" name="deliveryNo" id="modalDeliveryNo">
				<div style="margin-bottom: 15px;">
					<label
						style="font-weight: bold; display: block; margin-bottom: 5px;">택배사
						선택</label> <select name="courier"
						style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px;">
						<option value="CJ대한통운">CJ대한통운</option>
						<option value="한진택배">한진택배</option>
						<option value="우체국택배">우체국택배</option>
						<option value="로젠택배">로젠택배</option>
					</select>
				</div>
				<div style="margin-bottom: 25px;">
					<label
						style="font-weight: bold; display: block; margin-bottom: 5px;">운송장
						번호</label> <input type="text" name="trackingNo" placeholder="- 없이 숫자만 입력"
						style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px;"
						required>
				</div>
				<div style="display: flex; gap: 10px;">
					<button type="submit" class="btn-blue"
						style="flex: 1; padding: 12px;">배송 시작</button>
					<button type="button" onclick="closeModal()" class="btn-gray"
						style="flex: 1; padding: 12px;">취소</button>
				</div>
			</form>
		</div>
	</div>

	<script>
    // 1. 배송 모달 열기 함수
   function openDeliveryModal(paymentNo, itemNo) {
    document.getElementById("modalPaymentNo").value = paymentNo;
    document.getElementById("modalItemNo").value = itemNo;
    
    fetch('${pageContext.request.contextPath}/delivery/getAddr.de?paymentNo=' + paymentNo)
    .then(response => {
        if (!response.ok) throw new Error("Status: " + response.status);
        return response.text();
    })
    .then(text => { 
        if(!text) return;
        
        const data = JSON.parse(text); 
        console.log("수신된 배송지 데이터:", data);

        document.getElementById("modalBuyerId").value = data.buyerId;
        document.getElementById("modalSellerId").value = data.sellerId;
        document.getElementById("modalReceiverName").value = data.receiverName;
        document.getElementById("modalReceiverPhone").value = data.receiverPhone;
        document.getElementById("modalPostCode").value = data.postCode;
        document.getElementById("modalAddress").value = data.address;
        document.getElementById("modalAddressDetail").value = data.addressDetail;
        document.getElementById("modalDeliveryRequest").value = data.deliveryRequest;

        document.getElementById("dispName").innerText = data.receiverName;
        document.getElementById("dispPhone").innerText = data.receiverPhone || "-";
        document.getElementById("dispAddr").innerText = data.address || "-";
        document.getElementById("dispReq").innerText = data.deliveryRequest || "-";
        document.getElementById("modalDeliveryNo").value = data.deliveryNo;
        
        document.getElementById("deliveryModal").style.display = "block";
    }) 
    .catch(err => {
        console.error("오류:", err);
        alert("데이터를 불러오는 중 오류가 발생했습니다.");
    });
}

    // 2. 모달 닫기 함수
    function closeModal() {
        document.getElementById("deliveryModal").style.display = "none";
        document.getElementById("dispName").innerText = "로딩 중...";
    }

    // 3. 배송 추적
    let deliveryClickCount = {};
    function trackDelivery(paymentNo, itemNo) {
        if (!deliveryClickCount[paymentNo]) {
            deliveryClickCount[paymentNo] = 0;
        }

        deliveryClickCount[paymentNo]++;

        if (deliveryClickCount[paymentNo] >= 5) {
            if (confirm("배송을 완료 처리하시겠습니까?")) {
                completeDeliveryAjax(paymentNo, itemNo);
            }
        } else {
            alert("배송 조회 중... (" + deliveryClickCount[paymentNo] + "/5)");
        }
    }

    // 4. 배송 완료 처리 AJAX
    function completeDeliveryAjax(paymentNo, itemNo) {
        fetch('${pageContext.request.contextPath}/delivery/complete.de', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'paymentNo=' + paymentNo + '&itemNo=' + itemNo
        })
        .then(response => response.text())
        .then(result => {
            if (result === "success") {
                alert("배송이 완료되었습니다.");
                location.reload();
            } else {
                alert("처리 중 오류가 발생했습니다.");
            }
        })
        .catch(err => console.error(err));
    }
    
    function changeSort() {
        const sort = document.getElementById("sortSelect").value;
        location.href = "${pageContext.request.contextPath}/mypage/paymentList?sort=" + sort;
    }
</script>

	<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>