<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>찜 목록</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mypageCss/mypage.css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <section class="mypage-container">
        <aside class="mypage-sidebar">
            <jsp:include page="mypageSidebar.jsp" />
        </aside>

        <main class="mypage-main">
            <div class="mypage-content">
			    <h2>찜 목록</h2>
			
			    <table class="mypage-table">
				    <thead>
				        <tr>
				            <th>구분</th>
				            <th>이미지</th>
				            <th>물품번호/물품명</th>
				            <th>현재가</th>
				            <th>입찰</th>
				            <th>조회</th>
				            <th>마감일</th>
				            <th>판매자</th>
				        </tr>
				    </thead>
				
					<tbody>
					    <c:forEach var="w" items="${list}">
					        <tr class="clickable-row" data-href="${pageContext.request.contextPath}/auction/detail/${w.itemNo}">
					            <td>${w.statusText}</td>
					
					            <td>
					                <img src="${w.imgUrl}" class="thumb"
					                     onerror="this.onerror=null; this.src='https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg';">
					            </td>
					
					            <td>
					                ${w.itemNo}
					                <br>
					                ${w.itemTitle}
					            </td>
					
					            <td>${w.currentPrice}</td>
					            <td>${w.bidCount}</td>
					            <td>${w.views}</td>
					
					            <td>
					                <fmt:formatDate value="${w.endTime}" pattern="MM-dd HH:mm"/>
					            </td>
					
					            <td>${w.sellerId}</td>
					        </tr>
					    </c:forEach>
					</tbody>
				</table>
			</div>
        </main>
    </section>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    <script>
	    const rows = document.querySelectorAll(".clickable-row");
	
	    rows.forEach(row => {
	        row.addEventListener("click", function(){
	            window.location.href = this.dataset.href;
	        });
	    });
    </script>
</body>
</html>