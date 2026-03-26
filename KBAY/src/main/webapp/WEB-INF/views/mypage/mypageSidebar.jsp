<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mypageCss/mypageSidebar.css">
<aside class="sidebar">
    <h2 class="sidebar-title">
    <a href="${pageContext.request.contextPath}/mypage/mypage.me">관리자페이지</a></h2>
    <ul class="sidebar-menu">
        <li><a href="${pageContext.request.contextPath}/mypage/memberList">회원 조회/수정</a></li>
        <li><a href="${pageContext.request.contextPath}/mypage/paymentList">회원 결제 내역 관리</a></li>
        <li><a href="${pageContext.request.contextPath}/mypage/auctionCancel">경매 강제 종료 및 취소</a></li>
        <li><a href="${pageContext.request.contextPath}/mypage/succession">낙찰 취하 신청 및 낙찰 승계관리</a></li>
        <li><a href="${pageContext.request.contextPath}/mypage/bidLog">입찰 로그 확인</a></li>
    </ul>
</aside>