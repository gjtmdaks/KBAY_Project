<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

	<jsp:useBean id="now" class="java.util.Date" />
<c:set var="now" value="${now}" scope="request"/>


<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>K-Bay Auction</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/home.css">
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />

	<section class="banner">
		<div class="container">
			<h2>K-Bay만의 특별한 경매 이벤트</h2>
			<p>신뢰할 수 있는 실시간 입찰 시스템</p>
		</div>
	</section>

	<section class="best-items container">
    <h3 class="section-title">BEST ITEM</h3>
    <div class="scroll-container">
        <div class="item-grid">
            <c:forEach var="item" items="${bestList}">
                <article class="item-card" 
                         onclick="location.href='${pageContext.request.contextPath}/auction/detail/${item.itemNo}'" 
                         style="cursor:pointer;">
                    <div class="item-img">
                        <img src="${item.mainImg}" alt="${item.itemTitle}" style="width:100%; height:100%; object-fit:cover;"
							onerror="this.onerror=null; this.src='https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg';">
                    </div>
                    
                    <div class="item-info">
                        <h4>${item.itemTitle}</h4>
                        <p class="price">
                            현재가 <strong><fmt:formatNumber value="${item.currentPrice}" pattern="#,###"/>원</strong>
                        </p>
                        <div class="item-meta">
   						 <span>입찰 ${item.bidCount}회</span>
  						 <span class="main-timer" 
								data-end="${item.endTime.time}" 
								style="color: #2C3E50; font-weight: bold;">
      							    계산 중...
   						 </span>
						</div>
                    </div>
                </article>
            </c:forEach>
            
            <c:if test="${empty bestList}">
                <p style="padding: 20px; color: #999;">인기 경매가 없습니다.</p>
            </c:if>
        </div>
    </div>
</section>

	<script>
function updateMainTimers() {
    const timers = document.querySelectorAll('.main-timer');
    const now = new Date().getTime();

    timers.forEach(el => {
        const endTime = parseInt(el.dataset.end);
        const diff = endTime - now;

        if (diff <= 0) {
            el.innerText = "경매 종료";
            el.style.color = "#E74C3C"; // 종료 시 빨간색 표시
        } else {
            // 일, 시간, 분, 초 단위 계산
            const days = Math.floor(diff / (1000 * 60 * 60 * 24));
            const hours = Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            const mins = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
            const secs = Math.floor((diff % (1000 * 60)) / 1000);

            // 문자열 포맷팅
            let timerStr = "";
            if (days > 0) timerStr += days + "일 ";
            timerStr += hours + "시간 " + mins + "분 " + secs + "초";
            
            el.innerText = timerStr;
        }
    });
}

// 1초마다 타이머 갱신 실행
setInterval(updateMainTimers, 1000);

// 페이지 로드 즉시 한 번 실행 (1초 대기 방지)
updateMainTimers();
</script>

	<jsp:include page="/WEB-INF/views/common/footer.jsp" />

</body>
</html>