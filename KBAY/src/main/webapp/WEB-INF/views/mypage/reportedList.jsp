<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
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
				    <c:choose>
					    <c:when test="${r.targetType eq 'item'}">
					        <c:set var="moveUrl" value="/auction/detail/${r.targetNo}" />
					    </c:when>
					
					    <c:when test="${r.targetType eq 'board'}">
					        <c:set var="moveUrl" value="/board/boardDetail/${r.targetNo}" />
					    </c:when>
					
					    <c:otherwise>
					        <c:set var="moveUrl" value="/board/boardDetail/${r.boardNo}" />
					    </c:otherwise>
					</c:choose>
				
					<a href="${pageContext.request.contextPath}${moveUrl}" class="report-card-link">							    
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
							    <div class="target">
							        <c:choose>
							
							            <c:when test="${r.targetType eq 'item'}">
							                    ${r.targetTitle}
							            </c:when>
							
							            <c:when test="${r.targetType eq 'board'}">
							                    ${r.targetTitle}
							            </c:when>
							
							            <c:when test="${r.targetType eq 'reply'}">
							                    ${r.replyContent}
							            </c:when>
							        </c:choose>
							    </div>
							    <div>신고사유: ${r.categoryName}</div>
							</div>
				
				            <div class="report-footer">
				                <fmt:formatDate value="${r.createdAt}" pattern="MM-dd HH:mm"/>
				            </div>
				
				        </div>
			        </a>
			    </c:forEach>
			</div>
        </main>
    </section>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>