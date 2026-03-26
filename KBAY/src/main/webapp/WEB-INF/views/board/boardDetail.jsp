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
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/headerFooterCss/footer.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/headerFooterCss/header.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/boardCss/boardDetail.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/reportCss/report.css">
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
        </div>
        
        <c:if test="${not empty loginUser and loginUser.userNo == b.userNo}">
            <div class="top-buttons">
                <button type="button" onclick="location.href='/kbay/board/updateBoard/${b.boardNo}'">게시글 편집</button>
                <button type="button" onclick="deletePost(${b.boardNo}, ${b.boardCdNo} })">게시글 삭제</button>
            </div>
        </c:if>
    </div>
	
	<!-- 이미지 미리 보기부분 -->
    
	<c:if test="${not empty bList}">
	    <div class="image-preview-block">
	        <c:forEach var="bi" items="${bList}">
	            <c:set var="ext" value="${fn:toLowerCase(bi.changeName)}" />
	
	            <c:if test="${fn:endsWith(ext, '.jpg') 
	                      || fn:endsWith(ext, '.jpeg') 
	                      || fn:endsWith(ext, '.png') 
	                      || fn:endsWith(ext, '.gif')}">
	
	                <img src="${bi.changeName}" 
						alt="${bi.originName}"
						title="${bi.originName}"
						class="image-preview"
						onerror="this.onerror=null; this.src='https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg';">
	            </c:if>
	        </c:forEach>
	    </div>
	</c:if>

	<!-- 게시글 내용 출력 부분 -->
    <div class="content-block">
        ${b.boardContent}
        
        <c:if test="${not empty loginUser and loginUser.userNo != b.userNo}">
            <div class="report-button-block">
                <button type="button" class="report-btn" onclick="openReportPopup('board', ${b.boardNo})">게시글 신고</button>
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

    <!-- 댓글 기능 등록(여기서는  )-->
    <div class="reply-section">
    	<div class="reply-input-form">
            <c:choose>
                <c:when test="${not empty loginUser}">
                    <span class="reply-writer-input-label">${loginUser.userName}</span>
                    <textarea id="replyContent" rows="2" placeholder="댓글 내용"></textarea>
                    <button type="button" onclick="insertReply(${b.boardNo})">댓글 등록</button>
                </c:when>
                <c:otherwise>
                    <span class="reply-writer-input-label">손님</span>
                    <textarea rows="2" placeholder="로그인 후 이용 가능합니다." readonly></textarea>
                </c:otherwise>
            </c:choose>
        </div>
        
		<!-- 댓글 목록 -->
        <div class="reply-list">
            <c:forEach var="reply" items="${replyList}">
                <div class="reply-item" id="reply-${reply.replyNo}">
                    
                    <span class="post-writer-badge">${reply.userName}</span>
                    <span class="reply-content" id="content-${reply.replyNo}">${reply.replyContent}</span>
                    
                    <!-- 수정 input (숨김 상태) -->
				    <div class="reply-edit-box" id="edit-${reply.replyNo}" style="display:none;">
				        <textarea id="editContent-${reply.replyNo}">${reply.replyContent}</textarea>
				        <button onclick="updateReply(${reply.replyNo})">수정완료</button>
				        <button onclick="cancelEdit(${reply.replyNo})">취소</button>
				    </div>
                    
                    <div class="reply-meta">
                        <span>
                        	<fmt:formatDate value="${reply.replyDate}" pattern="yyyy.MM.dd HH:mm" />
                        </span>
                        
                        <c:choose>
		                    <c:when test="${not empty loginUser and loginUser.userNo == reply.userNo}">
		                        <button type="button" class="btn-delete-reply reply-delete-btn" onclick="showEditBox(${reply.replyNo})">댓글 수정</button>
		                        <button type="button" class="btn-delete-reply reply-delete-btn" onclick="deleteReply(${reply.replyNo})">댓글 삭제</button>
		                    </c:when>
		                    
		                    <c:when test="${not empty loginUser and loginUser.userNo != reply.userNo}">
		                        <button type="button" class="report-btn" onclick="openReportPopup('reply', ${reply.replyNo})">신고</button>
		                    </c:when>
		                </c:choose>
                    </div>
                </div>
            </c:forEach>
        </div>
        <jsp:include page="/WEB-INF/views/report/reportPopup.jsp" />
        <div class="reply-pagination">
		    <ul class="pagination-list">
		        <c:if test="${pi.currentPage > 1}">
		            <li><a href="?rPage=${pi.currentPage - 1}">&lt;</a></li>
		        </c:if>
		
		        <c:forEach var="p" begin="${pi.startPage}" end="${pi.endPage}">
		            <li class="${p == pi.currentPage ? 'active' : ''}">
		                <a href="?rPage=${p}">${p}</a>
		            </li>
		        </c:forEach>
		
		        <c:if test="${pi.currentPage < pi.maxPage}">
		            <li><a href="?rPage=${pi.currentPage + 1}">&gt;</a></li>
		        </c:if>
		    </ul>
		</div>
    </div>
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />
<script src="${pageContext.request.contextPath}/resources/js/boardJs/boardDetail.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/reportJs/report.js"></script>
</body>
</html>