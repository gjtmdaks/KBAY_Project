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
	href="${pageContext.request.contextPath}/resources/css/home.css">
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />
	
	<section class="container auction-list">
		<h3 class="section-title">경매 상품 목록</h3>
		<div class="item-grid">
			<c:forEach var="it" items="${itemList}">
			    <c:set var="item" value="${it}" scope="request"/>
			
			    <jsp:include page="itemCard.jsp">
			        <jsp:param name="type" value="endDeal"/>
			    </jsp:include>
			</c:forEach>
		</div>
	</section>
	
	<jsp:include page="/WEB-INF/views/common/paging.jsp" />
	<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>