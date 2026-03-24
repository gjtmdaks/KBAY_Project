<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>본인인증</title>

<style>
body {
    font-family: 'Noto Sans KR', sans-serif;
    background: #f5f6f7;
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
}

.verify-box {
    background: white;
    padding: 30px;
    width: 350px;
    border-radius: 10px;
    box-shadow: 0 4px 10px rgba(0,0,0,0.1);
}

.verify-box h2 {
    margin-bottom: 20px;
    text-align: center;
}

.input-group {
    margin-bottom: 15px;
}

.input-group input {
    width: 100%;
    padding: 10px;
    font-size: 14px;
}

.btn {
    width: 100%;
    padding: 12px;
    background: #03c75a;
    color: white;
    border: none;
    cursor: pointer;
    font-weight: bold;
}

.btn:hover {
    background: #02b350;
}
</style>
</head>

<body>

<div class="verify-box">
    <h2>본인인증</h2>

    <form id="verifyForm">
        <div class="input-group">
            <input type="text" name="name" placeholder="이름" required>
        </div>

        <div class="input-group">
            <input type="text" name="rrn1" placeholder="주민번호 앞자리 (6자리)" maxlength="6" required>
        </div>

        <div class="input-group">
            <input type="password" name="rrn2" placeholder="주민번호 뒷자리 (7자리)" maxlength="7" required>
        </div>

        <button type="button" class="btn" onclick="verify()">인증하기</button>
    </form>
</div>

<script>
function verify() {
    const form = document.getElementById("verifyForm");

    const data = {
        name: form.name.value,
        rrn1: form.rrn1.value,
        rrn2: form.rrn2.value
    };

    fetch('${pageContext.request.contextPath}/member/verify', {
        method: "POST",
        headers: {"Content-Type": "application/json"},
        body: JSON.stringify(data)
    })
    .then(res => res.text())
    .then(result => {
        if(result === "success") {
            alert("본인인증 완료");

            // 부모창 새로고침
            if(window.opener) {
		        // 🔥 이거 추가
		        window.opener.isVerified = true;
		
		        window.opener.location.reload();
		    }

            // 팝업 닫기
            window.close();
        } else {
            alert("인증 실패");
        }
    });
}
</script>

</body>
</html>