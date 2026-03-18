<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/boardCss/board.css">
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />
	<div class="community-container">
    <aside class="sidebar">
        <h3 class="sidebar-title">커뮤니티</h3>
        <ul class="sidebar-menu">
            <li><a href="community.me">전체</a></li>
            <li><a href="/community.me/boast">물품자랑</a></li>
            <li><a href="/community.me/request">구매요망</a></li>
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
                    <th>댓글</th>
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
		            	<c:forEach var="board" items="${list }"> 
			                <tr onclick="movePage(${board.boardNo})">
		                        <td>${board.boardNo }</td>
		                        <td>${board.boardTitle }</td>
		                        <td>${board.boardWriter}</td>
		                        <td>${board.count }</td>
		                        <td>${board.commentcount }</td>
		                        <td>${board.createDate }</td>
		                    </tr>
		                </c:forEach>
	                </c:otherwise>
            	</c:choose>
            </tbody>
        </table>
		
		<!-- 아직 바인딩 처리 안함 -->
        <a class="btn btn-secondary" style="float:right"
           href="${contextPath }/kbay/board/insert/${boardCode}">글쓰기</a>
           <!-- ${boardCode} -->
        
    </main>
	</div>
	<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>