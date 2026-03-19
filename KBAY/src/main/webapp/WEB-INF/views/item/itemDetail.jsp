<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:useBean id="now" class="java.util.Date" />
<c:set var="now" value="${now}" scope="request"/>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>K-Bay 경매 목록</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/headerFooterCss/header.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/home.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/itemCss/itemDetail.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/headerFooterCss/paging.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/headerFooterCss/footer.css">
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />
	
	<div class="detail-container">
	
	    <!-- 이미지 영역 -->
	    <div class="image-section">
	
	        <!-- 대표 이미지 -->
	        <div class="main-image">
	            <img id="mainImg"
	                 src="https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg">
	        </div>
	
	        <!-- 썸네일 리스트 -->
	        <div class="thumbnail-list">
	            <c:forEach var="img" items="${item.imgList}">
	                <img src="https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg" class="thumb"
	                     onclick="changeImage(this)">
	            </c:forEach>
	        </div>
	    </div>
	
	    <!-- 상품 정보 -->
	    <div class="info-section">
	        <h2>${item.itemTitle}</h2>
	
	        <div class="meta">
	            <span>카테고리: ${itemCategory.itemCategory}</span>
	            <span>판매자: ${item.userNo}</span>
	        </div>
	
	        <!-- 가격 -->
	        <div class="price-box">
	            <c:choose>
	                <c:when test="${now.time < item.startTime.time}">
	                    <div>시작가 <strong>${item.startPrice}</strong></div>
	                </c:when>
	
	                <c:when test="${now.time > item.endTime.time}">
	                    <div>낙찰가 <strong>${item.currentPrice}</strong></div>
	                </c:when>
	
	                <c:otherwise>
	                    <div>현재가 <strong>${item.currentPrice}</strong></div>
	                </c:otherwise>
	            </c:choose>
	
	            <c:if test="${item.directBuy eq 'Y'}">
	                <div class="buy-now">즉시구매가 ${item.buyNowPrice}</div>
	            </c:if>
	        </div>
	
	        <!-- 타이머 -->
	        <div class="timer">
	            <span id="timer"
	                  data-end="${item.endTime.time}"
	                  data-start="${item.startTime.time}">
	            </span>
	        </div>
	
	        <!-- 입찰 -->
	        <c:if test="${now.time >= item.startTime.time && now.time <= item.endTime.time}">
	            <div class="bid-box">
	                <input type="number" id="bidPrice" placeholder="입찰 금액">
	                <button onclick="submitBid(${item.itemNo})">입찰하기</button>
	            </div>
	        </c:if>
	    </div>
	</div>
	
	<!-- 상세 설명 -->
	<div class="description">
	    <h3>상품 설명</h3>
	    <p>${item.itemContent}</p>
	</div>
	
	<jsp:include page="/WEB-INF/views/common/footer.jsp" />
	
	<script>
	// 이미지 변경
	function changeImage(el){
	    document.getElementById("mainImg").src = el.src;
	}
	
	// 타이머
	function updateTimer(){
	    const el = document.getElementById("timer");
	    const now = new Date().getTime();
	    const end = parseInt(el.dataset.end);
	    const start = parseInt(el.dataset.start);
	
	    let diff;
	
	    if(now < start){
	        diff = (start - now) / 1000;
	        el.innerText = "시작까지 " + formatTime(diff);
	    }else if(now > end){
	        el.innerText = "종료";
	    }else{
	        diff = (end - now) / 1000;
	        el.innerText = "종료까지 " + formatTime(diff);
	    }
	}
	
	function formatTime(sec){
	    sec = Math.floor(sec);
	    const d = Math.floor(sec / 86400);
	    const h = Math.floor((sec % 86400)/3600);
	    const m = Math.floor((sec % 3600)/60);
	
	    if(d > 0) return d+"일 "+h+"시간 "+m+"분";
	    if(h > 0) return h+"시간 "+m+"분";
	    return m+"분";
	}
	
	setInterval(updateTimer,1000);
	updateTimer();
	
	
	// 입찰
	function submitBid(itemNo){
	    const price = document.getElementById("bidPrice").value;
	
	    if(!price){
	        alert("금액 입력");
	        return;
	    }
	
	    location.href = "${pageContext.request.contextPath}/auction/bid?itemNo=" + itemNo + "&price=" + price;
	}
	</script>
</body>
</html>