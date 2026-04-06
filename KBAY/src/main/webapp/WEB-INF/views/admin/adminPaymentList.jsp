<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mypageCss/mypage.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/adminCss/admin.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/adminCss/adminPayment.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="admin-wrap">
    <jsp:include page="/WEB-INF/views/admin/adminSidebar.jsp" />

    <main class="main-content">
        <h2>회원 결제 내역 관리</h2>

		<form method="get">
		    <div class="top-bar">
		        <input type="text" name="keyword" id="searchKeyword"
		               placeholder="회원명 또는 번호"
		               value="${keyword}">
		
		        <select name="sort" id="sortOrder">
		            <option value="latest" ${sort == 'latest' ? 'selected' : ''}>최신순</option>
		            <option value="oldest" ${sort == 'oldest' ? 'selected' : ''}>오래된순</option>
		            <option value="priceDesc" ${sort == 'priceDesc' ? 'selected' : ''}>금액 높은순</option>
		            <option value="priceAsc" ${sort == 'priceAsc' ? 'selected' : ''}>금액 낮은순</option>
		        </select>
		
		        <button type="submit">검색</button>
		    </div>
		</form>

		<div class="payment-list">
		    <c:forEach var="p" items="${list}">
		        <div class="payment-card"
		             onclick="location.href='${contextPath}/auction/detail/${p.ITEM_NO}'">
		
		            <img src="${p.IMG_URL}" class="thumb"
		                 onerror="this.src='https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg'">
		
		            <div class="info">
		                <div class="badge">${p.payStatus}</div>
		                <h3 class="title">${p.ITEM_TITLE}</h3>
		
		                <p class="meta">
		                    👤 ${p.USER_NAME} (${p.USER_NO})
		                </p>
		
		                <p class="meta">
		                    📅 ${p.APPROVED_AT}
		                </p>
		            </div>
		
		            <div class="price-area">
		                <strong class="price">
		                    <fmt:formatNumber value="${p.TOTAL_AMOUNT}" pattern="#,###"/> 원
		                </strong>
		
		                <button type="button" class="btn-view" onclick="openDetailModal(event, ${p.ITEM_NO})">내역 보기</button>
		            </div>
		        </div>
		    </c:forEach>
		</div>
    </main>
</div>
<div id="detailModal" class="modal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.5); z-index: 1000;">
    <div class="modal-content" style="background: white; width: 400px; margin: 150px auto; padding: 25px; border-radius: 12px; text-align: center; position: relative;">
        <h3 style="margin-bottom: 20px;">거래 상세 내역</h3>
        <div style="display: flex; flex-direction: column; gap: 15px;">
            <button type="button" id="btnReceipt" class="btn-blue" style="width: 100%; padding: 12px; cursor: pointer; background: #3282f6; color: white; border: none; border-radius: 6px;">📄 영수증 보기</button>
            <button type="button" id="btnDelivery" class="btn-receipt" style="width: 100%; padding: 12px; cursor: pointer; background: #f8f9fa; border: 1px solid #ddd; border-radius: 6px;">🚚 배송내역 조회</button>
            <button type="button" onclick="closeDetailModal()" class="btn-gray" style="width: 100%; padding: 12px; cursor: pointer; background: #eee; border: none; border-radius: 6px;">닫기</button>
        </div>
        <div id="deliveryInfoArea" style="display: none; margin-top: 20px; padding: 15px; background: #f8f9fa; border-radius: 8px; text-align: left; font-size: 0.9em; border: 1px solid #eee;">
            <p style="margin: 5px 0;"><strong>택배사:</strong> <span id="textCourier"></span></p>
            <p style="margin: 5px 0;"><strong>운송장 번호:</strong> <span id="textTracking"></span></p>
            <p style="color: #3282f6; font-size: 0.8em; margin-top: 10px;">* 실제 배송 추적은 해당 택배사 홈페이지를 이용해주세요.</p>
        </div>
    </div>
</div>
<script>
function openDetailModal(e, itemNo) {
    if (e) {
        e.stopPropagation();
        e.preventDefault();
    }

    document.getElementById("deliveryInfoArea").style.display = "none";
    document.getElementById("textCourier").innerText = "";
    document.getElementById("textTracking").innerText = "";

    fetch('${pageContext.request.contextPath}/payment/api/detail/' + itemNo)
    .then(res => res.json())
    .then(data => {
        const pay = data.payment;
        const del = data.delivery;

        if(pay && pay.receiptUrl) {
            document.getElementById("btnReceipt").onclick = function() {
                window.open(pay.receiptUrl, 'receipt', 'width=500,height=700');
            };
            document.getElementById("btnReceipt").style.display = "block";
        } else {
            document.getElementById("btnReceipt").style.display = "none";
        }

        if(del && del.trackingNo) {
            document.getElementById("btnDelivery").onclick = function() {
                document.getElementById("textCourier").innerText = del.courier;
                document.getElementById("textTracking").innerText = del.trackingNo;
                document.getElementById("deliveryInfoArea").style.display = "block";
            };
        } else {
            document.getElementById("btnDelivery").onclick = function() {
                alert("아직 판매자가 배송 정보를 등록하지 않았습니다.");
            };
        }

        document.getElementById("detailModal").style.display = "block";
    })
    .catch(err => {
        console.error(err);
        alert("내역을 불러오는 중 오류가 발생했습니다.");
    });
}

function closeDetailModal() {
    document.getElementById("detailModal").style.display = "none";
}

window.onclick = function(event) {
    const detailModal = document.getElementById("detailModal");
    if (event.target == detailModal) {
        detailModal.style.display = "none";
    }
}
</script>
</body>
</html>