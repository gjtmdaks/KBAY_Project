<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
        <form action="${pageContext.request.contextPath}/member/loginProcess" method="POST">
            
            <div class="input-group">
                <label for="userId">아이디</label>
                <input type="text" id="userId" name="userId" placeholder="아이디를 입력하세요">
            </div>

            <div class="input-group">
                <label for="userPwd">비밀번호</label>
                <input type="password" id="userPwd" name="userPwd" placeholder="비밀번호를 입력하세요">
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
	<c:if test="${not empty loginErrorMsg}">
		<script>
			// window.onload 대신 충돌 없는 이벤트 리스너 사용!
			document.addEventListener('DOMContentLoaded', function() {
				let errorMsg = "${loginErrorMsg}";
				
				if(errorMsg === "Bad credentials") {
					alert("아이디 또는 비밀번호가 일치하지 않습니다.");
				} else {
					// "이 계정은 임시 정지된 계정입니다." 출력
					alert(errorMsg); 
				}
			});
		</script>
	</c:if>
</body>
</html>