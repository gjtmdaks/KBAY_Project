<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
			<c:forEach var="it" items="${itemList}">
			    <c:set var="item" value="${it}" scope="request"/>
			
			    <c:choose>
				    <c:when test="${now.time < item.startTime.time}">
				        <c:set var="type" value="yetDeal" scope="request"/>
				        <jsp:include page="itemCard.jsp"/>
				    </c:when>
				
				    <c:when test="${now.time > item.endTime.time}">
				        <c:set var="type" value="endDeal" scope="request"/>
				        <jsp:include page="itemCard.jsp"/>
				    </c:when>
				
				    <c:otherwise>
				        <c:set var="type" value="nowDeal" scope="request"/>
				        <jsp:include page="itemCard.jsp"/>
				    </c:otherwise>
				</c:choose>
			</c:forEach>
		</div>
	</section>
	
	<jsp:include page="/WEB-INF/views/common/paging.jsp" />
	<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>