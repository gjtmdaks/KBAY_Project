<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>내 정보 수정</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mypageCss/mypage.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mypageCss/updateStatus.css">
</head>
<body>

<jsp:include page="/WEB-INF/views/common/header.jsp" />

<section class="mypage-container">
    <aside class="mypage-sidebar">
        <jsp:include page="mypageSidebar.jsp" />
    </aside>

    <main class="mypage-main">
        <h2>내 정보 수정</h2>

        <form action="${pageContext.request.contextPath}/mypage/updateStatus" method="post" onsubmit="return validateUpdate()">
            <table class="mypage-table">
                <tr>
                    <th>아이디</th>
                    <td>
                        <div class="input-group-row">
                            <input type="text" name="userId" value="${user.userId}" class="input-readonly" readonly>
                            <button type="button" class="btn-pwd-change" onclick="openPwdModal()">비밀번호 변경</button>
                        </div>
                    </td>
                </tr>
                <tr>
                    <th>이름</th>
                    <td>
                        <input type="text" name="userName" value="${user.userName}" class="input-readonly" readonly>
                    </td>
                </tr>
                <tr>
                    <th>주소</th>
                    <td>
                        <input type="text" name="userAddress" value="${user.userAddress}" placeholder="주소를 입력해주세요" maxlength="100">
                    </td>
                </tr>
                <tr>
                    <th>전화번호</th>
                    <td>
                        <input type="text" name="userPhone" value="${user.userPhone}" class="input-readonly" readonly>
                    </td>
                </tr>
               <tr>
    <th>이메일</th>
    <td>
        <div class="email-area">
            <input type="text" id="emailId" class="email-id-input">
            <span>@</span>
            <input type="text" id="emailDomain" class="email-domain-input">
            <select id="domainSelect" class="email-select" onchange="changeDomain(this)">
                <option value="direct">직접입력</option>
                <option value="naver.com">naver.com</option>
                <option value="gmail.com">gmail.com</option>
                <option value="daum.net">daum.net</option>
            </select>
            <input type="hidden" name="userEmail" id="userEmail" value="${user.userEmail}">
        </div>
    </td>
</tr>
                <tr>
                    <th>가입일</th>
                    <td>
                        <input type="text" value="<fmt:formatDate value='${user.userEnrollDate}' pattern='yyyy-MM-dd HH:mm:ss'/>" class="input-readonly" readonly>
                    </td>
                </tr>
            </table>

            <div class="footer-btn-wrapper">
                <div class="btn-left">
                    <button type="button" class="btn-delete" onclick="confirmDelete()">회원 탈퇴</button>
                </div>
                <div class="btn-area">
                    <button type="submit" class="btn-submit">수정하기</button>
                    <button type="button" class="btn-cancel" onclick="history.back()">취소</button>
                </div>
            </div>
        </form>
    </main>
</section>

<div id="pwdModal" class="modal">
    <div class="modal-content">
        <h3>비밀번호 수정</h3>
        <div class="pwd-input-group">
            <input type="password" id="currentPwd" placeholder="현재 비밀번호">
            <input type="password" id="newPwd" placeholder="새 비밀번호">
            <input type="password" id="confirmNewPwd" placeholder="새 비밀번호 확인">
        </div>
        <div class="modal-btns">
            <button type="button" class="btn-submit-small" onclick="updatePassword()">확인</button>
            <button type="button" class="btn-cancel-small" onclick="closePwdModal()">취소</button>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />

<script>
function changeDomain(el) {
    const domainInput = document.getElementById("emailDomain");
    if(el.value === "direct") {
        domainInput.value = "";
        domainInput.readOnly = false;
        domainInput.focus();
    } else {
        domainInput.value = el.value;
        domainInput.readOnly = true;
    }
}

function openPwdModal() { document.getElementById("pwdModal").style.display = "block"; }
function closePwdModal() { document.getElementById("pwdModal").style.display = "none"; }

document.addEventListener("DOMContentLoaded", function() {
    const fullEmail = document.getElementById("userEmail").value;
    if(fullEmail && fullEmail.includes("@")) {
        const parts = fullEmail.split("@");
        document.getElementById("emailId").value = parts[0];
        document.getElementById("emailDomain").value = parts[1];
    }
});

function validateUpdate() {
    const id = document.getElementById("emailId").value;
    const domain = document.getElementById("emailDomain").value;
    const domainRegex = /^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    if(!id || !domain) { alert("이메일을 입력해주세요."); return false; }
    if(!domainRegex.test(domain)) { alert("올바른 이메일 형식이 아닙니다."); return false; }
    document.getElementById("userEmail").value = id + "@" + domain;
    return true;
}

function updatePassword() {
    const currentPwd = document.getElementById("currentPwd").value;
    const newPwd = document.getElementById("newPwd").value;
    const confirm = document.getElementById("confirmNewPwd").value;
    if(!currentPwd || !newPwd || !confirm) { alert("항목을 모두 입력하세요."); return; }
    if(newPwd !== confirm) { alert("새 비밀번호 확인이 일치하지 않습니다."); return; }

    fetch("${pageContext.request.contextPath}/mypage/changePwd", {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: "currentPwd=" + currentPwd + "&newPwd=" + newPwd
    })
    .then(res => res.json())
    .then(data => {
        if(data.result === "SUCCESS") {
            alert("비밀번호가 변경되었습니다.");
            closePwdModal();
        } else {
            alert(data.message || "현재 비밀번호가 틀립니다.");
        }
    });
}
function confirmDelete() { 
    Swal.fire({
        title: '정말로 탈퇴하시겠습니까?',
        text: "탈퇴 시 모든 정보가 삭제되며 복구할 수 없습니다.",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#aaa',
        confirmButtonText: '네, 진행하겠습니다',
        cancelButtonText: '취소'
    }).then((result) => {
        if (result.isConfirmed) {
            Swal.fire({
                title: '신중히 선택해주시기 바랍니다..',
                text: "이 작업은 되돌릴 수 없습니다.",
                icon: 'error',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#aaa',
                confirmButtonText: '최종 탈퇴',
                cancelButtonText: '한 번 더 생각해보기'
            }).then((finalResult) => {
                if (finalResult.isConfirmed) {
                    location.href = "${pageContext.request.contextPath}/mypage/delete"; 
                }
            });
        }
    });
}
</script>
</body>
</html>