<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>K-Bay 회원가입</title>
<style>
body {
	margin: 0;
	font-family: Arial;
}

/* 단계 표시 */
.step-area {
	text-align: center;
	margin: 40px 0;
}
.step {
	display: inline-block;
	width: 120px;
	height: 120px;
	border-radius: 60px;
	background: #ccc;
	line-height: 120px;
	margin: 0 20px;
}
.step.active {
	background: #222;
	color: white;
}

/* 회원가입 폼 */
.enroll-area {
	width: 800px;
	margin: auto;
}
.enroll-table {
	width: 100%;
	border-collapse: collapse;
}
.enroll-table td {
	border: 1px solid #ccc;
	padding: 10px;
}
.enroll-table td:first-child {
	width: 150px;
	background: #eee;
}
.enroll-table input {
	width: 95%;
	padding: 8px;
}
.submit-btn {
	text-align: center;
	margin: 30px;
}
.submit-btn button {
	background: #222;
	color: white;
	border: none;
	padding: 10px 30px;
}
</style>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/home.css">
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