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
        <div class="main-image">
            <img id="mainImg" src="${item.mainImg}" onerror="this.onerror=null; this.src='https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg';">
        </div>
        <div class="thumbnail-wrapper">
                        <button class="thumb-btn left" onclick="moveImage(-1)">❮</button>
            <div class="thumbnail-list" id="thumbList">
                <c:if test="${not empty item.mainImg}">
                    <img src="${item.mainImg}" class="thumb" onclick="changeImage(this)">
                </c:if>
                <c:forEach var="img" items="${item.subImgList}">
                    <img src="${img.imgUrl}" class="thumb" onclick="changeImage(this)">
                </c:forEach>
			    </div>
			
			      <button class="thumb-btn right" onclick="moveImage(1)">❯</button>
        </div>
    </div>
	
	    <!-- 상품 정보 -->
	        <div class="info-section">
	                    <button type="button" id="wishBtn" class="wish-btn ${isWish > 0 ? 'active' : ''}" 
            onclick="toggleWishlist(${item.itemNo})">
        <span class="heart-icon">${isWish > 0 ? '❤️' : '🤍'}</span>
            </button>
        <h2 class="item-title">${item.itemTitle}</h2>
        <div class="meta-info">
            <span class="category-tag">${itemCategory.itemCategory}</span>
            <span class="seller-name">판매자: <strong>${item.userName}</strong></span>
        </div>

        <div class="auction-details">
            <div class="info-row">
                <span class="label">남은 시간</span>
                <span id="timer" class="value timer-text" data-end="${item.endTime.time}" data-start="${item.startTime.time}">-</span>
            </div>
            <div class="info-row">
                <span class="label">입찰 수</span>
                <span id="bidCount" class="value">${bidCount}회</span>
            </div>
            <div class="info-row">
                <span class="label">조회수</span>
                <span class="value">${item.views}회</span>
            </div>
            <div class="info-row">
                <span class="label">경매 번호</span>
                <span class="value">#${item.itemNo}</span>
            </div>
            <c:if test="${not empty loginUser and loginUser.userNo != item.userNo}">
                <button type="button" class="report-btn"
                        onclick="openReportPopup('item', ${item.itemNo})">
                        🚨 신고하기
                </button>
                <jsp:include page="/WEB-INF/views/report/reportPopup.jsp" />
            </c:if>
        </div>

        <div class="price-section">
            <div class="price-header">
                <span class="price-label">현재 입찰가</span>
                <button type="button" class="btn-history" onclick="openBidModal(${item.itemNo})">입찰기록 ❯</button>
            </div>
            <div class="price-amount-wrapper">
                <strong id="currentPrice"><fmt:formatNumber value="${currentPrice}" pattern="#,###" /></strong>
                <span class="unit">원</span>
            </div>

            <c:if test="${now.time >= item.startTime.time && now.time <= item.endTime.time}">
                <div class="bid-form">
                    <div class="input-group">
  					  <input type="text" id="bidPrice" placeholder="금액 입력" oninput="formatBidPrice(this)">
   						 <span class="input-unit">원</span>
   						 <div class="bid-controls">
   					     <button type="button" onclick="changeBidAmount(1000)">▲</button>
   				     <button type="button" onclick="changeBidAmount(-1000)">▼</button>
    				</div>
				</div>
                    <button class="btn-submit-bid" onclick="submitBid(event, ${item.itemNo})">입찰하기</button>
                    <p id="topBidderMsg" class="top-bid-notice" style="${isTopBidder ? '' : 'display: none;'}">
                        ✓ 현재 회원님이 최고가 입찰자입니다.
                    </p>
                </div>
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
	function changeImage(el) {
    const mainImg = document.getElementById("mainImg");
    
    document.querySelectorAll('.thumb').forEach(thumb => thumb.classList.remove('active'));
    el.classList.add('active');
    
    mainImg.classList.add("fade-out");
    setTimeout(() => {
        mainImg.src = el.src;
        mainImg.onload = () => {
            mainImg.classList.remove("fade-out");
        };
    }, 300);
}
	
    function moveImage(dir) {
        const thumbs = document.querySelectorAll('.thumb');
        let activeIndex = -1;

        thumbs.forEach((thumb, index) => {
            if (thumb.classList.contains('active')) activeIndex = index;
        });

        if (activeIndex === -1) activeIndex = 0;

        let newIndex = activeIndex + dir;
        
        if (newIndex >= 0 && newIndex < thumbs.length) {
            changeImage(thumbs[newIndex]);
            thumbs[newIndex].scrollIntoView({ behavior: 'smooth', block: 'nearest', inline: 'center' });
        }
    }
    
    // 찜목록 위시리스트
    function toggleWishlist(itemNo) {
        const wishBtn = document.getElementById("wishBtn");
        const heartIcon = wishBtn.querySelector(".heart-icon");

        // 로그인 여부는 서버(Controller)에서 401로 응답받아 처리하는 게 깔끔합니다.
        fetch(`${pageContext.request.contextPath}/wishlist/toggle`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ itemNo: itemNo })
        })
        .then(res => {
            if (res.status === 401) {
                alert("로그인이 필요합니다.");
                location.href = "${pageContext.request.contextPath}/member/login";
                return;
            }
            return res.json();
        })
        .then(data => {
            if (data.result === "INSERT") {
                wishBtn.classList.add("active");
                heartIcon.innerText = "❤️";
            } else if (data.result === "DELETE") {
                wishBtn.classList.remove("active");
                heartIcon.innerText = "🤍";
            }
        })
        .catch(err => console.error(err));
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
	
	    if(d > 0) return d+"일 "+h+"시간 "+m+"분 "+s+"초";
	    if(h > 0) return h+"시간 "+m+"분 "+s+"초";
	    return m+"분 "+s+"초";
	}
	
	setInterval(updateTimer,1000);
	updateTimer();
	
	function formatBidPrice(el) {
	    let value = el.value.replace(/[^0-9]/g, '');
        const MAX_BID = 1000000000; // 10억 상한선
        
	    if (value) {
            let numValue = parseInt(value, 10);
            
            if (numValue > MAX_BID) {
                numValue = MAX_BID; 
                alert("입찰 금액은 최대 10억 원을 초과할 수 없습니다.");
            }
            
            el.value = numValue.toLocaleString();
        }else {
	        el.value = '';
	    }
	}

	function changeBidAmount(step) {
	    const input = document.getElementById("bidPrice");
	    let currentVal = parseInt(input.value.replace(/,/g, "")) || 0;
        const MAX_BID = 1000000000;
        
	    let newVal = currentVal + step;
	    if (newVal < 0) newVal = 0; // 0원 이하 방지
        if (newVal > MAX_BID) newVal = MAX_BID;
	    
	    input.value = newVal.toLocaleString();
	}
	// 입찰
    function submitBid(e, itemNo){
    const btn = event.target; // 클릭한 버튼
    const bidPriceInput = document.getElementById("bidPrice");
    const bidPrice = parseInt(bidPriceInput.value.replace(/,/g, ""), 10);
    const MAX_BID = 1000000000;
    
    if(!bidPrice || isNaN(bidPrice)){
        alert("올바른 금액을 입력하세요.");
        return;
    }
   
    if (bidPrice > MAX_BID) {
        alert("입찰 금액은 최대 10억 원을 초과할 수 없습니다.");
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
	    const bidPriceInput = document.getElementById("bidPrice");
	    
	    // 1. 현재가(2등 가격) 갱신
	    const prevPrice = parseInt(priceEl.innerText.replace(/,/g, '')) || 0;
	    priceEl.innerText = data.bidPrice.toLocaleString();
	    
	    // 입찰금액 = 현재가 + 1000
	  if(bidPriceInput && document.activeElement !== bidPriceInput) {
    // 숫자를 넣을 때 toLocaleString()을 붙여주세요
    bidPriceInput.value = (data.bidPrice + 1000).toLocaleString();
}
	    
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
        const firstThumb = document.querySelector('.thumb');
        if(firstThumb) firstThumb.classList.add('active');
	    const initialPrice = parseInt("${currentPrice}") || 0;
	    const bidPriceInput = document.getElementById("bidPrice");
	    if(bidPriceInput) {
	        bidPriceInput.value = (initialPrice + 1000).toLocaleString();
	    }
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
                        + String(d.getSeconds()).padStart(2, '0') + ":" 
                        + String(d.getMilliseconds()).padStart(3, '0');
					
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
<script src="${pageContext.request.contextPath}/resources/js/reportJs/report.js"></script>
</body>
</html>