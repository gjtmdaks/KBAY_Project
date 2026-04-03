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
		
		                <button class="btn-view"
		                        onclick="viewReceipt(event, ${p.ITEM_NO})">
		                    내역 보기
		                </button>
		            </div>
		        </div>
		    </c:forEach>
		</div>
    </main>
</div>
<script>
function viewReceipt(e, itemNo) {
    e.stopPropagation();
    
    fetch(`${pageContext.request.contextPath}/payment/receipt/` + itemNo)
        .then(response => response.json())
        .then(data => {
            document.getElementById("m-orderName").innerText = data.orderName;
            document.getElementById("m-totalAmount").innerText = data.totalAmount.toLocaleString();
            document.getElementById("m-orderId").innerText = data.orderId;
            document.getElementById("m-method").innerText = data.method;
            
            let dateStr = data.approvedAt;
            if(dateStr && dateStr.includes('T')) {
                dateStr = dateStr.substring(0,10) + " " + dateStr.substring(11,19);
            }
            document.getElementById("m-approvedAt").innerText = dateStr;
            
            document.getElementById("m-receiptUrlBtn").onclick = () => {
                window.open(data.receiptUrl, 'receipt', 'width=500,height=700');
            };
            
            document.getElementById("receiptModal").style.display = "flex";
            
            // 로딩 상태
            document.getElementById("m-orderName").innerText = "불러오는 중...";
            
            fetch(`${pageContext.request.contextPath}/payment/receipt/` + itemNo)
        })
        .catch(err => {
            console.error(err);
            alert("결제 내역을 불러오는 중 오류가 발생했습니다.");
        });
}

function closeReceiptModal() {
    document.getElementById("receiptModal").style.display = "none";
}

window.onclick = function(event) {
    const modal = document.getElementById("receiptModal");
    if (event.target == modal) {
        modal.style.display = "none";
    }
}
</script>
</body>
</html>