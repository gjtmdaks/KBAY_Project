<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mypageCss/mypage.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mypageCss/faq.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/boardCss/boardWriting.css">
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />
	
	<section class="mypage-container">
        <aside class="mypage-sidebar">
            <jsp:include page="mypageSidebar.jsp" />
        </aside>

        <main class="mypage-main">
			<div class="write-container">
			    <h2>문의 작성</h2>
			
			    <form action="${pageContext.request.contextPath}/mypage/faq/insert"
			          method="post" enctype="multipart/form-data">
			
			        <!-- 제목 -->
			        <div class="form-group">
			            <label>제목</label>
			            <input type="text" name="title" required>
			        </div>
			
			        <!-- 카테고리 -->
			        <div class="form-group">
			            <label>분류</label>
			            <select name="categoryId">
			                <c:forEach var="c" items="${categoryList}">
			                    <option value="${c.categoryId}">
			                        ${c.categoryName}
			                    </option>
			                </c:forEach>
			            </select>
			        </div>
			
			        <!-- 작성자 -->
			        <div class="form-group">
			            <label>작성자</label>
			            <input type="text" value="${loginUser.userName}" readonly>
			        </div>
			
			        <!-- 파일 -->
					<div class="form-group">
            			<label>첨부파일</label>
            			<div id="dropZone" class="drop-zone">
			    			<span class="drop-zone-text">여기로 파일을 드래그하거나 클릭하여 업로드하세요.</span>
			    			<input type="file" id="fileInput" name="upfile" multiple style="display: none;">
						</div>
			            <ul id="fileList" class="file-list"></ul>
			        </div>
			
			        <!-- 내용 -->
			        <div class="form-group">
			            <label>내용</label>
			            <textarea name="content" rows="10"></textarea>
			        </div>
			
			        <button type="submit">문의 등록</button>
			    </form>
			</div>
        </main>
    </section>
	
	<jsp:include page="/WEB-INF/views/common/footer.jsp" />
	<script src="${pageContext.request.contextPath}/resources/js/boardJs/boardWriting.js"></script>
</body>
</html>