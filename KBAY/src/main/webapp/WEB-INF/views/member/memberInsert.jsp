<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>K-Bay 회원가입</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/headerFooterCss/footer.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/memberCss/insert.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/memberCss/complete.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/headerFooterCss/header.css">
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />

	<!-- 회원가입 단계 -->
	<div class="step-area">
		<div class="step">약관동의</div>
		▶
		<div class="step">정보입력</div>
		▶
		<div class="step active">가입완료</div>
	</div>

	<!-- 완료 -->
	<div class="complete-area">
		<div class="complete-box">
			<div class="complete-icon">
				✔
			</div>
			<h2>회원가입이 완료되었습니다.</h2>
			<p>
				K-Bay 회원이 되신 것을 환영합니다.<br>
				로그인 후 다양한 서비스를 이용하실 수 있습니다.
			</p>
	
			<form action="${contextPath}/member/login" method="get">
				<div class="submit-btn">
					<button type="submit">로그인 하러가기</button>
				</div>
			</form>
		</div>
	</div>

	<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>