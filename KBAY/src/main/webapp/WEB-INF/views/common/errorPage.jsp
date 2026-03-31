<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>잘못된 접근입니다.</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/headerFooterCss/footer.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/home.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/headerFooterCss/header.css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    
    <br>
    <div align="center">
        <img src="https://cdn0.iconfinder.com/data/icons/small-n-flat/24/678069-sign-error-64.png">
        <br><br>
        <h1 style="font-weight:bold;">${errorMsg }</h1>
    </div>
    
	<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>