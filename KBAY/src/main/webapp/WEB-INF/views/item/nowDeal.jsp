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
	href="${pageContext.request.contextPath}/resources/css/home.css">
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />
	
	<section class="container auction-list">
		<h3 class="section-title">현재 진행중인 경매</h3>
		<form method="get" action="">
		    <div style="display:flex; gap:20px; margin-bottom:20px;">
		
		        <!-- 카테고리 -->
		        <select name="category">
		            <option value="">전체 카테고리</option>
		            <option value="1" ${category == 1 ? 'selected' : ''}>디지털/가전</option>
		            <option value="2" ${category == 2 ? 'selected' : ''}>예술</option>
		            <option value="3" ${category == 3 ? 'selected' : ''}>도서/문헌</option>
		            <option value="4" ${category == 4 ? 'selected' : ''}>근현대 생활사</option>
		            <option value="5" ${category == 5 ? 'selected' : ''}>컬렉터블</option>
		            <option value="6" ${category == 6 ? 'selected' : ''}>세컨핸드(중고)</option>
		            <option value="7" ${category == 7 ? 'selected' : ''}>키덜트</option>
		        </select>
		
		        <!-- 정렬 -->
		        <select name="sort">
		            <option value="">기본 정렬</option>
		            <option value="endAsc" ${sort == 'endAsc' ? 'selected' : ''}>종료 임박순</option>
		            <option value="endDesc" ${sort == 'endDesc' ? 'selected' : ''}>종료 여유순</option>
		            <option value="views" ${sort == 'views' ? 'selected' : ''}>조회수순</option>
		        </select>
		
		        <button type="submit">적용</button>
		    </div>
		</form>
		
		<div class="item-grid">
			<c:forEach var="it" items="${itemList}">
			    <c:set var="item" value="${it}" scope="request"/>
			
			    <jsp:include page="itemCard.jsp">
			        <jsp:param name="type" value="nowDeal"/>
			    </jsp:include>
			</c:forEach>
		</div>
	</section>
	
	<jsp:include page="/WEB-INF/views/common/paging.jsp" />
	<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>