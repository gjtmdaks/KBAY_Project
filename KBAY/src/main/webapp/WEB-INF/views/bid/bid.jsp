<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/bidCss/bid.css">
<!-- 1. 입찰 확인 모달 -->
<div id="confirmModal" class="modal">
    <div class="modal-content">
        <h3>입찰 확인</h3>
        <p><strong id="confirmPrice"></strong>원에 입찰하시겠습니까?</p>
        <p class="notice">
            • 입찰 후 취소가 불가능합니다.<br>
            • 최고가 입찰 시 낙찰될 수 있습니다.
        </p>

        <div class="modal-btn">
            <button id="confirmBtn">입찰하기</button>
            <button id="cancelBtn">취소</button>
        </div>
    </div>
</div>

<!-- 2. 1등 모달 -->
<div id="firstModal" class="modal">
    <div class="modal-content">
        <h3>🎉 현재 최고 입찰자입니다</h3>
        <p>입찰이 정상적으로 완료되었습니다.</p>
        <button onclick="closeModal('firstModal')">확인</button>
    </div>
</div>

<!-- 3. 2등 이하 모달 -->
<div id="secondModal" class="modal">
    <div class="modal-content">
        <h3>입찰 완료</h3>
        <p>현재 최고 입찰자가 아닙니다.</p>
        <p>더 높은 금액으로 다시 입찰해보세요.</p>
        <button onclick="closeModal('secondModal')">확인</button>
    </div>
</div>