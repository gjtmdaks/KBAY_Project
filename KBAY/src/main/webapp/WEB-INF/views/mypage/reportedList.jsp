<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사고 내역</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mypageCss/mypage.css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <section class="mypage-container">
        <aside class="mypage-sidebar">
            <jsp:include page="mypageSidebar.jsp" />
        </aside>

        <main class="mypage-main">
            <div class="report-list">
                <h2>사고 내역</h2>
			
			    <c:forEach var="r" items="${list}">
			        <div class="report-card">
			
			            <div class="report-header">
			                <span class="type">
			                	<c:choose>
								    <c:when test="${r.targetType eq 'item'}">상품</c:when>
								    <c:when test="${r.targetType eq 'board'}">게시글</c:when>
								    <c:when test="${r.targetType eq 'reply'}">댓글</c:when>
								</c:choose>
			                </span>
			
			                <c:choose>
			                    <c:when test="${r.status eq 'Y'}">
			                        <span class="status done">처리완료</span>
			                    </c:when>
			                    <c:otherwise>
			                        <span class="status pending">처리중</span>
			                    </c:otherwise>
			                </c:choose>
			            </div>
			
			            <div class="report-body">
			                <div>신고사유: ${r.categoryName}</div>
			                <div>대상번호: ${r.targetNo}</div>
			            </div>
			
			            <div class="report-footer">
			                <fmt:formatDate value="${r.createAt}" pattern="MM-dd HH:mm"/>
			            </div>
			
			        </div>
			    </c:forEach>
			
			</div>
        </main>
    </section>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>