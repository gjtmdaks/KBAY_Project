document.addEventListener('DOMContentLoaded', function() {
    
    // 1. 필요한 요소들 찾아오기
    const memberRows = document.querySelectorAll('.member-row'); // 유저 테이블의 각 줄
    const modal = document.getElementById('memberModal'); // 까만 배경을 포함한 모달 전체
    const closeBtnTop = document.getElementById('closeModalTop'); // 상단 X 버튼
    const closeBtnBottom = document.getElementById('closeModalBottom'); // 하단 닫기 버튼

    // 2. 테이블의 유저 줄(Row)을 클릭했을 때 모달 열기
    memberRows.forEach(row => {
        row.addEventListener('click', function() {
            // 클릭한 유저의 번호를 가져옵니다 (나중에 AJAX로 상세정보 불러올 때 씁니다!)
            const userNo = this.getAttribute('data-user-no');
            console.log("클릭한 유저 번호:", userNo); 
            
            // 모달 열기!
            modal.classList.add('show');
        });
    });

    // 3. 모달 닫기 기능 묶음
    function closeModal() {
        modal.classList.remove('show');
    }

    closeBtnTop.addEventListener('click', closeModal);
    closeBtnBottom.addEventListener('click', closeModal);

    // 4. 모달 바깥쪽(까만 반투명 배경)을 클릭해도 모달 닫히게 하기
    modal.addEventListener('click', function(e) {
        if (e.target === modal) { // 알맹이(modal-content)가 아니라 진짜 바깥쪽 배경을 눌렀을 때만!
            closeModal();
        }
    });
});