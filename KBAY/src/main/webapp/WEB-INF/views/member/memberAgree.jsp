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

/* 단계 */
.step-area {
	text-align: center;
	margin: 40px;
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

/* 약관 */
.agree-area {
	width: 800px;
	margin: auto;
}
.agree-box {
	background: #eee;
	padding: 12px;
	margin: 10px 0;
}
.btn-area {
	text-align: center;
	margin: 30px;
}
button {
	background: #222;
	color: white;
	padding: 10px 30px;
	border: none;
}
</style>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/home.css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

	<!-- 회원가입 단계 -->
	<div class="step-area">
		<div class="step active">약관동의</div>
		▶
		<div class="step">정보입력</div>
		▶
		<div class="step">가입완료</div>
	</div>

	<!-- 약관 -->
	<div class="agree-area">
		<h3>약관동의</h3>
		<form action="enrollForm.me" method="get">
			<div class="agree-box">
				<input type="checkbox" id="allCheck"> 모든 약관을 확인하고 전체 동의합니다.
			</div>

			<div class="agree-box">
				<input type="checkbox" class="agree"> [필수] 온라인경매 이용약관 동의
			</div>

			<div class="agree-box">
				<input type="checkbox" class="agree"> [필수] 개인정보 수집 및 이용 동의
			</div>

			<div class="agree-box">
				<input type="checkbox" class="agree"> [필수] 만 14세 이상입니다.
			</div>

			<div class="agree-box">
				<input type="checkbox"> [선택] 홍보 및 마케팅 목적의 정보 수신 동의
			</div>

			<div class="btn-area">
				<button type="submit">휴대전화 인증</button>
			</div>
		</form>
	</div>

	<jsp:include page="/WEB-INF/views/common/footer.jsp" />

	<script>
		/* 전체 동의 */

		document.getElementById("allCheck").onclick = function() {

			let agrees = document.querySelectorAll(".agree");

			for (let i = 0; i < agrees.length; i++) {
				agrees[i].checked = this.checked;
			}

		}
	</script>
</body>
</html>