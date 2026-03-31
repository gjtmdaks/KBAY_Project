<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/adminCss/admin.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/adminCss/adminInquiry.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<div class="admin-wrap">
    <jsp:include page="/WEB-INF/views/admin/adminSidebar.jsp" />

    <main class="main-content">
        
		<h2>문의 관리</h2>
		
		<table class="inquiry-table">
		    <tr>
		        <th>번호</th>
		        <th>제목</th>
		        <th>작성자</th>
		        <th>상태</th>
		        <th>작성일</th>
		    </tr>
		
		    <c:forEach var="f" items="${list}">
		        <tr onclick="openDetail(${f.faqId})">
		            <td>${f.faqId}</td>
		            <td>${f.title}</td>
		            <td>${f.userId}</td>
		            <td>${f.status}</td>
		            <td>
			            <fmt:formatDate value="${f.createDate}" pattern="MM-dd HH:mm"/>
		            </td>
		        </tr>
		    </c:forEach>
		</table>
		
		<!-- 상세 모달 -->
		<div id="detailModal" class="modal" style="display:none">
		    <div class="modal-content">
		    	<span class="close-btn" onclick="closeModal()">&times;</span>
		        <h3 id="title"></h3>
		        <p id="content"></p>
		
		        <div id="files"></div>
		
		        <textarea id="answerBox" placeholder="답변 입력"></textarea>
		        <button onclick="submitAnswer()">답변 등록</button>
		    </div>
		</div>

    </main>
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />
<script>
let currentFaqId = 0;

function openDetail(faqId){
    currentFaqId = faqId;

    fetch(`${contextPath}/admin/inquiryDetail?faqId=` + faqId)
    .then(res => res.json())
    .then(data => {
        document.getElementById("title").innerText = data.faq.title;
        document.getElementById("content").innerText = data.faq.content;

        let fileHtml = "";
        data.fileList.forEach(f=>{
        	console.log(f);
        	fileHtml += '<img src="' + f.filePath + '" style="max-width:200px;"><br>';
        });
        document.getElementById("files").innerHTML = fileHtml;

        document.getElementById("answerBox").innerHTML = data.faq.answerContent;

        document.getElementById("detailModal").style.display = "block";
    });
}

function submitAnswer(){
    let answer = document.getElementById("answerBox").value;

    fetch("${contextPath}/admin/insertInquiryAnswer", {
        method:"POST",
        headers:{"Content-Type":"application/json"},
        body: JSON.stringify({
            faqId: currentFaqId,
            answerContent: answer
        })
    })
    .then(res=>res.text())
    .then(r=>{
        if(r==="SUCCESS"){
            alert("등록 완료");
            location.reload();
        }
    });
}

function closeModal(){
    document.getElementById("detailModal").style.display = "none";
}

window.onclick = function(e){
    const modal = document.getElementById("detailModal");
    if(e.target === modal){
        modal.style.display = "none";
    }
}
</script>
</body>
</html>