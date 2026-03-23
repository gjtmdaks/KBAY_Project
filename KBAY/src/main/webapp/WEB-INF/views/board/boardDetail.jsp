<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
            
            <!-- 첨부파일 등록 버튼?부분 -->
            <div class="attachments-area" style="margin-top: 10px;">
            <span class="attachments-tab" style="font-weight: bold; margin-right: 10px;">첨부파일</span>
	            <c:choose>
	                <c:when test="${not empty bList}">
	                    <c:forEach var="bi" items="${bList}">
	                        <a href="${contextPath}/kbay/board/download?changeName=${bi.changeName}&originName=${bi.originName}" 
	                           style="margin-right: 15px; color: #555; text-decoration: none;">
	                            📎 ${bi.originName}
	                        </a>
	                    </c:forEach>
	                </c:when>
	                <c:otherwise>
	                    <span style="font-size: 13px; color: #888;">첨부파일 없음</span>
	                </c:otherwise>
	            </c:choose>
            </div>
        </div>
        
        
        <c:if test="${not empty loginUser and loginUser.userNo == b.userNo}">
            <div class="top-buttons">
                <button type="button" onclick="location.href='/kbay/board/updateBoard/${b.boardNo}'">게시글 편집</button>
                <button type="button" onclick="deletePost(${b.boardNo})">게시글 삭제</button>
            </div>
        </c:if>
    </div>
	
	<!-- 이미지 미리 보기부분 -->
    
	<c:if test="${not empty bList}">
	    <div class="image-preview-block">
	        <c:forEach var="bi" items="${bList}">
	            <c:set var="ext" value="${fn:toLowerCase(bi.changeName)}" />
	            
	            <c:if test="${fn:endsWith(ext, '.jpg') || fn:endsWith(ext, '.jpeg') || fn:endsWith(ext, '.png') || fn:endsWith(ext, '.gif')}">
	                <!-- ${bi.changeName}
	                ${pageContext.request.contextPath}/upload/board/${bi.changeName} -->
	                <img src="${bi.changeName}" 
	                     alt="첨부 이미지 미리보기" 
	                     class="image-preview">
	            </c:if>
	        </c:forEach>
	    </div>
	</c:if>
    <!-- 윗줄이 안되면 아래줄로 -->
    <%-- <div class="image-preview-block">
	<c:if test="${not empty b.boardCdNo}">
	     <c:set var="fileName" value="${b.originalFileName}" />
		<c:forEach var="bi" items="${bList}">
			<img src="${bi.changeName}" alt="첨부 이미지 미리보기" class="image-preview">
		</c:forEach>
	</c:if>
	</div> --%>
	<!-- 게시글 내용 출력 부분 -->
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
            <button type="button" onclick="">이전 글</button>
            <button type="button" onclick="">다음 글</button>
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