<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>입찰 현황</title>
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
			    <h2>입찰 현황</h2>
			
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
				            <th>입찰순위</th>
				        </tr>
				    </thead>
				
				    <tbody>
				        <c:forEach var="b" items="${list}">
        					<tr class="clickable-row" data-href="${pageContext.request.contextPath}/auction/detail/${b.itemNo}">
				
				                <!-- 상태 -->
				                <td>${b.statusText}</td>
				
				                <!-- 이미지 -->
				                <td>
				                    <img src="${b.imgUrl}" class="thumb"
										onerror="this.onerror=null; this.src='https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg';">
				                </td>
				
				                <!-- 상품 -->
				                <td>
				                    ${b.itemNo}<br>
				                    ${b.itemTitle}
				                </td>
				
				                <!-- 현재가 -->
				                <td>${b.currentPrice}</td>
				
				                <!-- 입찰수 -->
				                <td>${b.bidCount}</td>
				
				                <!-- 조회수 -->
				                <td>${b.views}</td>
				
				                <!-- 마감일 -->
				                <td>
				                    <fmt:formatDate value="${b.endTime}" pattern="MM-dd HH:mm"/>
				                </td>
				
				                <!-- 판매자 -->
				                <td>${b.sellerId}</td>
				
				                <!-- 순위 -->
				                <td>${b.rankingText}</td>
				
				            </tr>
				        </c:forEach>
				    </tbody>
				</table>
			</div>
        </main>
    </section>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    <script>
	document.addEventListener("DOMContentLoaded", function(){
	
	    const rows = document.querySelectorAll(".clickable-row");
	
	    rows.forEach(row => {
	        row.addEventListener("click", function(){
	            const url = this.dataset.href;
	            window.location.href = url;
	        });
	    });
	
	});
	</script>
</body>
</html>