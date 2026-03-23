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
<title>K-Bay Auction</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/headerFooterCss/footer.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/home.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/headerFooterCss/header.css">
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />

	<section class="banner">
		<div class="container">
			<h2>K-Bay만의 특별한 경매 이벤트</h2>
			<p>신뢰할 수 있는 실시간 입찰 시스템</p>
		</div>
	</section>

	<section class="best-items container">
    <h3 class="section-title">BEST ITEM</h3>
    <div class="scroll-container">
        <div class="item-grid">
            <c:forEach var="item" items="${bestList}">
                <article class="item-card" 
                         onclick="location.href='${pageContext.request.contextPath}/auction/detail/${item.itemNo}'" 
                         style="cursor:pointer;">
                    <div class="item-img">
                        <c:choose>
                            <c:when test="${not empty item.mainImg}">
                                <img src="${item.mainImg}" alt="${item.itemTitle}" style="width:100%; height:100%; object-fit:cover;">
                            </c:when>
                            <c:otherwise>
                                NO IMAGE
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="item-info">
                        <h4>${item.itemTitle}</h4>
                        <p class="price">
                            현재가 <strong><fmt:formatNumber value="${item.currentPrice}" pattern="#,###"/>원</strong>
                        </p>
                        <div class="item-meta">
                            <span>조회 ${item.views}회</span>
                            <span class="timer">진행중</span>
                        </div>
                    </div>
                </article>
            </c:forEach>
            
            <c:if test="${empty bestList}">
                <p style="padding: 20px; color: #999;">인기 경매가 없습니다.</p>
            </c:if>
        </div>
    </div>
</section>

	<jsp:include page="/WEB-INF/views/common/footer.jsp" />

</body>
</html>