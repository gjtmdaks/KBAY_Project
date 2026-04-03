<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec"	uri="http://www.springframework.org/security/tags"%>

<jsp:useBean id="now" class="java.util.Date" />
<c:set var="now" value="${now}" scope="request" />

<!DOCTYPE html>
<html lang="ko">
<head>
<!-- 웹소켓 통신을 위한 JS 라이브러리 -->
<script	src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
<script	src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<meta charset="UTF-8">
<title>K-Bay 경매 목록</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/home.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/itemCss/itemDetail.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/bidCss/bid.css">
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />

	<div class="detail-container">

		<!-- 이미지 영역 -->
		<div class="image-section">
			<div class="main-image">
				<img id="mainImg" src="${item.mainImg}"
					onerror="this.onerror=null; this.src='https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg';">
			</div>
			<div class="thumbnail-wrapper">
				<button class="thumb-btn left" onclick="moveImage(-1)">❮</button>
				<div class="thumbnail-list" id="thumbList">
					<c:if test="${not empty item.mainImg}">
						<img src="${item.mainImg}" class="thumb"
							onclick="changeImage(this)"
							onerror="this.onerror=null; this.src='https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg';">
					</c:if>
					<c:forEach var="img" items="${item.subImgList}">
						<img src="${img.imgUrl}" class="thumb" onclick="changeImage(this)"
							onerror="this.onerror=null; this.src='https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg';">
					</c:forEach>
				</div>
				<button class="thumb-btn right" onclick="moveImage(1)">❯</button>
			</div>
		</div>

		<!-- 상품 정보 -->
		<div class="info-section">
			<button type="button" id="wishBtn"
				class="wish-btn ${isWish > 0 ? 'active' : ''}"
				onclick="toggleWishlist(${item.itemNo})">
				<span class="heart-icon">${isWish > 0 ? '❤️' : '🤍'}</span>
			</button>
			<h2 class="item-title">${item.itemTitle}</h2>
			<div class="meta-info">
				<span class="category-tag">${itemCategory.itemCategory}</span> <span
					class="seller-name">판매자: <strong>${item.userName}</strong></span>
			</div>

			<div class="auction-details">
				<div class="info-row">
					<span class="label">남은 시간</span> <span id="timer"
						class="value timer-text" data-end="${item.endTime.time}"
						data-start="${item.startTime.time}">-</span>
				</div>
				<div class="info-row">
					<span class="label">입찰 수</span> <span id="bidCount" class="value">${bidCount}회</span>
				</div>
				<div class="info-row">
					<span class="label">조회수</span> <span class="value">${item.views}회</span>
				</div>
				<div class="info-row">
					<span class="label">경매 번호</span> <span class="value">#${item.itemNo}</span>
				</div>
				<div class="info-row">
					<span class="label">제조국</span> <span class="value"> <c:choose>
							<c:when test="${item.countryNo == 'KOR'}">대한민국</c:when>
							<c:when test="${item.countryNo == 'USA'}">미국</c:when>
							<c:when test="${item.countryNo == 'JPN'}">일본</c:when>
							<c:when test="${item.countryNo == 'CHN'}">중국</c:when>
							<c:when test="${item.countryNo == 'FRA'}">프랑스</c:when>
							<c:when test="${item.countryNo == 'DEU'}">독일</c:when>
							<c:when test="${item.countryNo == 'RUS'}">러시아</c:when>
							<c:when test="${item.countryNo == 'BRA'}">브라질</c:when>
							<c:when test="${item.countryNo == 'IND'}">인도</c:when>
							<c:when test="${item.countryNo == 'CAN'}">캐나다</c:when>
							<c:when test="${item.countryNo == 'AUS'}">호주</c:when>
							<c:when test="${item.countryNo == 'ESP'}">스페인</c:when>
							<c:when test="${item.countryNo == 'ITA'}">이탈리아</c:when>
							<c:when test="${item.countryNo == 'ZAF'}">남아프리카공화국</c:when>
							<c:when test="${item.countryNo == 'MEX'}">멕시코</c:when>
							<c:when test="${item.countryNo == 'SWE'}">스웨덴</c:when>
							<c:when test="${item.countryNo == 'NOR'}">노르웨이</c:when>
							<c:when test="${item.countryNo == 'FIN'}"> 핀란드</c:when>
							<c:when test="${item.countryNo == 'GBR'}">영국</c:when>
							<c:when test="${item.countryNo == 'ETC'}">기타 국가</c:when>
							<c:otherwise>${item.countryNo}</c:otherwise>
						</c:choose>
					</span>
				</div>

				<c:if
					test="${not empty loginUser and loginUser.userNo != item.userNo}">
					<button type="button" class="report-btn"
						onclick="openReportPopup('item', ${item.itemNo})">🚨 신고하기
					</button>
					<jsp:include page="/WEB-INF/views/report/reportPopup.jsp" />
				</c:if>
			</div>

			<div class="price-section">
				<div class="price-header">
					<span class="price-label">현재 입찰가</span>
					<button type="button" class="btn-history"
						onclick="openBidModal(${item.itemNo})">입찰기록 ❯</button>
				</div>
				<div class="price-amount-wrapper">
					<strong id="currentPrice"><fmt:formatNumber
							value="${currentPrice}" pattern="#,###" /></strong> <span class="unit">원</span>
				</div>

				<c:if test="${item.directBuy eq 'Y'}">
					<div class="price-header">
						<span class="price-label">즉시 구매가</span>
					</div>
					<div class="price-amount-wrapper">
						<strong id="currentPrice"><fmt:formatNumber
								value="${item.buyNowPrice}" pattern="#,###" /></strong> <span
							class="unit">원</span>
					</div>
				</c:if>

				<c:if test="${now.time >= item.startTime.time 
				          && now.time <= item.endTime.time 
				          && loginUser.userNo != item.userNo}">
					<div class="bid-form">
						<div class="input-group">
							<input type="text" id="bidPrice" placeholder="금액 입력"
								oninput="formatBidPrice(this)"> <span class="input-unit">원</span>
							<div class="bid-controls">
								<button type="button" onclick="changeBidAmount(1000)">▲</button>
								<button type="button" onclick="changeBidAmount(-1000)">▼</button>
							</div>
						</div>
						<button class="btn-submit-bid" onclick="submitBid(event, ${item.itemNo})">
							입찰하기
						</button>
						<c:if test="${item.directBuy eq 'Y'}">
						    <button class="btn-buy-now" onclick="buyNow(${item.itemNo})">
						        즉시 구매
						    </button>
						</c:if>
						<p id="topBidderMsg" class="top-bid-notice"
							style="${isTopBidder ? '' : 'display: none;'}">✓ 현재 회원님이 최고가
							입찰자입니다.</p>
					</div>
				</c:if>
				<c:if test="${loginUser.userNo == item.userNo}">
				    <p class="seller-notice">본인이 등록한 상품에는 입찰할 수 없습니다.</p>
				</c:if>
			</div>
		</div>
	</div>

	<div id="bidModal" class="modal">
		<div class="modal-content">
			<div class="modal-header">
				<h3>입찰 기록</h3>
				<span class="close" onclick="closeBidModal()">&times;</span>
			</div>
			<div class="modal-body">
    <table class="bid-table">
        <thead>
            <tr>
                <th>입찰번호</th>
                <th>입찰자</th>
                <th>입찰금액</th>
                <th>입찰일시</th>
                <th>IP</th>
            </tr>
        </thead>
        <tbody id="bidHistoryBody"></tbody>
    </table>
    
    <div id="bidPagination" class="pagination" style="margin-top: 20px; justify-content: center; display: flex;"></div>
</div>
		</div>
	</div>

	<!-- 상세 설명 -->
	<div class="description">
		<h3>상품 설명</h3>
		<p>${item.itemContent}</p>
	</div>

	<jsp:include page="/WEB-INF/views/bid/bid.jsp" />
	<jsp:include page="/WEB-INF/views/common/footer.jsp" />

	<script>
		 const SERVER_DATA = {
			        itemNo: ${item.itemNo},
			        contextPath: "${pageContext.request.contextPath}",
			        // 로그인 안했을 경우를 대비해 기본값 0 설정
			        currentUserNo: '<sec:authorize access="isAuthenticated()"><sec:authentication property="principal.userNo" /></sec:authorize>' || '0',
			        currentPrice: "${currentPrice}".replace(/,/g, ""),
			        buyNowPrice: "${item.buyNowPrice}",
			        sellerUserNo: "${item.userNo}"
			    };
	</script>
	<script src="${pageContext.request.contextPath}/resources/js/itemJs/itemDetail.js" defer></script>
	<script src="${pageContext.request.contextPath}/resources/js/reportJs/report.js"></script>
</body>
</html>