<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 댓글</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mypageCss/mypage.css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <section class="mypage-container">
        <aside class="mypage-sidebar">
            <jsp:include page="mypageSidebar.jsp" />
        </aside>

        <main class="mypage-main">
            <div class="reply-list">
                <h2>내 댓글</h2>
			
			    <c:if test="${empty list}">
			        <div class="empty-box">작성한 댓글이 없습니다.</div>
			    </c:if>
			
			    <c:forEach var="r" items="${list}">
				    <div class="reply-card"
				         onclick="location.href='${pageContext.request.contextPath}/board/boardDetail/${r.boardNo}'">
				
				        <div class="reply-title">${r.boardTitle}</div>
				        <div class="reply-content">${r.replyContent}</div>
				        <div class="reply-date">
				        	<fmt:formatDate value="${r.replyDate}" pattern="MM-dd HH:mm"/>
				        </div>
				        
				
				    </div>
				</c:forEach>
			
			</div>
        </main>
    </section>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>