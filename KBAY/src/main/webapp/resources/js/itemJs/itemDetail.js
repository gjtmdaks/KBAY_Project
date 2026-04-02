const ITEM_NO = SERVER_DATA.itemNo;
const CONTEXT_PATH = SERVER_DATA.contextPath;
const CURRENT_USER_NO = SERVER_DATA.currentUserNo;
const INITIAL_PRICE = parseInt(SERVER_DATA.currentPrice) || 0;
const MAX_BID = 1000000000;
const BUY_NOW_PRICE = SERVER_DATA.buyNowPrice;

let stompClient = null;

function changeImage(el) {
    const mainImg = document.getElementById("mainImg");
    document.querySelectorAll('.thumb').forEach(thumb => thumb.classList.remove('active'));
    el.classList.add('active');
    mainImg.classList.add("fade-out");
    setTimeout(() => {
        mainImg.src = el.src;
        mainImg.onload = () => mainImg.classList.remove("fade-out");
    }, 300);
}

function moveImage(dir) {
    const thumbs = document.querySelectorAll('.thumb');
    let activeIndex = Array.from(thumbs).findIndex(thumb => thumb.classList.contains('active'));
    if (activeIndex === -1) activeIndex = 0;
    let newIndex = activeIndex + dir;
    if (newIndex >= 0 && newIndex < thumbs.length) {
        changeImage(thumbs[newIndex]);
        thumbs[newIndex].scrollIntoView({ behavior: 'smooth', block: 'nearest', inline: 'center' });
    }
}

function toggleWishlist(itemNo) {
    const wishBtn = document.getElementById("wishBtn");
    const heartIcon = wishBtn.querySelector(".heart-icon");
    fetch(`${CONTEXT_PATH}/wishlist/toggle`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ itemNo: itemNo })
    })
    .then(res => {
        if (res.status === 401) {
            alert("로그인이 필요합니다.");
            location.href = `${CONTEXT_PATH}/member/login`;
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

function updateTimer() {
    const el = document.getElementById("timer");
    if (!el) return;
    const now = new Date().getTime();
    const end = parseInt(el.dataset.end);
    const start = parseInt(el.dataset.start);
    let diff;
    if (now < start) {
        diff = (start - now) / 1000;
        el.innerText = "시작까지 " + formatTime(diff);
    } else if (now > end) {
        el.innerText = "종료";
    } else {
        diff = (end - now) / 1000;
        el.innerText = "종료까지 " + formatTime(diff);
    }
}

function formatTime(sec) {
    sec = Math.floor(sec);
    const d = Math.floor(sec / 86400);
    const h = Math.floor((sec % 86400) / 3600);
    const m = Math.floor((sec % 3600) / 60);
    const s = sec % 60;
    if (d > 0) return d + "일 " + h + "시간 " + m + "분 " + s + "초";
    if (h > 0) return h + "시간 " + m + "분 " + s + "초";
    return m + "분 " + s + "초";
}

function formatBidPrice(el) {
    let value = el.value.replace(/[^0-9]/g, '');
    if (value) {
        let numValue = parseInt(value, 10);
        if (numValue > MAX_BID) {
            numValue = MAX_BID;
            alert("입찰 금액은 최대 10억 원을 초과할 수 없습니다.");
        }
        el.value = numValue.toLocaleString();
    } else {
        el.value = '';
    }
}

function submitBid(e, itemNo) {
    const btn = e.target;
    const bidPriceInput = document.getElementById("bidPrice");
    const bidPrice = parseInt(bidPriceInput.value.replace(/,/g, ""), 10);
    const BUY_NOW_PRICE = SERVER_DATA.buyNowPrice;
    
    if (!bidPrice || isNaN(bidPrice)) {
        alert("올바른 금액을 입력하세요.");
        return;
    }
    if (bidPrice % 1000 !== 0) {
        alert("입찰 금액은 1,000원 단위로만 입력 가능합니다.");
        bidPriceInput.focus();
        return;
    }
	if (BUY_NOW_PRICE > 0 && bidPrice >= BUY_NOW_PRICE) {
	    alert("즉시구매가 이상으로는 입찰할 수 없습니다.\n즉시구매를 이용해주세요.");
	    return;
	}
    if (bidPrice > MAX_BID) {
        alert("입찰 금액은 최대 10억 원을 초과할 수 없습니다.");
        return;
    }
    if (String(CURRENT_USER_NO) === String(SERVER_DATA.sellerUserNo)) {
        alert("본인 상품에는 입찰할 수 없습니다.");
        return;
    }
    openConfirmModal(bidPrice, function() {
        btn.disabled = true;
        fetch(`${CONTEXT_PATH}/bid`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ itemNo: itemNo, bidPrice: bidPrice })
        })
        .then(res => res.status === 401 ? (location.href = `${CONTEXT_PATH}/member/login`) : res.json())
        .then(data => {
            if (data && data.result === "SUCCESS") {
                data.ranking === 1 ? openFirstBidderModal() : openSecondBidderModal();
            } else if (data) {
                alert(data.message || "입찰 실패");
            }
        })
        .catch(err => console.error(err))
        .finally(() => btn.disabled = false);
    });
}

function openConfirmModal(bidPrice, onConfirm) {
    const modal = document.getElementById("confirmModal");
    if (!modal) return;
    modal.style.display = "block";
    document.getElementById("confirmPrice").innerText = bidPrice.toLocaleString();
    const confirmBtn = document.getElementById("confirmBtn");
    confirmBtn.onclick = () => {
        modal.style.display = "none";
        onConfirm();
    };
    document.getElementById("cancelBtn").onclick = () => modal.style.display = "none";
}

function openFirstBidderModal() { document.getElementById("firstModal").style.display = "block"; }
function openSecondBidderModal() { document.getElementById("secondModal").style.display = "block"; }
function closeModal(id) { document.getElementById(id).style.display = "none"; }

function connect() {
    const socket = new SockJS(`${CONTEXT_PATH}/ws`);
    stompClient = Stomp.over(socket);
    stompClient.connect({}, function(frame) {
        stompClient.subscribe('/topic/bid/' + ITEM_NO, function(response) {
            updateRealTimeUI(JSON.parse(response.body));
        });
    }, function(error) {
        setTimeout(connect, 5000);
    });
}

function updateRealTimeUI(data) {
console.log("웹소켓 수신 데이터:", data);
    const priceEl = document.getElementById("currentPrice");
    const bidCountEl = document.getElementById("bidCount");
    const topMsg = document.getElementById("topBidderMsg");
    const bidPriceInput = document.getElementById("bidPrice");
    const prevPrice = parseInt(priceEl.innerText.replace(/,/g, '')) || 0;

    priceEl.innerText = data.bidPrice.toLocaleString();
    if (bidCountEl && data.bidCount !== undefined) {
    console.log("화면 업데이트 시도 - 서버 입찰수:", data.bidCount);
        bidCountEl.innerText = data.bidCount + "회";
    }
    if (bidPriceInput && document.activeElement !== bidPriceInput) {
        bidPriceInput.value = (data.bidPrice + 1000).toLocaleString();
    }
    if (data.bidPrice > prevPrice) {
        priceEl.classList.add("price-up");
        setTimeout(() => priceEl.classList.remove("price-up"), 800);
    }
    if (topMsg) {
        topMsg.style.display = (String(data.userNo) === String(CURRENT_USER_NO)) ? "block" : "none";
    }
    if (document.getElementById("bidModal").style.display === "flex") {
        openBidModal(ITEM_NO);
    }
}

function openBidModal(itemNo, page = 1) {
    const modal = document.getElementById("bidModal");
    const tbody = document.getElementById("bidHistoryBody");
    const paginationEl = document.getElementById("bidPagination");

    tbody.innerHTML = '<tr><td colspan="5">데이터를 불러오는 중...</td></tr>';
    modal.style.display = "flex";

    fetch(`${CONTEXT_PATH}/bid/history/${itemNo}?cp=${page}`)
        .then(res => res.json())
        .then(data => {
            const list = data.list;
            const pi = data.pi;

            tbody.innerHTML = "";
            
            if(!list || list.length === 0) {
                tbody.innerHTML = '<tr><td colspan="5">입찰 기록이 없습니다.</td></tr>';
                paginationEl.innerHTML = "";
                return;
            }

            list.forEach((b, index) => {
                const isMine = (String(CURRENT_USER_NO) === String(b.userNo));
                let displayIp = "정보 없음";
                if (b.bidIp) {
                    const parts = b.bidIp.split('.');
                    displayIp = isMine ? b.bidIp : (parts.length === 4 ? `${parts[0]}.${parts[1]}.***.${parts[3]}` : b.bidIp.substring(0, b.bidIp.lastIndexOf(":") + 1) + "***");
                }
                const d = new Date(b.bidTime);
                const bidDateFull = `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')} ${String(d.getHours()).padStart(2, '0')}:${String(d.getMinutes()).padStart(2, '0')}:${String(d.getSeconds()).padStart(2, '0')}`;
                
                // 🔥 pi.totalCount와 pi.limit으로 번호 계산
                const displayNum = pi.totalCount - ((pi.currentPage - 1) * pi.limit) - index;

                tbody.innerHTML += `
                    <tr class="${isMine ? 'my-bid-row' : ''}">
                        <td>${displayNum}</td>
                        <td>${isMine ? b.userId : b.ranking + '번 입찰자'}</td>
                        <td>${isMine ? b.bidPrice.toLocaleString() + '원' : '***원'}</td>
                        <td>${bidDateFull}</td>
                        <td>${displayIp}</td>
                    </tr>`;
            });

            renderModalPagination(pi, itemNo);
        })
        .catch(err => {
            console.error(err);
            tbody.innerHTML = '<tr><td colspan="5">데이터 로드 중 오류가 발생했습니다.</td></tr>';
        });
}

function renderModalPagination(pi, itemNo) {
    const paginationEl = document.getElementById("bidPagination");
    if (!paginationEl) return;

    let html = "";
    
    // 🔥 PageInfo에 없는 startPage, endPage 계산 로직 추가
    const pageLimit = 10; // 하단에 보여줄 페이지 번호 개수
    const startPage = Math.floor((pi.currentPage - 1) / pageLimit) * pageLimit + 1;
    let endPage = startPage + pageLimit - 1;
    if (endPage > pi.maxPage) endPage = pi.maxPage;

    // 이전 버튼
    if (pi.currentPage <= 1) {
        html += `<span class="disabled">&lt;</span>`;
    } else {
        html += `<a href="javascript:void(0)" onclick="openBidModal(${itemNo}, ${pi.currentPage - 1})">&lt;</a>`;
    }

    // 페이지 번호
    for (let i = startPage; i <= endPage; i++) {
        if (i === pi.currentPage) {
            html += `<span class="active">${i}</span>`;
        } else {
            html += `<a href="javascript:void(0)" onclick="openBidModal(${itemNo}, ${i})">${i}</a>`;
        }
    }

    // 다음 버튼
    if (pi.currentPage >= pi.maxPage) {
        html += `<span class="disabled">&gt;</span>`;
    } else {
        html += `<a href="javascript:void(0)" onclick="openBidModal(${itemNo}, ${pi.currentPage + 1})">&gt;</a>`;
    }

    paginationEl.innerHTML = html;
}

function closeBidModal() { document.getElementById("bidModal").style.display = "none"; }

document.addEventListener("DOMContentLoaded", function() {
    connect();
    setInterval(updateTimer, 1000);
    updateTimer();
    const initialPrice = parseInt(SERVER_DATA.currentPrice) || 0;
    
    const bidPriceInput = document.getElementById("bidPrice");
    if (bidPriceInput) bidPriceInput.value = (initialPrice + 1000).toLocaleString();
    
    const firstThumb = document.querySelector('.thumb');
    if (firstThumb) firstThumb.classList.add('active');

    const thumbList = document.getElementById("thumbList");
    let isDown = false, startX, scrollLeft;
    thumbList.addEventListener("mousedown", (e) => {
        isDown = true; startX = e.pageX - thumbList.offsetLeft; scrollLeft = thumbList.scrollLeft; thumbList.style.cursor = "grabbing";
    });
    thumbList.addEventListener("mouseleave", () => isDown = false);
    thumbList.addEventListener("mouseup", () => { isDown = false; thumbList.style.cursor = "grab"; });
    thumbList.addEventListener("mousemove", (e) => {
        if (!isDown) return; e.preventDefault();
        const x = e.pageX - thumbList.offsetLeft;
        thumbList.scrollLeft = scrollLeft - (x - startX) * 2;
    });
});

window.onclick = function(event) {
    const modal = document.getElementById("bidModal");
    if (event.target == modal) modal.style.display = "none";
};

function changeBidAmount(step) {
    const input = document.getElementById("bidPrice");
    if (!input) return;

    let currentVal = parseInt(input.value.replace(/,/g, "")) || 0;

    let newVal;

    // 1000단위 보정
    if (currentVal % 1000 !== 0) {
        if (step > 0) {
            newVal = Math.ceil(currentVal / 1000) * 1000;
        } else {
            newVal = Math.floor(currentVal / 1000) * 1000;
        }
    } else {
        newVal = currentVal + step;
    }

    if (newVal < 0) newVal = 0;
    if (newVal > MAX_BID) newVal = MAX_BID;

    // 🔥 즉시구매가 제한
    if (BUY_NOW_PRICE > 0 && newVal >= BUY_NOW_PRICE) {
        newVal = BUY_NOW_PRICE;
    }

    input.value = newVal.toLocaleString();
}

function buyNow(itemNo) {
    if (String(CURRENT_USER_NO) === String(SERVER_DATA.sellerUserNo)) {
        alert("본인 상품은 구매할 수 없습니다.");
        return;
    }

    if (!confirm("즉시구매 하시겠습니까?")) return;

    fetch(`${CONTEXT_PATH}/bid/buyNow`, {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({
            itemNo: itemNo
        })
    })
    .then(res => res.json())
    .then(data => {

        if (data.result === "SUCCESS") {
            alert("즉시구매 완료");
            location.reload(); // 종료 상태 반영
        } else {
            alert(data.message || "즉시구매 실패");
        }

    })
    .catch(err => {
        console.error(err);
        alert("에러 발생");
    });
}


