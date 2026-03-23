<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
	href="${pageContext.request.contextPath}/resources/css/boardCss/boardWriting.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<div class="write-container"> <h2>게시글 수정하기</h2>
    
    <form id="postForm" action="${pageContext.request.contextPath}/board/update" method="post" enctype="multipart/form-data">
        
        <input type="hidden" name="boardNo" value="${b.boardNo}">
        <input type="hidden" name="boardCdNo" value="${b.boardCdNo}">

        <div class="form-group">
            <label for="postTitle">제목</label>
            <input type="text" id="boardTitle" name="boardTitle" value="${b.boardTitle}" required>
        </div>

        <div class="form-group">
            <label for="updateCdNo">카테고리</label>
            <select id="boardCdNo" name="updateCdNo" disabled> <option value="2" <c:if test="${b.boardCdNo == 2}">selected</c:if>>물품자랑</option>
                <option value="3" <c:if test="${b.boardCdNo == 3}">selected</c:if>>구매요망</option>
            </select>
            <span style="font-size:12px; color:gray; margin-left:10px;">* 카테고리는 수정할 수 없습니다.</span>
        </div>

        <div class="form-group">
            <label>기존 첨부파일</label>
            <c:choose>
                <c:when test="${not empty bList}">
                    <ul style="list-style:none; padding:10px; border:1px solid #ddd; border-radius:5px; background-color:#f9f9f9;">
                        <c:forEach var="bi" items="${bList}">
                            <li style="margin-bottom: 8px;">
                                📎 ${bi.changeName}
                                <!-- 내가 작성한 게시글에 이미지가 들어가 있다면 오류가 발생 나중에 확인하기 -->
                                <label style="color:red; font-size:13px; margin-left:15px; cursor:pointer;">
                                    <input type="checkbox" name="deleteImgs" value="${bi.boardImgNo}"> ❌ 이 파일 삭제하기
                                </label>
                            </li>
                        </c:forEach>
                    </ul>
                </c:when>
                <c:otherwise>
                    <div style="padding:10px; color:#888; font-size:14px;">기존에 등록된 파일이 없습니다.</div>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="form-group">
            <label>새 첨부파일 추가</label>
            <div id="dropZone" class="drop-zone">
                <span class="drop-zone-text">여기로 파일을 드래그하거나 클릭하여 추가 업로드하세요.</span>
                <input type="file" id="fileInput" name="upfile" multiple style="display: none;">
            </div>
            <ul id="fileList" class="file-list"></ul>
        </div>

        <div class="form-group">
            <label for="postContent">내용</label>
            <textarea id="boardContent" name="boardContent" rows="15" required>${b.boardContent}</textarea>
        </div>

        <div class="button-group">
            <button type="button" class="btn-list" onclick="history.back();">수정 취소</button>
            <button type="submit" class="btn-submit">게시글 수정 완료</button>
        </div>
    </form>
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />
<script src="${pageContext.request.contextPath}/resources/js/boardJs/boardWriting.js"></script>
</body>
</html>