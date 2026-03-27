<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>찜 목록</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mypageCss/mypage.css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <section class="mypage-container">
        <aside class="mypage-sidebar">
            <jsp:include page="mypageSidebar.jsp" />
        </aside>

        <main class="mypage-main">
            <div class="mypage-content">
			    <h2>찜 목록</h2>
			
			    <table class="mypage-table">
			        <thead>
			            <tr>
			                <th>상품명</th>
			                <th>현재가</th>
			            </tr>
			        </thead>
			        <tbody>
			            <c:forEach var="w" items="${list}">
			                <tr>
			                    <td>${w.itemTitle}</td>
			                    <td>${w.currentPrice}</td>
			                </tr>
			            </c:forEach>
			        </tbody>
			    </table>
			</div>
        </main>
    </section>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>