<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<jsp:useBean id="now" class="java.util.Date" />
<c:set var="now" value="${now}" scope="request"/>

<!DOCTYPE html>
<html lang="ko">
<head>

<!-- 웹소켓 통신을 위한 JS 라이브러리 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

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
			    
			      <tr>
                <th>조회수</th>
                <td>${item.views}회</td>
                </tr>
			
			    <!-- 입찰수 -->
			    <tr>
			        <th>입찰수</th>
			        <td id="bidCount">
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
            <div>시작가 <strong><fmt:formatNumber value="${item.startPrice}" pattern="#,###" /></strong></div>
        </c:when>

        <c:when test="${now.time > item.endTime.time}">
            <div>낙찰가 <strong><fmt:formatNumber value="${currentPrice}" pattern="#,###" /></strong></div>
        </c:when>

        <c:otherwise>
            <div>
                현재가 <strong id="currentPrice"><fmt:formatNumber value="${currentPrice}" pattern="#,###" /></strong>
                <button type="button" class="btn-bid-history-small" onclick="openBidModal(${item.itemNo})">
                    [입찰기록]
                </button>
            </div>
        </c:otherwise>
    </c:choose>

    		<c:if test="${item.directBuy eq 'Y'}">
        <div class="buy-now">즉시구매가 <fmt:formatNumber value="${item.buyNowPrice}" pattern="#,###" /></div>
  		  </c:if>
		</div>
	
	        <!-- 입찰 -->
	       <c:if test="${now.time >= item.startTime.time && now.time <= item.endTime.time}">
    <div class="bid-section-wrapper">
        <div class="bid-box">
            <input type="number" id="bidPrice" placeholder="입찰 금액">
            <button onclick="submitBid(event, ${item.itemNo})">입찰하기</button>
        </div>
        
        <p id="topBidderMsg" class="top-bidder-msg" 
           style="color: #2980b9; font-weight: bold; margin-top: 12px; ${isTopBidder ? '' : 'display: none;'}">
            📢 귀하가 현재 최순위 입찰자입니다.
        </p>
  		  </div>
		</c:if>
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
                <tbody id="bidHistoryBody">
                    </tbody>
            </table>
        </div>
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
	function submitBid(e, itemNo){
    const btn = event.target; // 클릭한 버튼
    const bidPriceInput = document.getElementById("bidPrice");
    const bidPrice = parseInt(bidPriceInput.value, 10);

    if(!bidPrice || isNaN(bidPrice)){
        alert("올바른 금액을 입력하세요.");
        return;
    }
	
	    // 1차 확인 팝업
  openConfirmModal(bidPrice, function() {
	    	btn.disabled = true;

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
	            if (res.status === 401) {
	                alert("로그인이 필요합니다.");
	                location.href = "/kbay/member/login";
	                return;
	            }
	            return res.json();
	        })
	        .then(data => {
	            if (!data) return;

	            if (data.result === "SUCCESS") {
	                bidPriceInput.value = ""; // 입력창 비우기
	                if (data.ranking === 1) {
	                    openFirstBidderModal();
	                } else {
	                    openSecondBidderModal();
	                }
	            } else {
	                // 서버에서 "현재가보다 높은 금액을 입력하세요" 등의 메시지를 그대로 전달
	                alert(data.message || "입찰 실패");
	            }
	        })
	        .catch(err => {
	            console.error(err);
	            alert("에러 발생");
	        })
	        .finally(() => {
	            // [추가] 통신 완료 후 버튼 다시 활성화
	            btn.disabled = false;
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
	
	
	let stompClient = null;
	const itemNo = ${item.itemNo};

	function connect() {
	    // 1. WebSocket 연결 (WebSocketConfig에서 설정한 엔드포인트)
	    const socket = new SockJS('${pageContext.request.contextPath}/ws');
	    stompClient = Stomp.over(socket);

	    // 디버그 로그가 너무 많으면 아래 주석 해제
	    // stompClient.debug = null; 

	    stompClient.connect({}, function (frame) {
	        console.log('Connected: ' + frame);

	        // 2. 해당 상품의 채널 구독 (RedisSubscriber에서 보내는 경로)
	        stompClient.subscribe('/topic/bid/' + itemNo, function (response) {
	            const bidData = JSON.parse(response.body);
	            
	            // 3. 실시간 UI 업데이트 실행
	            updateRealTimeUI(bidData);
	        });
	    }, function(error) {
	        console.log('STOMP error: ' + error);
	        // 연결 끊김 시 5초 후 재연결 시도
	        setTimeout(connect, 5000);
	    });
	}

	// 실시간 UI 갱신 함수
	function updateRealTimeUI(data) {
	    // 현재가 갱신 (애니메이션 효과 추가 권장)
	    const priceEl = document.getElementById("currentPrice");
	    const bidCountEl = document.getElementById("bidCount");
	    const topMsg = document.getElementById("topBidderMsg");

	    // 1. 현재가(2등 가격) 갱신
	    const prevPrice = parseInt(priceEl.innerText.replace(/,/g, '')) || 0;
	    priceEl.innerText = data.bidPrice.toLocaleString();
	    
	 // 2. 가격 상승 시 시각적 효과
	    if(data.bidPrice > prevPrice) {
	        priceEl.classList.add("price-up"); // CSS로 빨간색 깜빡임 효과
	        setTimeout(() => priceEl.classList.remove("price-up"), 800);
	    }
	    

	    // 입찰수 갱신 (data에 bidCount가 포함되어야 함, 없다면 기존처럼 fetch 호출 가능)
	    // 여기서는 간단하게 기존 숫자에 +1을 하거나 최신 정보를 다시 가져옵니다.
	    let count = parseInt(bidCountEl.innerText)|| 0 ;
	    bidCountEl.innerText = (count + 1) + "회";
	    
	    if (String(data.userNo) === String(currentUserNo)) {
	        if(topMsg) topMsg.style.display = "block";
	    } else {
	        if(topMsg) topMsg.style.display = "none";
	    }
	    
	    // 만약 입찰 기록 모달이 열려있다면 즉시 새로고침
	    if(document.getElementById("bidModal").style.display === "flex") {
	        openBidModal(itemNo);
	    }
	}

	// 기존 setInterval은 삭제하고 connect() 호출
	document.addEventListener("DOMContentLoaded", function() {
	    connect();
	});
	</script>
	
	
	<script>
	// 입찰 기록 조회
	const contextPath = "${pageContext.request.contextPath}";
	const currentUserNo = '<sec:authorize access="isAuthenticated()"><sec:authentication property="principal.userNo" /></sec:authorize>';

	function openBidModal(itemNo) {
	    var modal = document.getElementById("bidModal");
	    var tbody = document.getElementById("bidHistoryBody");
	    
	    tbody.innerHTML = '<tr><td colspan="5">데이터를 불러오는 중...</td></tr>';
	    modal.style.display = "flex"; 

	    fetch(contextPath + "/bid/history/" + itemNo)
	        .then(function(res) { return res.json(); })
	        .then(function(list) {
	            tbody.innerHTML = "";
	            
	            // 입찰 기록 조회하는 유저와 동일한 정보가 있는지 확인
	            list.forEach(function(b) {
	                var isMine = (String(currentUserNo) === String(b.userNo));
	                
	                
	                // 내가 입찰한 기록이 아니라면 마스킹
	                var displayIp = "정보 없음";
	                if (b.bidIp) {
	                    if (isMine) {
	                        displayIp = b.bidIp;
	                    } else {
	                        var parts = b.bidIp.split('.');
	                        if (parts.length === 4) {
	                            displayIp = parts[0] + "." + parts[1] + ".***." + parts[3];
	                        } else {
	                            displayIp = b.bidIp.substring(0, b.bidIp.lastIndexOf(":") + 1) + "***";
	                        }
	                    }
	                }

	                var d = new Date(b.bidTime);
	                var bidDateFull = d.getFullYear() + "-" 
	                    + String(d.getMonth() + 1).padStart(2, '0') + "-" 
	                    + String(d.getDate()).padStart(2, '0') + " " 
	                    + String(d.getHours()).padStart(2, '0') + ":" 
	                    + String(d.getMinutes()).padStart(2, '0') + ":" 
	                    + String(d.getSeconds()).padStart(2, '0');
					
	                    // 내 입찰기록은 강조해서 표시
	                var row = "<tr class='" + (isMine ? "my-bid-row" : "") + "'>" +
	                          "<td>" + b.ranking + "</td>" +
	                          "<td>" + (isMine ? b.userId : b.ranking + "번 입찰자") + "</td>" +
	                          "<td>" + (isMine ? b.bidPrice.toLocaleString() + "원" : "***원") + "</td>" +
	                          "<td>" + bidDateFull + "</td>" +
	                          "<td>" + displayIp + "</td>" +
	                          "</tr>";
	                
	                tbody.innerHTML += row;
	            });
	        });
	}

function closeBidModal() {
    document.getElementById("bidModal").style.display = "none";
}

window.onclick = function(event) {
    const modal = document.getElementById("bidModal");
    if (event.target == modal) modal.style.display = "none";
}
</script>
</body>
</html>