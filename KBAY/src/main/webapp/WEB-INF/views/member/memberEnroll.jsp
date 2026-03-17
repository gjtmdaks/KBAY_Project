<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>K-Bay 회원가입</title>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/memberCss/enroll.css">
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />

	<!-- 회원가입 단계 -->
	<div class="step-area">
		<div class="step">약관동의</div>
		▶
		<div class="step active">정보입력</div>
		▶
		<div class="step">가입완료</div>
	</div>

	<!-- 회원가입 폼 -->
	<div class="enroll-area">
		<h3>기본정보입력</h3>
		<form action="insertMember.me" method="post">
			<table class="enroll-table">
				<tr>
					<td>이름 *</td>
					<td><input type="text" name="memberName" required></td>
				</tr>
				<tr>
					<td>아이디 *</td>
					<td><input type="text" name="memberId" required></td>
				</tr>
				<tr>
					<td>비밀번호 *</td>
					<td><input type="password" name="memberPwd" required></td>
				</tr>
				<tr>
					<td>비밀번호 확인 *</td>
					<td><input type="password" name="pwdCheck" required></td>
				</tr>
				<tr>
					<td>휴대폰 *</td>
					<td><input type="text" name="phone"></td>
				</tr>
				<tr>
					<td>자택 연락처</td>
					<td><input type="text" name="homePhone"></td>
				</tr>
				<tr>
					<td>이메일 *</td>
					<td><input type="email" name="email"></td>
				</tr>
			</table>

			<div class="submit-btn">
				<button type="submit">가입완료</button>
			</div>
		</form>
	</div>

	<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>