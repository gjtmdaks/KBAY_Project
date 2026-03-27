<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 게시글</title>
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
			    <h2>내 게시글</h2>
			
			    <table class="mypage-table">
			        <thead>
			            <tr>
			                <th>제목</th>
			                <th>작성일</th>
			            </tr>
			        </thead>
			        <tbody>
			            <c:forEach var="b" items="${list}">
			                <tr>
			                    <td>${b.boardTitle}</td>
			                    <td>${b.boardDate}</td>
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