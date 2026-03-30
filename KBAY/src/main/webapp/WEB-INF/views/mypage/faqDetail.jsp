<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mypageCss/mypage.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mypageCss/faq.css">
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />
	
	<section class="mypage-container">
        <aside class="mypage-sidebar">
            <jsp:include page="mypageSidebar.jsp" />
        </aside>

		<main class="mypage-main">
		    <h2>문의 상세</h2>
		
		    <!-- 문의 카드 -->
		    <div class="faq-card">
		
		        <!-- 상단 -->
		        <div class="faq-header">
		            <span class="category">${faq.categoryName}</span>
		
		            <span class="status ${faq.status}">
		                <c:choose>
		                    <c:when test="${faq.status == 'WAIT'}">답변대기</c:when>
		                    <c:otherwise>답변완료</c:otherwise>
		                </c:choose>
		            </span>
		        </div>
		
		        <!-- 제목 -->
		        <h3 class="faq-title">${faq.title}</h3>
		
		        <!-- 작성 정보 -->
		        <div class="faq-info">
		            <span>${faq.userName}</span>
		            <span>
		            	<fmt:formatDate value="${faq.createDate}" pattern="MM-dd HH:mm"/>
		            </span>
		        </div>
		
		        <!-- 내용 -->
		        <div class="faq-content">
		            ${faq.content}
		        </div>
		
		        <!-- 첨부파일 -->
				<c:if test="${not empty fileList}">
				    <div class="faq-file-preview">
				
				        <c:forEach var="f" items="${fileList}">
				            <c:set var="ext" value="${fn:toLowerCase(f.filePath)}" />
				
				            <!-- 이미지 -->
				            <c:if test="${fn:endsWith(ext, '.jpg') 
				                      || fn:endsWith(ext, '.png') 
				                      || fn:endsWith(ext, '.gif')}">
				
				                <img src="${f.filePath}" class="preview-image">
				            </c:if>
				
				            <!-- PDF -->
				            <c:if test="${fn:endsWith(ext, '.pdf')}">
				                <iframe src="${f.filePath}" class="preview-pdf"></iframe>
				            </c:if>
				
				            <!-- 다운로드 -->
				            <div class="download-box">
				                <a href="${f.filePath}" download>
				                    ${f.originName}
				                </a>
				            </div>
				
				        </c:forEach>
				
				    </div>
				</c:if>
		
		    </div>
		
		    <!-- 답변 영역 -->
		    <div class="faq-answer">
		
		        <h3>답변</h3>
		
		        <c:choose>
		            <c:when test="${empty faq.answerContent}">
		                <div class="no-answer">
		                    아직 답변이 등록되지 않았습니다.
		                </div>
		            </c:when>
		
		            <c:otherwise>
		                <div class="answer-box">
		                    ${faq.answerContent}
		                </div>
		            </c:otherwise>
		        </c:choose>
		
		    </div>
			<button onclick="history.back()">목록으로</button>
		</main>
    </section>
	
	<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>