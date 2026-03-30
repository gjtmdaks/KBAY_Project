let currentTargetType = "";
let currentTargetNo = 0;
    
// 모달 열기 (비동기 통신 fetch 사용)
function openReportDetail(targetType, targetNo) {
    // 다음에 처리할 때 쓰기 위해 변수에 저장!
    currentTargetType = targetType;
    currentTargetNo = targetNo;
    
    // 1. 컨트롤러에 데이터 요청 (JSON 주세요!)
    fetch(contextPath + "/admin/reportDetail?targetType=" + targetType + "&targetNo=" + targetNo)
    .then(response => response.json())
    .then(data => {
        // 2. 받아온 데이터를 모달 화면에 쏙쏙 채워넣기
        const info = data.targetInfo;
        
        // DB 컬럼명 대소문자 방어 로직 (TITLE, CONTENT, WRITER)
        document.getElementById("modalTitle").innerText = info.TARGET_TITLE || info.target_title || "제목 없음";
        document.getElementById("modalContent").innerText = info.TARGET_CONTENT || info.target_content || "내용 없음";
        document.getElementById("modalWriter").innerText = "작성자 : " + (info.TARGET_WRITER || info.target_writer || "알 수 없음");
        
        // 총 통계 숫자
        document.getElementById("modalTotal").innerText = data.totalReportCount;
        
        // 사유별 통계 리스트 그리기
        const statsUl = document.getElementById("modalStatsList");
        statsUl.innerHTML = ""; // 기존에 있던 텍스트 싹 지우기
        
        if(data.reportStats && data.reportStats.length > 0) {
            data.reportStats.forEach(stat => {
                // 카테고리 이름과 카운트 (대소문자 방어)
                let category = stat.CATEGORYNAME || stat.categoryName || stat.CATEGORY_NAME;
                let count = stat.REPORT_COUNT || stat.reportCount || stat.REPORTCOUNT;
                statsUl.innerHTML += `<li>${category} : <b>${count}</b>건</li>`;
            });
        } else {
            statsUl.innerHTML = "<li>상세 통계가 없습니다.</li>";
        }
        
        // 3. 쨘! 하고 모달창 보여주기
        document.getElementById("reportModal").style.display = "flex";
        
    })
    .catch(error => {
        console.error("데이터 불러오기 실패:", error);
        alert("상세 정보를 불러오지 못했습니다.");
    });
}

// 모달 닫기
function closeModal() {
    document.getElementById("reportModal").style.display = "none";
}

// 🚨 진짜 일괄 처리 비동기 통신 로직
function processReport(action) {
    // 1. 확인 창 띄우기
    let confirmMsg = (action === 'DELETE') 
        ? "해당 글을 강제 삭제(블라인드)하고 신고를 모두 완료 처리하시겠습니까?" 
        : "글은 정상 유지하고 신고 내역만 완료 처리하시겠습니까?";
        
    if(!confirm(confirmMsg)) return; // 취소 누르면 중단

    // 2. 백엔드 컨트롤러에 POST 요청 보내기
    fetch(contextPath + "/admin/processReport", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: `targetType=${currentTargetType}&targetNo=${currentTargetNo}&action=${action}`
    })
    .then(response => response.text())
    .then(result => {
        if(result === "SUCCESS") {
            alert("처리가 완료되었습니다.");
            closeModal();
            location.reload(); // 깔끔하게 화면 새로고침해서 표 갱신!
        } else {
            alert("처리 중 오류가 발생했습니다.");
        }
    })
    .catch(err => console.error(err));
}