document.addEventListener('DOMContentLoaded', function() {
    
    const modal = document.getElementById('memberModal');
    const tableBody = document.querySelector('.member-table tbody');
    
    // 모달 닫기 버튼들
    const closeBtns = [
        document.getElementById('closeModalTop'),
        document.getElementById('closeModalBottom')
    ];

    // 메뉴의 원래 모습을 저장할 전역 변수 (뒤로가기/닫기 시 복구용)
    let originalModalBody = "";

    if (tableBody) {
        tableBody.addEventListener('click', function(e) {
            const targetRow = e.target.closest('.member-row');
            
            if (targetRow) {
                const userNo = targetRow.getAttribute('data-user-no');
                
                // [AJAX] 유저 상세 정보 불러오기
                fetch(`${contextPath}/admin/memberDetail?userNo=${userNo}`, {
                    method: 'GET'
                })
                .then(response => {
                    if(!response.ok) throw new Error("데이터 응답 실패");
                    return response.json();
                })
                .then(member => {
                    // 데이터 꽂아넣기
                    document.getElementById('targetUserNo').innerText = member.userNo;
                    document.getElementById('targetUserName').innerText = member.userName;
                    document.getElementById('targetUserId').innerText = "@" + member.userId;
                    
                    // 현재 메뉴 상태(5개 버튼)를 백업해둡니다.
                    originalModalBody = document.querySelector('.modal-body').innerHTML;
                    
                    if (modal) modal.classList.add('show');
                })
                .catch(err => {
                    console.error("데이터 로드 실패:", err);
                    alert("회원 정보를 불러오는 데 실패했습니다.");
                });
            }
        });
    }

    // 모달 복구 함수 (표 -> 메뉴판)
    window.restoreModalMenu = function() {
        const modalBody = document.querySelector('.modal-body');
        if (originalModalBody) {
            modalBody.innerHTML = originalModalBody;
        }
    };

    // 모달 닫기 로직 (복구 함수 포함)
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

// 경매 내역 조회
// 페이지 계산을 위한 전역 변수 추가 (맨 위에 추가하거나 기존 변수 밑에 두세요)
let originalModalBody = ""; 

// (아까 추가했던 페이징 변수들도 여기 같이 두시면 좋습니다)
let currentModalData = [];
let currentModalPage = 1;
const itemsPerPage = 5;

// ==========================================
// 1. 서버에서 경매 데이터 가져오기
// ==========================================
function viewUserAuctions() {
    const userNo = document.getElementById('targetUserNo').innerText;
    const modalBody = document.querySelector('.modal-body');
    
    if (!originalModalBody) {
        originalModalBody = modalBody.innerHTML;
    }

    fetch(`${contextPath}/admin/userItemList?userNo=${userNo}`, { method: 'GET' })
    .then(response => response.json())
    .then(list => {
        currentModalData = list; // 🌟 전체 데이터를 안전하게 백업!
        currentModalPage = 1;    // 무조건 1페이지부터 시작
        renderAuctionTable();    // 🌟 화면 그리는 함수 출동!
    })
    .catch(err => console.error("데이터 로드 실패:", err));
}

// ==========================================
// 2. 데이터를 잘라서 표와 페이징 버튼 그리기
// ==========================================
function renderAuctionTable() {
    const modalBody = document.querySelector('.modal-body');
    const list = currentModalData;
    const totalItems = list.length;
    const totalPages = Math.ceil(totalItems / itemsPerPage) || 1; // 총 페이지 수 계산

    // 🌟 100개 데이터 중 1~5번, 6~10번... 이렇게 자르기!
    const startIndex = (currentModalPage - 1) * itemsPerPage;
    const endIndex = startIndex + itemsPerPage;
    const pageData = list.slice(startIndex, endIndex);

    let html = `<div class="sub-list-header">
                    <h4>경매 등록 내역 (<span style="color:#4CAF50;">${totalItems}</span>건)</h4>
                    <button class="btn-mini-back" onclick="restoreModalMenu()">🔙 뒤로가기</button>
                </div>
                <table class="modal-sub-table">
                    <thead>
                        <tr>
                            <th>No</th>
                            <th>경매 제목</th>
                            <th>시작가(현재가)</th>
                            <th>등록일</th>
                            <th>상태</th>
                        </tr>
                    </thead>
                    <tbody>`;

    if (totalItems === 0) {
        html += `<tr><td colspan="5" style="padding:30px 0; color:#888; text-align:center;">등록한 경매가 없습니다.</td></tr>`;
    } else {
        // 자른 데이터(pageData)만 반복문 돌리기
        pageData.forEach(item => {
            // 🌟 잃어버렸던 가격 포맷 복구!
            let startPrice = item.startPrice ? item.startPrice.toLocaleString() : '0';
            let currentPrice = item.currentPrice ? item.currentPrice.toLocaleString() : '0';

            // 🌟 날짜 예쁘게 만들기
            let dateObj = new Date(item.createAt);
            let formattedDate = dateObj.getFullYear() + '.' + 
                                String(dateObj.getMonth() + 1).padStart(2, '0') + '.' + 
                                String(dateObj.getDate()).padStart(2, '0');

            html += `<tr>
                        <td>${item.itemNo}</td>
                        <td class="text-left" style="font-weight:bold;">${item.itemTitle}</td>
                        <td>
                            ${startPrice}원<br>
                            <span style="color:#e74c3c; font-size:11px;">(${currentPrice}원)</span>
                        </td>
                        <td>${formattedDate}</td>
                        <td><span class="status-badge status-${item.status}">${item.status}</span></td>
                     </tr>`;
        });
    }
    html += `</tbody></table>`;

    // ==========================================
    // 3. 모달용 미니 페이징 버튼 달기
    // ==========================================
    if (totalItems > 0) {
        html += `<div class="modal-pagination">`;
        for (let i = 1; i <= totalPages; i++) {
            if (i === currentModalPage) {
                // 현재 페이지면 까만색으로 진하게!
                html += `<button class="page-btn active">${i}</button>`;
            } else {
                // 다른 페이지면 클릭 시 넘어가는 버튼!
                html += `<button class="page-btn" onclick="changeAuctionPage(${i})">${i}</button>`;
            }
        }
        html += `</div>`;
    }

    modalBody.innerHTML = html;
}

// ==========================================
// 4. 페이지 버튼 클릭 시 실행되는 함수
// ==========================================
function changeAuctionPage(page) {
    currentModalPage = page; // 페이지 번호 바꾸고
    renderAuctionTable();    // 다시 그리기!
}

// 작성 글 조회
function viewUserPosts() {
    const userNo = document.getElementById('targetUserNo').innerText;
    const modalBody = document.querySelector('.modal-body');
    
    fetch(`${contextPath}/admin/userPostList?userNo=${userNo}`, { method: 'GET' })
    .then(response => response.json())
    .then(list => {
        let html = `<div class="sub-list-header">
                        <h4>작성 게시글 (<span style="color:#3498db;">${list.length}</span>건)</h4>
                        <button class="btn-mini-back" onclick="restoreModalMenu()">🔙 뒤로가기</button>
                    </div>
                    <table class="modal-sub-table">
                        <thead>
                            <tr><th>No</th><th>제목</th><th>작성일</th><th>조회수</th></tr>
                        </thead>
                        <tbody>`;
        if (list.length === 0) {
            html += `<tr><td colspan="4">작성한 글이 없습니다.</td></tr>`;
        } else {
            list.forEach(post => {
                let date = new Date(post.boardDate).toLocaleDateString();
                html += `<tr>
                            <td>${post.boardNo}</td>
                            <td class="text-left">${post.boardTitle}</td>
                            <td>${date}</td>
                            <td>${post.views}</td>
                         </tr>`;
            });
        }
        html += `</tbody></table>`;
        modalBody.innerHTML = html;
    });
}