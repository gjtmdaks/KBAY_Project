<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/headerFooterCss/footer.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/headerFooterCss/header.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/boardCss/board.css">
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />
	<div class="community-container">
    <aside class="sidebar">
        <h3 class="sidebar-title">커뮤니티</h3>
        <ul class="sidebar-menu">
            <li><a href="${contextPath }/kbay/board/community.me/1">전체</a></li>
            <li><a href="${contextPath }/kbay/board/community.me/2">물품자랑</a></li>
            <li><a href="${contextPath }/kbay/board/community.me/3">구매요망</a></li>
        </ul>
    </aside>

    <main class="content-area">
        <div class="board-header">
            <h2>커뮤니티</h2>
            <div class="search-box">
                <select><option>카테고리</option>
                    <option value="writer" ${param.condition eq 'writer' ? 'selected' : ''}>작성자</option>
                    <option value="title" ${param.condition eq 'title' ? 'selected' : ''}>제목</option>
                    <option value="content" ${param.condition eq 'content' ? 'selected' : ''}>내용</option>
                    <option value="titleAndContent" ${param.condition eq 'titleAndContent' ? 'selected' : ''}>제목+내용</option>
                </select>
            <input type="text" class="form-control" name="keyword" value="${param.keyword }" />
            <button type="submit" class="searchBtn btn btn-secondary">검색</button>
            </div>
        </div>

        <table class="board-table">
        	<thead>
                <tr>
                    <th>번호</th>
                    <th>제목</th>
                    <th>작성자</th>
                    <th>조회</th>
                    <th>등록일</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
	            	<c:when test="${empty list}">
	                    <tr>
	                        <td colspan="5">게시글이 없습니다</td>
	                    </tr>
	                </c:when>
	            	<c:otherwise>
		            	<c:forEach var="boardPost" items="${list}" varStatus="status"> 
		            	<tr onclick="location.href='${pageContext.request.contextPath}/board/boardDetail/${boardPost.boardNo}'" style="cursor:pointer;">
					        <td>${(pi.currentPage - 1) * pi.boardLimit + status.count}</td>
					        <td>${boardPost.boardTitle}</td>
					        <td>${boardPost.boardWriter}</td>
					        <td>${boardPost.viewCount}</td>
					        
					        <fmt:parseDate value="${boardPost.boardDate}" var="parsedDate" pattern="E MMM dd HH:mm:ss z yyyy" parseLocale="en_US" />
					        <td><fmt:formatDate value="${parsedDate}" pattern="yyyy.MM.dd HH:mm" /></td>
					    </tr>
					</c:forEach>
	                </c:otherwise>
            	</c:choose>
            </tbody>
        </table>
		
		<div class="button-wrap">
            <a class="btn btn-secondary write-btn" style="display:inline-block;" 
               href="${pageContext.request.contextPath}/board/insert/${boardCode}">글쓰기</a>
        </div>
           
        <div class="pagination-container">
            <c:choose>
                <c:when test="${pi.currentPage == 1}">
                    <a href="#" class="disabled">&lt;</a>
                </c:when>
                <c:otherwise>
                    <a href="?cpage=${pi.currentPage - 1}">&lt;</a>
                </c:otherwise>
            </c:choose>

            <c:forEach var="p" begin="${pi.startPage}" end="${pi.endPage}">
                <c:choose>
                    <c:when test="${p == pi.currentPage}">
                        <a href="#" class="active">${p}</a>
                    </c:when>
                    <c:otherwise>
                        <a href="?cpage=${p}">${p}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>

            <c:choose>
                <c:when test="${pi.currentPage == pi.maxPage}">
                    <a href="#" class="disabled">&gt;</a>
                </c:when>
                <c:otherwise>
                    <a href="?cpage=${pi.currentPage + 1}">&gt;</a>
                </c:otherwise>
            </c:choose>
        </div>
        
    </main>
	</div>
	<jsp:include page="/WEB-INF/views/common/footer.jsp" />
	<script src="${pageContext.request.contextPath}/resources/js/boardJs/board.js"></script>
</body>
</html>