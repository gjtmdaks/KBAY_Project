function openReportPopup(type, no) {
    document.getElementById("reportPopup").style.display = "block";
    document.getElementById("targetType").value = type;
    document.getElementById("targetNo").value = no;
}

function closeReportPopup() {
    document.getElementById("reportPopup").style.display = "none";
}

function submitReport() {

    const selected = document.querySelector('input[name="reportCdNo"]:checked');

    if (!selected) {
        alert("신고 사유를 선택해주세요.");
        return;
    }

    // 🔥 팝업2 (확인창)
    if (!confirm("정말 신고하시겠습니까?")) {
        return;
    }

    const data = {
        reportCdNo: selected.value,
        targetType: document.getElementById("targetType").value,
        targetNo: document.getElementById("targetNo").value
    };

    fetch("/kbay/report/insert", {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify(data)
    })
    .then(res => res.text())
    .then(res => {
        if (res === "success") {
            alert("신고가 접수되었습니다.");
            closeReportPopup();
        } else {
            alert("신고 실패");
        }
    });
}