<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mypageCss/mypage.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mypageCss/faq.css">
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />
	
	<section class="mypage-container">
        <aside class="mypage-sidebar">
            <jsp:include page="mypageSidebar.jsp" />
        </aside>

        <main class="mypage-main">
            <h2>나의 문의</h2>
			
			<a href="${pageContext.request.contextPath}/mypage/faq/write">문의하기</a>
			
			<table>
			    <tr>
			        <th>번호</th>
			        <th>카테고리</th>
			        <th>제목</th>
			        <th>상태</th>
			        <th>작성일</th>
			    </tr>
			
			    <c:forEach var="f" items="${list}">
			        <tr onclick="location.href='${pageContext.request.contextPath}/mypage/faq/detail?id=${f.faqId}'">
			            <td>${f.faqId}</td>
			            <td>${f.categoryName}</td>
			            <td>${f.title}</td>
						<td>
						    <span class="status ${f.status}">
						        <c:choose>
						            <c:when test="${f.status == 'WAIT'}">대기</c:when>
						            <c:otherwise>답변완료</c:otherwise>
						        </c:choose>
						    </span>
						</td>
			            <td>${f.createDate}</td>
			        </tr>
			    </c:forEach>
			</table>
        </main>
    </section>
	
	<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>