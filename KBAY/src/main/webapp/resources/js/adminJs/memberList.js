/* 전역 변수 */
let originalModalBody = "";  // 메뉴판 복구용
let currentModalData = [];   // 서버 데이터 저장용
let currentModalPage = 1;    // 현재 페이지 번호
const itemsPerPage = 5;      // 한 페이지당 보여줄 개수

let selectedUserNo = "";
let selectedUserName = "";

// 공통 페이징 함수
function getPaginationHtml(totalPages, currentPage, actionName) {
    if (totalPages <= 1) return ""; // 페이지가 1개뿐이면 버튼 안 만듦

    let html = `<div class="modal-pagination">`;
    const windowSize = 2; // 현재 페이지 앞뒤로 보여줄 개수
    let startP = Math.max(1, currentPage - windowSize);
    let endP = Math.min(totalPages, currentPage + windowSize);

    // [처음] 버튼과 '...'
    if (startP > 1) {
        html += `<button class="page-btn" onclick="${actionName}(1)">1</button>`;
        if (startP > 2) html += `<span class="page-dots">...</span>`;
    }

    // 숫자 버튼들
    for (let i = startP; i <= endP; i++) {
        const activeClass = (i === currentPage) ? 'active' : '';
        html += `<button class="page-btn ${activeClass}" onclick="${actionName}(${i})">${i}</button>`;
    }

    // '...'과 [끝] 버튼
    if (endP < totalPages) {
        if (endP < totalPages - 1) html += `<span class="page-dots">...</span>`;
        html += `<button class="page-btn" onclick="${actionName}(${totalPages})">${totalPages}</button>`;
    }

    html += `</div>`;
    return html;
}

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

/* 기능 1 경매 내역 조회 */
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
	
	// 숫자 바 불러오기
    html += getPaginationHtml(totalPages, currentModalPage, 'changeAuctionPage');
    
    modalBody.innerHTML = html;
}

function changeAuctionPage(page) {
    currentModalPage = page;
    renderAuctionTable();
}

/* [기능 2] 작성 글 조회 */
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
                            <th>상태</th> 
                        </tr>
                    </thead>
                    <tbody>`;

    if (totalItems === 0) {
        html += `<tr><td colspan="5" style="text-align:center; padding:30px;">글 없음</td></tr>`;
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
                        <td>${statusHtml}</td> 
                    </tr>`;
        });
    }
    html += `</tbody></table>`;

    // 숫자바 다이어트 성공
    html += getPaginationHtml(totalPages, currentModalPage, 'changePostPage');
    
    modalBody.innerHTML = html;
}

function changePostPage(page) {
    currentModalPage = page;
    renderPostTable();
}

/* [기능 3] 작성 댓글 조회 */
function viewUserComments() {
    const userNo = document.getElementById('targetUserNo').innerText;
    
    // 메뉴 복구 로직 누락 방지 (originalModalBody 체크 추가)
    const modalBody = document.querySelector('.modal-body');
    if (!originalModalBody) {
        originalModalBody = modalBody.innerHTML;
    }

    fetch(`${contextPath}/admin/userReplyList?userNo=${userNo}`)
    .then(response => {
        if(!response.ok) throw new Error("댓글 로드 실패");
        return response.json();
    })
    .then(list => {
        currentModalData = list;
        currentModalPage = 1;
        renderReplyTable();
    })
    .catch(err => console.error(err));
}

function renderReplyTable() {
    const modalBody = document.querySelector('.modal-body');
    const list = currentModalData;
    const totalItems = list.length;
    const totalPages = Math.ceil(totalItems / itemsPerPage) || 1;

    const startIndex = (currentModalPage - 1) * itemsPerPage;
    const pageData = list.slice(startIndex, startIndex + itemsPerPage);

    let html = `<div class="sub-list-header">
                    <h4>작성 댓글 (<span style="color:#9b59b6;">${totalItems}</span>건)</h4>
                    <button class="btn-mini-back" onclick="restoreModalMenu()">🔙 뒤로가기</button>
                </div>
                <table class="modal-sub-table">
                    <thead>
                        <tr>
                            <th width="10%">No</th>
                            <th width="15%">글번호</th>
                            <th width="45%">댓글 내용</th>
                            <th width="20%">작성일</th>
                            <th width="10%">상태</th>
                        </tr>
                    </thead>
                    <tbody>`;

    if (totalItems === 0) {
        html += `<tr><td colspan="5" style="text-align:center; padding:30px;">작성한 댓글이 없습니다.</td></tr>`;
    } else {
        pageData.forEach(reply => {
            let date = new Date(reply.replyDate).toLocaleDateString();
            let statusHtml = reply.replyDelete === 'Y' 
                ? `<span class="status-badge status-N">삭제</span>` 
                : `<span class="status-badge status-Y">정상</span>`;

            html += `<tr>
                        <td>${reply.replyNo}</td>
                        <td>${reply.boardNo}</td>
                        <td class="text-left" style="word-break: break-all;">${reply.replyContent}</td>
                        <td>${date}</td>
                        <td>${statusHtml}</td>
                    </tr>`;
        });
    }
    html += `</tbody></table>`;

	// 숫자바 다이어트 성공(나중에 이거 보고 하기)
    html += getPaginationHtml(totalPages, currentModalPage, 'changeReplyPage');
    
    modalBody.innerHTML = html;
}

function changeReplyPage(page) {
    currentModalPage = page;
    renderReplyTable();
}

/* 🚨 [기능 4] 신고 내역 및 제재 처리 */
function viewUserReports() {
    // 🌟 화면이 날아가기 전에 미리 전역 변수에 저장! (없으면 기존 값 유지)
    if(document.getElementById('targetUserNo')) {
        selectedUserNo = document.getElementById('targetUserNo').innerText;
        selectedUserName = document.getElementById('targetUserName').innerText;
    }

    const modalBody = document.querySelector('.modal-body');
    if (!originalModalBody) { originalModalBody = modalBody.innerHTML; }

    fetch(`${contextPath}/admin/userReportList?userNo=${selectedUserNo}`)
    .then(response => response.json())
    .then(list => {
        currentModalData = list;
        currentModalPage = 1;
        renderReportTable();
    })
    .catch(err => console.error(err));
}

function renderReportTable() {
    const modalBody = document.querySelector('.modal-body');
    const list = currentModalData;
    const totalItems = list.length;
    
    const userName = selectedUserName; 
    
    const totalPages = Math.ceil(totalItems / itemsPerPage) || 1;
    const startIndex = (currentModalPage - 1) * itemsPerPage;
    const pageData = list.slice(startIndex, startIndex + itemsPerPage);

    // 1. 컨트롤 패널 (정지 & 탈퇴 UI)
    let html = `
        <div class="sub-list-header" style="flex-direction: column; align-items: flex-start; gap: 10px; border-bottom: none; padding-bottom: 0;">
            <div style="display:flex; justify-content:space-between; width:100%; align-items:center; border-bottom: 2px solid #e74c3c; padding-bottom: 10px;">
                <h4>🚨 <span style="color:#e74c3c;">${userName}</span>님이 받은 신고 내역 (총 ${totalItems}건)</h4>
                <button class="btn-mini-back" onclick="restoreModalMenu()">🔙 뒤로가기</button>
            </div>
            
            <div style="background-color: #fff5f5; border: 1px solid #ffccd5; border-radius: 8px; padding: 15px; width: 100%; display: flex; align-items: center; gap: 10px; box-sizing: border-box;">
                <span style="font-weight: bold; color: #c0392b;">🔨 제재 처리:</span>
                
                <select id="suspendSelect" onchange="toggleCustomInput(this)" style="padding: 6px; border-radius: 4px; border: 1px solid #ccc;">
                    <option value="1">1일 정지</option>
                    <option value="7">7일 정지</option>
                    <option value="30">30일 정지</option>
                    <option value="custom">직접 입력 (최대 30일)</option>
                </select>
                
                <input type="number" id="customDays" min="1" max="30" placeholder="일수" style="display: none; width: 60px; padding: 6px; border-radius: 4px; border: 1px solid #ccc;">
                
                <button onclick="suspendUser()" style="background: #e67e22; color: white; border: none; padding: 7px 15px; border-radius: 4px; cursor: pointer; font-weight: bold;">정지 부여</button>
                <button onclick="banUser()" style="background: #c0392b; color: white; border: none; padding: 7px 15px; border-radius: 4px; cursor: pointer; font-weight: bold; margin-left: auto;">계정 탈퇴(영구정지)</button>
            </div>
        </div>`;

    // 2. 신고 내역 테이블 
    html += `<table class="modal-sub-table">
                <thead>
                    <tr>
                        <th width="15%">신고 번호</th>
                        <th width="20%">대상 구분</th>
                        <th width="20%">대상 번호</th>
                        <th width="30%">신고 유형</th>
                        <th width="15%">상태</th>
                    </tr>
                </thead>
                <tbody>`;

    if (totalItems === 0) {
        html += `<tr><td colspan="5" style="text-align:center; padding:30px;">받은 신고가 없습니다. ✨</td></tr>`;
    } else {
        pageData.forEach(report => {
            html += `<tr>
                        <td>${report.reportNo}</td>
                        <td><span class="user-badge" style="background:#e3f2fd; color:#1976d2;">${report.targetType}</span></td>
                        <td><b>No. ${report.targetNo}</b></td>
                        <td class="text-left">${report.reportCategoryName}</td> <td><span class="status-badge status-${report.status}">${report.status}</span></td>
                    </tr>`;
        });
    }
    html += `</tbody></table>`;

    // 3. 공통 페이징 함수 호출
    html += getPaginationHtml(totalPages, currentModalPage, 'changeReportPage');
    modalBody.innerHTML = html;
}

function changeReportPage(page) {
    currentModalPage = page;
    renderReportTable();
}

/* 🛠️ [제재 액션 함수들] */
window.toggleCustomInput = function(selectObj) {
    document.getElementById('customDays').style.display = (selectObj.value === 'custom') ? 'inline-block' : 'none';
};

window.suspendUser = function() {
    // 🌟 화면 요소 대신 전역 변수에서 바로 꺼내오기!
    const userNo = selectedUserNo;
    const userName = selectedUserName;
    
    const selectValue = document.getElementById('suspendSelect').value;
    let days = selectValue === 'custom' ? document.getElementById('customDays').value : selectValue;

    if (!days || days < 1 || days > 30) {
        alert("1일에서 30일 사이의 숫자를 입력해 주세요.");
        return;
    }

    if(confirm(`${userName}님에게 ${days}일 정지를 부여하시겠습니까?\n(지금부터 적용됩니다)`)) {
        fetch(`${contextPath}/admin/suspendUser`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: `userNo=${userNo}&days=${days}`
        })
        .then(response => response.text())
        .then(result => {
            if(result === 'success') {
                alert(`${userName}님에게 ${days}일 정지가 완료되었습니다.`);
                restoreModalMenu();
            } else {
                alert("정지 처리에 실패했습니다.");
            }
        })
        .catch(err => console.error(err));
    }
};

window.banUser = function() {
    // 전역 변수 사용함
    const userNo = selectedUserNo;
    const userName = selectedUserName;

    if(confirm(`⚠️ 정말로 ${userName}님의 계정을 강제 탈퇴 처리하시겠습니까?\n(이 작업은 되돌릴 수 없습니다!)`)) {
        fetch(`${contextPath}/admin/deleteUser`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: `userNo=${userNo}`
        })
        .then(response => response.text())
        .then(result => {
            if(result === 'success') {
                alert(`${userName}님의 계정이 영구 정지(탈퇴) 처리되었습니다.`);
                location.reload(); 
            } else {
                alert("탈퇴 처리에 실패했습니다.");
            }
        })
        .catch(err => console.error(err));
    }
};