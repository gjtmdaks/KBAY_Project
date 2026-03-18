<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:useBean id="now" class="java.util.Date" />
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
	href="${pageContext.request.contextPath}/resources/css/itemCss/auction.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/headerFooterCss/paging.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/headerFooterCss/footer.css">
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />
	
	<section class="container auction-list">
		<h3 class="section-title">경매 상품 목록</h3>
		<div class="item-grid">
			<c:forEach var="item" items="${itemList}">
				<article class="item-card">

					<!-- 이미지 (DTO에 없음 → 기본 이미지 고정) -->
					<div class="item-img">
						<img src="${pageContext.request.contextPath}/resources/images/noimage.png" alt="상품이미지">
					</div>

					<!-- 정보 -->
					<div class="item-info">
						<!-- itemTitle로 변경 -->
						<h4>${item.itemTitle}</h4>

						<p class="price">
							현재가 <strong>${item.currentPrice}원</strong>
						</p>

						<div class="item-meta">
							<!-- bidCount 없음 → 제거 or 임시 -->
							<span>판매자 ${item.sellerNo}</span>

							<!-- 남은시간 계산 -->
							<span class="timer">
								<c:set var="remain" value="${(item.endTime.time - now.time) / 1000}" />
								<c:if test="${remain > 0}">
									${remain / 3600}시간
									${(remain % 3600) / 60}분
								</c:if>
								<c:if test="${remain <= 0}">
									종료
								</c:if>
							</span>
						</div>
					</div>

				</article>
			</c:forEach>
		</div>
	</section>
	
	<jsp:include page="/WEB-INF/views/common/paging.jsp" />
	<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>