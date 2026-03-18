<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>K-Bay 회원가입</title>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/memberCss/insert.css">
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
		<form id="enrollForm" action="insertMember.me" method="post">
			<table class="enroll-table">
				<tr>
					<td>이름 *</td>
					<td><input type="text" name="userName" required></td>
				</tr>
				<tr>
					<td>아이디 *</td>
					<td>
						<input type="text" id="userId" name="userId" required><br>
						<button type="button" id="idCheckBtn">아이디 중복확인</button>
						<span id="idMsg"></span>
					</td>
				</tr>
				<tr>
					<td>비밀번호 *</td>
					<td>
						<input type="password" id="userPwd" name="userPwd" required><br>
						<span id="pwdMsg"></span>
					</td>
				</tr>
				<tr>
					<td>비밀번호 확인 *</td>
					<td>
						<input type="password" id="pwdCheck" name="pwdCheck" required><br>
						<span id="pwdCheckMsg"></span>
					</td>
				</tr>
				<tr>
					<td>휴대폰</td>
					<td><input type="text" name="userPhone"></td>
				</tr>
				<tr>
					<td>자택 연락처</td>
					<td><input type="text" name="homePhone"></td>
				</tr>
				<tr>
					<td>주소</td>
					<td><input type="text" name="userAddress"></td>
				</tr>
				<tr>
					<td>이메일</td>
					<td><input type="email" name="userEmail"></td>
				</tr>
			</table>

			<div class="submit-btn">
				<button type="submit">가입완료</button>
			</div>
		</form>
	</div>

	<jsp:include page="/WEB-INF/views/common/footer.jsp" />
	<script>
		const form = document.getElementById("enrollForm");
		
		const userId = document.getElementById("userId");
		const idCheckBtn = document.getElementById("idCheckBtn");
		const idMsg = document.getElementById("idMsg");
		
		const userPwd = document.getElementById("userPwd");
		const pwdCheck = document.getElementById("pwdCheck");
		
		const pwdMsg = document.getElementById("pwdMsg");
		const pwdCheckMsg = document.getElementById("pwdCheckMsg");
		
		// 검증 상태 변수
		let idChecked = false;
		let pwdValid = false;
		let pwdMatch = false;
		
		// 1️. 아이디 중복확인
		idCheckBtn.addEventListener("click", function(){
		    const id = userId.value.trim();
		
		    if(id === ""){
		        idMsg.style.color = "red";
		        idMsg.innerText = "아이디를 입력하세요.";
		        return;
		    }
		
		    fetch("${pageContext.request.contextPath}/member/idCheck.me?userId=" + id)
		    .then(res => res.text())
		    .then(result => {
		        if(result === "NNNNN"){
		            idMsg.style.color = "red";
		            idMsg.innerText = "이미 사용중인 아이디입니다.";
		            idChecked = false;
		        }else{
		            idMsg.style.color = "green";
		            idMsg.innerText = "사용 가능한 아이디입니다.";
		            idChecked = true;
		        }
		    });
		});
		
		// 아이디 수정 시 다시 검사 필요
		userId.addEventListener("input", function(){
		    idChecked = false;
		    idMsg.innerText = "";
		});
		
		// 2️. 비밀번호 조건 검사
		userPwd.addEventListener("blur", function(){
		    const pwd = userPwd.value;
		
		    if(pwd.length < 4){
		        pwdMsg.style.color = "red";
		        pwdMsg.innerText = "비밀번호는 최소 4자 이상이어야 합니다.";
		        pwdValid = false;
		    }else{
		        pwdMsg.innerText = "";
		        pwdValid = true;
		    }
		});
		
		// 3️. 비밀번호 확인 검사
		pwdCheck.addEventListener("blur", function(){
		    if(userPwd.value !== pwdCheck.value){
		        pwdCheckMsg.style.color = "red";
		        pwdCheckMsg.innerText = "비밀번호가 일치하지 않습니다.";
		        pwdMatch = false;
		    }else{
		        pwdCheckMsg.style.color = "green";
		        pwdCheckMsg.innerText = "비밀번호가 일치합니다.";
		        pwdMatch = true;
		    }
		});
		
		// 4️. Form submit 검사
		form.addEventListener("submit", function(e){
		
		    if(!idChecked){
		        alert("아이디 중복확인을 해주세요.");
		        e.preventDefault();
		        return;
		    }
		
		    if(!pwdValid){
		        alert("비밀번호 조건을 확인하세요.");
		        e.preventDefault();
		        return;
		    }
		
		    if(!pwdMatch){
		        alert("비밀번호가 일치하지 않습니다.");
		        e.preventDefault();
		        return;
		    }
		});
	</script>
</body>
</html>