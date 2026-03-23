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
<title>K-Bay 경매 목록</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/headerFooterCss/header.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/home.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/itemCss/itemDetail.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/headerFooterCss/paging.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/bidCss/bid.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/headerFooterCss/footer.css">
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />
	
	<div class="detail-container">
	
	    <!-- 이미지 영역 -->
	    <div class="image-section">
	
	        <!-- 대표 이미지 -->
	        <div class="main-image">
	            <img id="mainImg"
	                 src="${item.mainImg}"
	                 onerror="this.onerror=null; this.src='https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg';">
	        </div>
	
	        <!-- 썸네일 리스트 -->
			<div class="thumbnail-wrapper">
			    <button class="thumb-btn left" onclick="scrollThumb(-1)">❮</button>
			
			    <div class="thumbnail-list" id="thumbList">
			        <c:if test="${item.mainImg != null}">
			            <img src="${item.mainImg}" class="thumb" onclick="changeImage(this)">
			        </c:if>
			
			        <c:forEach var="img" items="${item.subImgList}">
			            <img src="${img.imgUrl}" class="thumb" onclick="changeImage(this)">
			        </c:forEach>
			    </div>
			
			    <button class="thumb-btn right" onclick="scrollThumb(1)">❯</button>
			</div>
	    </div>
	
	    <!-- 상품 정보 -->
	    <div class="info-section">
	        <h2>${item.itemTitle}</h2>
	
	        <!-- 타이머 -->
			<table class="auction-table">
			    <tr>
			        <th>남은시간</th>
			        <td>
			            <strong class="timer" id="timer"
			                data-end="${item.endTime.time}"
			                data-start="${item.startTime.time}">
			            </strong>
			        </td>
			    </tr>
			    <tr>
			    	<th></th>
			        <td class="end-time">
			            (<fmt:formatDate value="${item.endTime}" pattern="yyyy년 M월 d일 HH:mm:ss"/>)
			        </td>
			    </tr>
			
			    <!-- 경매번호 -->
			    <tr>
			        <th>경매번호</th>
			        <td>${item.itemNo}</td>
			    </tr>
			
			    <!-- 입찰수 -->
			    <tr>
			        <th>입찰수</th>
			        <td>
			            <c:choose>
			                <c:when test="${empty bidCount}">0회</c:when>
			                <c:otherwise>${bidCount}회</c:otherwise>
			            </c:choose>
			        </td>
			    </tr>
			
			</table>
		    
		    <hr>
	
	        <div class="meta">
	            <span>카테고리: ${itemCategory.itemCategory}</span> <br>
	            <span>판매자: ${item.userNo}</span>
	        </div>
	
	        <!-- 가격 -->
	        <div class="price-box">
	            <c:choose>
	                <c:when test="${now.time < item.startTime.time}">
	                    <div>시작가 <strong>${item.startPrice}</strong></div>
	                </c:when>
	
	                <c:when test="${now.time > item.endTime.time}">
	                    <div>낙찰가 <strong>${item.currentPrice}</strong></div>
	                </c:when>
	
	                <c:otherwise>
	                    <div>현재가 <strong>${item.currentPrice}</strong></div>
	                </c:otherwise>
	            </c:choose>
	
	            <c:if test="${item.directBuy eq 'Y'}">
	                <div class="buy-now">즉시구매가 ${item.buyNowPrice}</div>
	            </c:if>
	        </div>
	
	        <!-- 입찰 -->
	        <c:if test="${now.time >= item.startTime.time && now.time <= item.endTime.time}">
	            <div class="bid-box">
	                <input type="number" id="bidPrice" placeholder="입찰 금액">
	                <button onclick="submitBid(${item.itemNo})">입찰하기</button>
	            </div>
	        </c:if>
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
	// 이미지 변경
	function changeImage(el){
	    document.getElementById("mainImg").src = el.src;
	}
	
	// 타이머
	function updateTimer(){
	    const el = document.getElementById("timer");
	    const now = new Date().getTime();
	    const end = parseInt(el.dataset.end);
	    const start = parseInt(el.dataset.start);
	
	    let diff;
	
	    if(now < start){
	        diff = (start - now) / 1000;
	        el.innerText = "시작까지 " + formatTime(diff);
	    }else if(now > end){
	        el.innerText = "종료";
	    }else{
	        diff = (end - now) / 1000;
	        el.innerText = "종료까지 " + formatTime(diff);
	    }
	}
	
	function formatTime(sec){
	    sec = Math.floor(sec);
	    const d = Math.floor(sec / 86400);
	    const h = Math.floor((sec % 86400)/3600);
	    const m = Math.floor((sec % 3600)/60);
	    const s = sec % 60;
	
	    if(d > 0) return d+"일 "+h+"시간 "+m+"분"+s+"초";
	    if(h > 0) return h+"시간 "+m+"분"+s+"초";
	    return m+"분"+s+"초";
	}
	
	setInterval(updateTimer,1000);
	updateTimer();
	
	
	// 입찰
	function submitBid(itemNo){
		const bidPrice = parseInt(document.getElementById("bidPrice").value, 10);
	
	    if(!bidPrice){
	        alert("금액을 입력하세요.");
	        return;
	    }
	
	    // 1차 확인 팝업
	    openConfirmModal(bidPrice, function() {
	
	        // 확인 눌렀을 때 실행
	        fetch(`${pageContext.request.contextPath}/bid`, {
	            method: "POST",
	            headers: {
	                "Content-Type": "application/json"
	            },
	            body: JSON.stringify({
	                itemNo: itemNo,
	                bidPrice: bidPrice
	            })
	        })
	        .then(res => {
	            if(res.status === 401){
	                alert("로그인이 필요합니다.");
	                location.href = "/kbay/member/login";
	                return;
	            }
	            return res.json();
	        })
	        .then(data => {
			
			    if(!data) return;
			
			    if(data.result === "SUCCESS"){
			
			        if(data.ranking === 1){
			            openFirstBidderModal();
			        } else {
			            openSecondBidderModal();
			        }
			
			    } else {
			
			        // 🔥 메시지 기반 처리
			        if(data.message === "LOGIN_REQUIRED"){
			            alert("로그인이 필요합니다.");
			            location.href = "/kbay/member/login";
			
			        } else {
			            alert(data.message || "입찰 실패");
			        }
			    }
			})
	        .catch(err => {
	            console.error(err);
	            alert("에러 발생");
	        });
	
	    });
	}
	
	function openConfirmModal(bidPrice, onConfirm){

	    const modal = document.getElementById("confirmModal");

	    if(!modal){
	        console.error("confirmModal 없음");
	        return;
	    }
	    modal.style.display = "block";

	    document.getElementById("confirmPrice").innerText = bidPrice.toLocaleString();

	    // 입찰하기 버튼
	    const confirmBtn = document.getElementById("confirmBtn");

	    confirmBtn.onclick = null; // 초기화
	    confirmBtn.onclick = function(){
	        modal.style.display = "none";
	        onConfirm();
	    };

	    // 취소 버튼
	    document.getElementById("cancelBtn").onclick = function(){
	        modal.style.display = "none";
	    };
	}
	
	function openFirstBidderModal(){
	    document.getElementById("firstModal").style.display = "block";
	}

	function openSecondBidderModal(){
	    document.getElementById("secondModal").style.display = "block";
	}
	
	function closeModal(id){
	    document.getElementById(id).style.display = "none";
	}
	
	const thumbList = document.getElementById("thumbList");

	function scrollThumb(dir){
	    thumbList.scrollLeft += dir * 200;
	}

	// 드래그 스크롤
	let isDown = false;
	let startX, scrollLeft;

	thumbList.addEventListener("mousedown", (e)=>{
	    isDown = true;
	    startX = e.pageX - thumbList.offsetLeft;
	    scrollLeft = thumbList.scrollLeft;
	    thumbList.style.cursor = "grabbing";
	});

	thumbList.addEventListener("mouseleave", ()=> isDown = false);
	thumbList.addEventListener("mouseup", ()=> {
	    isDown = false;
	    thumbList.style.cursor = "grab";
	});

	thumbList.addEventListener("mousemove", (e)=>{
	    if(!isDown) return;
	    e.preventDefault();
	    const x = e.pageX - thumbList.offsetLeft;
	    const walk = (x - startX) * 2;
	    thumbList.scrollLeft = scrollLeft - walk;
	});
	</script>
</body>
</html>