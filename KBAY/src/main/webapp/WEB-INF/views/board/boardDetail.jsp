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
	href="${pageContext.request.contextPath}/resources/css/boardCss/boardDetail.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<div class="detail-container">
    <div class="post-info-block">
        <div class="post-title-row">
            <h2 class="post-title">${b.boardTitle}</h2>
        </div>
        
        <div class="post-meta-row">
            <span>등록일: <fmt:formatDate value="${b.boardDate}" pattern="yyyy.MM.dd HH:mm" /></span>
            
            <span class="post-writer-badge">${b.boardWriter}</span>
            <div>
                <span class="attachments-tab">첨부파일</span>
                <a href="${contextPath}/board/download?boardNo=${b.boardNo}">${b.originalFileName}</a> 
            </div>
        </div>
        
        <c:if test="${not empty loginUser and loginUser.userNo == b.userNo}">
            <div class="top-buttons">
                <button type="button" onclick="location.href='updateForm.bo?bno=${b.boardNo}'">게시글 편집</button>
                <button type="button" onclick="deletePost(${b.boardNo})">게시글 삭제</button>
            </div>
        </c:if>
    </div>

    <c:if test="${not empty b.originalFileName}">
        <c:set var="fileName" value="${b.originalFileName}" />
        <%-- 아직은 내용물을 저장할 수 없기에 주석으로 처리 --%>
        <%-- <c:if test="${fn:endsWith(fileName, '.jpg') || fn:endsWith(fileName, '.jpeg') || fn:endsWith(fileName, '.png') || fn:endsWith(fileName, '.gif')}">
            <div class="image-preview-block">
                <img src="${contextPath}/resources/uploadFiles/${b.renamedFileName}" alt="첨부 이미지 미리보기" class="image-preview">
            </div>
        </c:if> --%>
    </c:if>

    <div class="content-block">
        ${b.boardContent}
        
        <c:if test="${not empty loginUser and loginUser.userNo != b.userNo}">
            <div class="report-button-block">
                <button type="button" class="btn-report">게시글 신고</button>
            </div>
        </c:if>
    </div>

    <div class="nav-buttons">
        <button type="button" onclick="location.href='list.bo'">목록으로</button>
        <div>
            <button type="button">이전 글</button>
            <button type="button">다음 글</button>
        </div>
    </div>

    <div class="comment-section">
        <div class="comment-input-form">
            <c:choose>
                <c:when test="${not empty loginUser}">
                    <span class="comment-writer-input-label">${loginUser.userName}</span> <textarea rows="2" placeholder="댓글 내용"></textarea>
                    <button type="button">댓글 등록</button>
                </c:when>
                <c:otherwise>
                    <span class="comment-writer-input-label">손님</span>
                    <textarea rows="2" placeholder="로그인 후 이용 가능합니다." readonly></textarea>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="comment-list">
            <c:forEach var="comment" items="${commentList}">
                <div class="comment-item">
                    <span class="post-writer-badge">${comment.commentWriter}</span>
                    <span class="comment-content">${comment.commentContent}</span>
                    
                    <div class="comment-meta">
                        <span>${comment.createDate}</span>
                        <c:if test="${not empty loginUser and loginUser.userNo == comment.userNo}">
                            <button type="button" class="btn-delete-comment comment-delete-btn">댓글 삭제</button>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />
<script src="${pageContext.request.contextPath}/resources/js/boardJs/boardDetail.js"></script>
</body>
</html>