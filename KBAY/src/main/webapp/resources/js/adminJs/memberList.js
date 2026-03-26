/* ==========================================
   🌟 [전역 변수] 파일 최상단에 딱 한 번만 선언!
   ========================================== */
let originalModalBody = "";  // 메뉴판 복구용
let currentModalData = [];   // 서버 데이터 저장용
let currentModalPage = 1;    // 현재 페이지 번호
const itemsPerPage = 5;      // 한 페이지당 보여줄 개수

document.addEventListener('DOMContentLoaded', function() {
    const modal = document.getElementById('memberModal');
    const tableBody = document.querySelector('.member-table tbody');
    const closeBtns = [
        document.getElementById('closeModalTop'),
        document.getElementById('closeModalBottom')
    ];

    // 회원 행 클릭 시 상세 정보 조회
    if (tableBody) {
        tableBody.addEventListener('click', function(e) {
            const targetRow = e.target.closest('.member-row');
            if (targetRow) {
                const userNo = targetRow.getAttribute('data-user-no');
                fetch(`${contextPath}/admin/memberDetail?userNo=${userNo}`)
                .then(response => response.json())
                .then(member => {
                    document.getElementById('targetUserNo').innerText = member.userNo;
                    document.getElementById('targetUserName').innerText = member.userName;
                    document.getElementById('targetUserId').innerText = "@" + member.userId;
                    
                    // 현재 메뉴 버튼 상태를 백업
                    originalModalBody = document.querySelector('.modal-body').innerHTML;
                    
                    if (modal) modal.classList.add('show');
                })
                .catch(err => console.error("회원 상세 로드 실패:", err));
            }
        });
    }

    // 모달 닫기 로직 (복구 포함)
    closeBtns.forEach(btn => {
        if(btn) btn.addEventListener('click', () => {
            restoreModalMenu();
            modal.classList.remove('show');
        });
    });

    if (modal) {
        modal.addEventListener('click', (e) => {
            if (e.target === modal) {
                restoreModalMenu();
                modal.classList.remove('show');
            }
        });
    }
});

// 메뉴판 복구 함수
window.restoreModalMenu = function() {
    const modalBody = document.querySelector('.modal-body');
    if (originalModalBody) {
        modalBody.innerHTML = originalModalBody;
    }
};

/* ==========================================
   📦 [기능 1] 경매 내역 조회 (페이징 윈도우 적용)
   ========================================== */
function viewUserAuctions() {
    const userNo = document.getElementById('targetUserNo').innerText;
    fetch(`${contextPath}/admin/userItemList?userNo=${userNo}`)
    .then(response => response.json())
    .then(list => {
        currentModalData = list;
        currentModalPage = 1;
        renderAuctionTable();
    })
    .catch(err => console.error("경매 로드 실패:", err));
}

function renderAuctionTable() {
    const modalBody = document.querySelector('.modal-body');
    const list = currentModalData;
    const totalItems = list.length;
    const totalPages = Math.ceil(totalItems / itemsPerPage) || 1;

    const startIndex = (currentModalPage - 1) * itemsPerPage;
    const pageData = list.slice(startIndex, startIndex + itemsPerPage);

    let html = `<div class="sub-list-header">
                    <h4>경매 등록 내역 (<span style="color:#4CAF50;">${totalItems}</span>건)</h4>
                    <button class="btn-mini-back" onclick="restoreModalMenu()">🔙 뒤로가기</button>
                </div>
                <table class="modal-sub-table">
                    <thead>
                        <tr><th>No</th><th>제목</th><th>가격</th><th>등록일</th><th>상태</th></tr>
                    </thead>
                    <tbody>`;

    if (totalItems === 0) {
        html += `<tr><td colspan="5" style="text-align:center; padding:30px;">내역 없음</td></tr>`;
    } else {
        pageData.forEach(item => {
            let startPrice = item.startPrice ? item.startPrice.toLocaleString() : '0';
            let currentPrice = item.currentPrice ? item.currentPrice.toLocaleString() : '0';
            let date = new Date(item.createAt).toLocaleDateString();

            html += `<tr>
                        <td>${item.itemNo}</td>
                        <td class="text-left"><b>${item.itemTitle}</b></td>
                        <td>${startPrice}원<br><span style="color:#e74c3c; font-size:11px;">(${currentPrice}원)</span></td>
                        <td>${date}</td>
                        <td><span class="status-badge status-${item.status}">${item.status}</span></td>
                    </tr>`;
        });
    }
    html += `</tbody></table>`;

    // 🌟 페이징 버튼 (최대 5개 제한 로직)
    if (totalItems > 0) {
        html += `<div class="modal-pagination">`;
        const windowSize = 2;
        let startP = Math.max(1, currentModalPage - windowSize);
        let endP = Math.min(totalPages, currentModalPage + windowSize);

        if (startP > 1) {
            html += `<button class="page-btn" onclick="changeAuctionPage(1)">1</button>`;
            if (startP > 2) html += `<span class="page-dots">...</span>`;
        }
        for (let i = startP; i <= endP; i++) {
            html += `<button class="page-btn ${i === currentModalPage ? 'active' : ''}" onclick="changeAuctionPage(${i})">${i}</button>`;
        }
        if (endP < totalPages) {
            if (endP < totalPages - 1) html += `<span class="page-dots">...</span>`;
            html += `<button class="page-btn" onclick="changeAuctionPage(${totalPages})">${totalPages}</button>`;
        }
        html += `</div>`;
    }
    modalBody.innerHTML = html;
}

function changeAuctionPage(page) {
    currentModalPage = page;
    renderAuctionTable();
}

/* ==========================================
   📝 [기능 2] 작성 글 조회 (페이징 윈도우 적용)
   ========================================== */
function viewUserPosts() {
    const userNo = document.getElementById('targetUserNo').innerText;
    fetch(`${contextPath}/admin/userPostList?userNo=${userNo}`)
    .then(response => response.json())
    .then(list => {
        currentModalData = list;
        currentModalPage = 1;
        renderPostTable();
    })
    .catch(err => console.error("게시글 로드 실패:", err));
}

function renderPostTable() {
    const modalBody = document.querySelector('.modal-body');
    const list = currentModalData;
    const totalItems = list.length;
    const totalPages = Math.ceil(totalItems / itemsPerPage) || 1;

    const startIndex = (currentModalPage - 1) * itemsPerPage;
    const pageData = list.slice(startIndex, startIndex + itemsPerPage);

    let html = `<div class="sub-list-header">
                    <h4>작성 게시글 (<span style="color:#3498db;">${totalItems}</span>건)</h4>
                    <button class="btn-mini-back" onclick="restoreModalMenu()">🔙 뒤로가기</button>
                </div>
                <table class="modal-sub-table">
                    <thead>
                        <tr>
                            <th>No</th>
                            <th>제목</th>
                            <th>작성일</th>
                            <th>조회수</th>
                            <th>상태</th> </tr>
                    </thead>
                    <tbody>`;

    if (totalItems === 0) {
        html += `<tr><td colspan="4" style="text-align:center; padding:30px;">글 없음</td></tr>`;
    } else {
        pageData.forEach(post => {
            let date = new Date(post.boardDate).toLocaleDateString();
            
            let statusHtml = post.boardDelete === 'Y' 
                ? `<span class="status-badge status-N">삭제됨</span>` 
                : `<span class="status-badge status-Y">정상</span>`;

            html += `<tr>
                        <td>${post.boardNo}</td>
                        <td class="text-left">${post.boardTitle}</td>
                        <td>${date}</td>
                        <td>${post.views || 0}</td>
                        <td>${statusHtml}</td> </tr>`;
        });
    }
    html += `</tbody></table>`;

    // 페이징 버튼 영역 (아까와 동일)
    if (totalItems > 0) {
        html += `<div class="modal-pagination">`;
        const windowSize = 2;
        let startP = Math.max(1, currentModalPage - windowSize);
        let endP = Math.min(totalPages, currentModalPage + windowSize);

        for (let i = startP; i <= endP; i++) {
            html += `<button class="page-btn ${i === currentModalPage ? 'active' : ''}" onclick="changePostPage(${i})">${i}</button>`;
        }
        html += `</div>`;
    }
    modalBody.innerHTML = html;
}

function changePostPage(page) {
    currentModalPage = page;
    renderPostTable();
}