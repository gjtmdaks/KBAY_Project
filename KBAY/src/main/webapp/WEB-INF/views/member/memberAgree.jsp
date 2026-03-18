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
	href="${pageContext.request.contextPath}/resources/css/memberCss/agree.css">
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
		<form id="agreeForm" action="${pageContext.request.contextPath}/member/enrollForm.me" method="get">
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
				<input type="checkbox" class="select" name="marketingAgree" value="Y"> [선택] 홍보 및 마케팅 목적의 정보 수신 동의
			</div>

			<div class="btn-area">
				<button type="submit">휴대전화 인증</button>
			</div>
		</form>
	</div>

	<jsp:include page="/WEB-INF/views/common/footer.jsp" />
	<script>
		const allCheck = document.getElementById("allCheck");
		const required = document.querySelectorAll(".agree");
		const optional = document.querySelectorAll(".select");
		const allBoxes = document.querySelectorAll(".agree, .select");
		const form = document.getElementById("agreeForm");
		
		// 1️. 전체동의 클릭
		allCheck.addEventListener("click", function(){
		    allBoxes.forEach(function(box){
		        box.checked = allCheck.checked;
		    });
		});
		
		// 2️. 개별 체크박스 클릭 시 전체동의 상태 변경
		allBoxes.forEach(function(box){
		    box.addEventListener("click", function(){
		        let checkedCount = 0;
		
		        allBoxes.forEach(function(item){
		            if(item.checked){
		                checkedCount++;
		            }
		        });
		
		        if(checkedCount === allBoxes.length){
		            allCheck.checked = true;
		        }else{
		            allCheck.checked = false;
		        }
		    });
		});
		
		// 3️. submit 시 필수만 검사
		form.addEventListener("submit", function(e){
		    for(let i = 0; i < required.length; i++){
		        if(!required[i].checked){
		            alert("필수 약관에 동의해주세요.");
		            e.preventDefault();   // 제출 막기
		            return;
		        }
		    }
		});
	</script>
</body>
</html>