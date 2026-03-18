<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
				<article class="item-card">
					<div class="item-img">ITEM IMAGE</div>
					<div class="item-info">
						<h4>한정판 빈티지 시계</h4>
						<p class="price">
							현재가 <strong>117,000원</strong>
						</p>
						<div class="item-meta">
							<span>입찰 5회</span><span class="timer">05:02:11</span>
						</div>
					</div>
				</article>
			</div>
		</div>
	</section>

	<jsp:include page="/WEB-INF/views/common/footer.jsp" />

	<script src="domain.js"></script>
</body>
</html>