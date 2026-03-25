// 1. 유저 행 클릭 시 모달창 열기
function openUserModal(userNo, userId) {
    const modal = document.getElementById('userModal');
    const modalBody = document.getElementById('modalBodyInfo');
    
    // 모달 내용 렌더링
    modalBody.innerHTML = `
        <div style="margin-bottom: 15px;">
            <p style="margin: 5px 0;"><strong>회원 번호:</strong> ${userNo}</p>
            <p style="margin: 5px 0;"><strong>아이디:</strong> ${userId}</p>
        </div>
        <hr style="border:0; border-top:1px solid #eee; margin: 15px 0;">
        <p style="color: #666; font-size: 14px;">여기에 회원의 주소, 상세 포인트, 정지 여부 변경 폼 등<br>다양한 정보를 채워 넣을 예정입니다.</p>
    `;

    // 모달 보이기
    modal.style.display = 'flex';
}

// 2. 닫기 버튼 누를 때
function closeModal() {
    document.getElementById('userModal').style.display = 'none';
}

// 3. 어두운 배경 클릭 시 닫기
window.onclick = function(event) {
    const modal = document.getElementById('userModal');
    if (event.target == modal) {
        modal.style.display = 'none';
    }
}