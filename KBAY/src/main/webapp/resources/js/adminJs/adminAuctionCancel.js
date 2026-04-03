// 전역 변수로 입찰 데이터와 페이지 상태 저장
let currentBidData = []; 
let currentBidPage = 1;
const bidsPerPage = 10; // 💡 한 화면에 보여줄 개수 (10개)

// 1. 모달창 열기 및 데이터 가져오기
function openBidHistory(itemNo) {
    const modal = document.getElementById("bidModal");
    const titleEle = document.getElementById("modalItemTitle");
    const tbody = document.getElementById("bidHistoryList");
    const paginationArea = document.getElementById("modalPagination");

    modal.style.display = "flex";
    titleEle.innerText = `[${itemNo}] - 입찰 기록`;
    
    // 초기화
    tbody.innerHTML = "<tr><td colspan='5' style='text-align:center;'>데이터를 불러오는 중입니다... ⏳</td></tr>";
    paginationArea.innerHTML = "";

    // 서버로 AJAX 통신
    fetch(`${contextPath}/admin/bidHistory?itemNo=${itemNo}`)
        .then(response => {
            if (!response.ok) throw new Error("네트워크 응답이 좋지 않습니다.");
            return response.json();
        })
        .then(data => {
            currentBidData = data; // 가져온 전체 데이터를 변수에 저장
            currentBidPage = 1;    // 1페이지부터 시작

            if (currentBidData.length === 0) {
                tbody.innerHTML = "<tr><td colspan='5' style='text-align:center; padding: 30px; color: #7f8c8d;'>입찰 기록이 없습니다.</td></tr>";
                return;
            }

            // 테이블과 페이징 바 그리기 실행
            renderBidTable();
            renderBidPagination();
        })
        .catch(error => {
            console.error("Fetch 에러:", error);
            tbody.innerHTML = "<tr><td colspan='5' style='text-align:center; color: #e74c3c;'>데이터를 불러오는 데 실패했습니다.</td></tr>";
        });
}

// 2. 테이블 그리기 (10개씩 잘라서)
function renderBidTable() {
    const tbody = document.getElementById("bidHistoryList");
    tbody.innerHTML = ""; // 기존 내용 비우기

    // 배열 자르기 로직 (예: 1페이지면 0~9, 2페이지면 10~19)
    const startIndex = (currentBidPage - 1) * bidsPerPage;
    const endIndex = startIndex + bidsPerPage;
    const pageData = currentBidData.slice(startIndex, endIndex);

    pageData.forEach((bid, index) => {
        // 최고가 강조 (1페이지의 첫 번째 요소만 노란색 강조!)
        const isHighest = (currentBidPage === 1 && index === 0) ? "background-color: #fff9db; font-weight: bold;" : "";
        
        // 날짜 포맷 (YYYY-MM-DD HH:mm)
        const dateObj = new Date(bid.bidTime);
        const formatTime = dateObj.getFullYear() + "-" + 
                           String(dateObj.getMonth() + 1).padStart(2, '0') + "-" + 
                           String(dateObj.getDate()).padStart(2, '0') + " " + 
                           String(dateObj.getHours()).padStart(2, '0') + ":" + 
                           String(dateObj.getMinutes()).padStart(2, '0')+ ":" + 
                           String(dateObj.getSeconds()).padStart(2, '0') + ":" + 
                           String(dateObj.getMilliseconds()).padStart(3, '0');
						
        const tr = document.createElement("tr");
        tr.style = isHighest;
        tr.innerHTML = `
            <td>${bid.bidNo}</td>
            <td>${bid.userId}</td>
            <td style="color: #e74c3c;">${Number(bid.bidPrice).toLocaleString()}원</td>
            <td>${formatTime}</td>
            <td class="ip-text" style="color:#999;">${bid.bidIp || '정보없음'}</td>
        `;
        tbody.appendChild(tr);
    });
}

// 3. 모달용 페이징 바 그리기
function renderBidPagination() {
    const paginationArea = document.getElementById("modalPagination");
    const totalPages = Math.ceil(currentBidData.length / bidsPerPage);
    
    // 데이터가 10개 이하라면 페이징 바를 안 그림
    if (totalPages <= 1) {
        paginationArea.innerHTML = "";
        return;
    }

    // 기존 게시판 CSS 클래스(.pagination-list)를 재활용하여 예쁘게 그리기
    let pageHtml = `<ul class="pagination-list" style="margin-top: 20px; justify-content: center;">`;
    
    // 이전 버튼
    if (currentBidPage > 1) {
        pageHtml += `<li><a href="#" onclick="changeBidPage(${currentBidPage - 1}); return false;">&lt;</a></li>`;
    }

    // 페이지 번호
    for (let p = 1; p <= totalPages; p++) {
        const activeClass = (p === currentBidPage) ? "active" : "";
        pageHtml += `<li class="${activeClass}"><a href="#" onclick="changeBidPage(${p}); return false;">${p}</a></li>`;
    }

    // 다음 버튼
    if (currentBidPage < totalPages) {
        pageHtml += `<li><a href="#" onclick="changeBidPage(${currentBidPage + 1}); return false;">&gt;</a></li>`;
    }

    pageHtml += `</ul>`;
    paginationArea.innerHTML = pageHtml;
}

// 4. 페이지 이동 함수
function changeBidPage(page) {
    currentBidPage = page; // 현재 페이지 업데이트
    renderBidTable();      // 테이블 다시 그리기
    renderBidPagination(); // 페이징 바 다시 그리기 (active 표시 변경)
}

// 5. 모달창 닫기
function closeBidModal() {
    document.getElementById("bidModal").style.display = "none";
}

// 6. 강제 취소 처리
function processAuction(itemNo, status) {
    if(confirm(`${itemNo}번 경매를 정말로 강제 취소하시겠습니까?\n이 작업은 되돌릴 수 없습니다.`)) {
        
        // 서버로 취소 요청 보내기 (POST 방식)
        fetch(`${contextPath}/admin/auctionCancel`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: `itemNo=${itemNo}&status=${status}` // 아이템 번호와 'C'를 보냄
        })
        .then(response => response.text()) // 컨트롤러가 보내는 문자열(success 등) 받기
        .then(result => {
            if(result === "success") {
                alert("경매가 성공적으로 취소되었습니다.");
                location.reload(); // 💡 화면을 새로고침해서 취소된 내역을 목록에서 지움!
            } else {
                alert("취소 처리에 실패했습니다. 다시 시도해 주세요.");
            }
        })
        .catch(error => {
            console.error("Fetch 에러:", error);
            alert("서버와 통신 중 문제가 발생했습니다.");
        });
    }
}