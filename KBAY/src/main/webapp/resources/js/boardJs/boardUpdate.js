// 기존 첨부파일 삭제(✖) 버튼 클릭 시 UI 변경 함수
function toggleDelete(checkbox) {
    // 클릭된 체크박스가 속한 리스트(li) 태그를 찾습니다.
    const li = checkbox.closest('.existing-file-item');
    const mark = li.querySelector('.delete-mark');
    
    if(checkbox.checked) {
        li.style.opacity = '0.4';
        li.style.backgroundColor = '#f0f0f0';
        mark.innerText = '↺'; 
        mark.parentElement.style.backgroundColor = '#e1e1e1';
        mark.parentElement.style.color = '#333';
        mark.parentElement.title = "삭제 취소";
    } else {
        li.style.opacity = '1';
        li.style.backgroundColor = '#fdfdfd';
        mark.innerText = '✖';
        mark.parentElement.style.backgroundColor = '#ffeef0';
        mark.parentElement.style.color = '#ff4d4f';
        mark.parentElement.title = "이 파일 삭제";
    }
}