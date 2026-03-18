<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>K-Bay Login</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/memberCss/login.css">
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />

	<div class="login-wrapper">
		<div class="login-box">
			<h2>로그인</h2>
			<form action="${pageContext.request.contextPath}/member/login" method="post">
				<div class="input-group">
					<label>아이디</label>
					<input type="text" name="userId" required>
				</div>
				<div class="input-group">
					<label>비밀번호</label>
					<input type="password" name="userPwd" required>
				</div>
				<div class="login-btn">
					<button type="submit">로그인</button>
				</div>
			</form>
			
			<div class="login-links">
				<a href="agreeForm.me">회원가입</a>
			</div>
		</div>
	</div>

	<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>