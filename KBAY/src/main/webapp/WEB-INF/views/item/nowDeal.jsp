<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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

					<div class="item-img">
						<c:choose>
							<c:when test="${not empty item.thumbnail}">
								<img src="${item.thumbnail}" alt="상품이미지">
							</c:when>
							<c:otherwise>
								<img
									src="${pageContext.request.contextPath}/resources/images/noimage.png"
									alt="이미지없음">
							</c:otherwise>
						</c:choose>
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
							<span>판매자 ${item.userNo}</span>

							<!-- 남은시간 계산 -->
							<span class="timer"> <fmt:parseDate
									value="${item.endTime}" var="endDate"
									pattern="yyyy-MM-dd HH:mm:ss" /> <c:set var="remain"
									value="${(endDate.time - now.time) / 1000}" /> <c:if
									test="${remain > 0}">
									<c:set var="days"
										value="${(remain - (remain % 86400)) / 86400}" />
									<c:set var="hours"
										value="${((remain % 86400) - (remain % 86400 % 3600)) / 3600}" />
									<c:set var="mins"
										value="${((remain % 3600) - (remain % 3600 % 60)) / 60}" />
									<c:set var="secs" value="${remain % 60}" />

									<c:if test="${days > 0}">
										<fmt:formatNumber value="${days}" pattern="0" />일 
       	 	 	 	 	 	 	    </c:if>

								    <fmt:formatNumber value="${hours}" pattern="0" />시간 
       	 	 	 	 	 	  	    <fmt:formatNumber value="${mins}" pattern="0" />분 
        	 	 	 	 	  	    <fmt:formatNumber value="${secs}" pattern="0" />초
  	 	 	 	 	 	 		    </c:if> <c:if test="${remain <= 0}">
									<strong style="color: red;">종료</strong>
								</c:if>
							</span>
						</div>
					</div>

				</article>
			</c:forEach>
		</div>
	</section>

	<script>
		document.addEventListener('DOMContentLoaded', function() {
			// Controller에서 "alertMsg"라는 이름으로 보냈으므로 똑같이 맞춰줍니다.
			const msg = "${alertMsg}";

			if (msg) {
				alert(msg);
			}
		});
	</script>

	<jsp:include page="/WEB-INF/views/common/paging.jsp" />
	<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>