<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/adminCss/admin.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<div class="admin-wrap">
    <jsp:include page="/WEB-INF/views/admin/adminSidebar.jsp" />

    <main class="main-content">
        
        <div class="info-box">
            <div class="info-title"><sec:authentication property="principal.userName" /> 관리자님, 반갑습니다.</div>
            <ul class="info-list">
                <li><i class="fas fa-user-circle"></i> 현재 총 가입자 : <strong>${todayNewMembers}</strong> 명</li>
                <li><i class="fas fa-gavel"></i> 현재 진행 중인 경매 건수 : <strong>${activeAuctionsCount}</strong> 건</li>
                <li><i class="fas fa-exclamation-triangle"></i> 미처리 신고 내역 : <strong>${unprocessedReportsCount}</strong> 건</li>
            </ul>
        </div>

        <div class="dashboard-grid">
            <div class="section-box">
                <div class="section-title">유저 관리</div>
                <div class="btn-grid">
                    <a href="${contextPath}/admin/memberList" class="square-btn">
                        <i class="far fa-id-badge"></i>
                        <span>회원 조회/수정</span>
                    </a>
                    <a href="${contextPath}/admin/adminReportList" class="square-btn">
                        <i class="fas fa-comment-dots"></i>
                        <span>신고/문의 내역 처리</span>
                    </a>
                    <a href="${contextPath}/admin/adminPaymentList" class="square-btn">
                        <i class="fas fa-shield-alt"></i>
                        <span>회원 결제<br>내역 관리</span>
                    </a>
                </div>
            </div>

            <div class="section-box">
                <div class="section-title">경매 및 상품 관리</div>
                <div class="btn-grid">
                    <a href="${contextPath}/admin/adminAuctionCancel" class="square-btn">
                        <i class="far fa-file-image"></i>
                        <span>경매 강제<br>종료 및 취소</span>
                    </a>
                    <a href="${contextPath}/admin/adminSuccession" class="square-btn">
                        <i class="fas fa-file-signature"></i>
                        <span>낙찰 취하 신청 및<br>낙찰 승계관리</span>
                    </a>
                    <a href="${contextPath}/admin/adminBidLog" class="square-btn">
                        <i class="fas fa-chart-line"></i>
                        <span>입찰 로그 확인</span>
                    </a>
                </div>
            </div>
        </div>

    </main>
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>