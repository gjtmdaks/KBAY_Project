<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
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
	href="${pageContext.request.contextPath}/resources/css/boardCss/boardWriting.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<div class="write-container">
    <h2>커뮤니티 글작성</h2>
    
    <form id="postForm" action="${pageContext.request.contextPath}/board/insert" 
      method="post" enctype="multipart/form-data">
        <div class="form-group">
            <label for="postTitle">제목</label>
            <input type="text" id="boardTitle" name="boardTitle" placeholder="제목을 입력하세요" required>
        </div>

        <div class="form-group">
            <label for="boardCdNo">카테고리</label>
            <select id="boardCdNo" name="boardCdNo">
                <option value="2">물품자랑</option>
                <option value="3">구매요망</option>
            </select>
        </div>

        <div class="form-group">
            <label>첨부파일</label>
            <div id="dropZone" class="drop-zone">
			    <span class="drop-zone-text">여기로 파일을 드래그하거나 클릭하여 업로드하세요.</span>
			    <input type="file" id="fileInput" name="upfile" multiple style="display: none;">
			</div>
            <ul id="fileList" class="file-list"></ul>
        </div>

        <div class="form-group">
            <label for="postContent">내용</label>
            <textarea id="boardContent" name="boardContent" rows="15" placeholder="게시글 내용을 자유롭게 입력하세요" required></textarea>
        </div>

        <div class="button-group">
        	<button type="button" class="btn-list" onclick="location.href='${contextPath}/kbay/board/community.me/${boardCdNo}'">목록으로</button>
            
            <button type="submit" class="btn-submit">게시글 작성</button>
        </div>
    </form>
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />
<script src="${pageContext.request.contextPath}/resources/js/boardJs/boardWriting.js"></script>
</body>
</html>