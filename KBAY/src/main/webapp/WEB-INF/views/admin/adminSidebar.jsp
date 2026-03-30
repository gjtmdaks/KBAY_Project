<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/adminCss/adminSidebar.css">
<aside class="sidebar">
    <h2 class="sidebar-title">
    <a href="${pageContext.request.contextPath}/admin/adminPage.me">관리자페이지</a></h2>
    <ul class="sidebar-menu">
        <li><a href="${pageContext.request.contextPath}/admin/memberList">회원 조회/수정</a></li>
        <li class="has-submenu">
            <a href="javascript:void(0);" class="submenu-toggle">
                신고/문의 관리 <span class="arrow">▼</span>
            </a>
            <ul class="submenu">
                <li><a href="${pageContext.request.contextPath}/admin/adminReportList">신고 내역 처리</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/adminInquiryList">문의 내역 처리</a></li> 
            </ul>
        </li>
        <li><a href="${pageContext.request.contextPath}/admin/adminPaymentList">회원 결제 내역 관리</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/adminAuctionCancel">경매 강제 종료 및 취소</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/adminSuccession">낙찰 취하 신청 및 낙찰 승계관리</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/adminBidLog">입찰 로그 확인</a></li>
    </ul>
</aside>
<script src="${pageContext.request.contextPath}/resources/js/adminJs/adminSidebar.js"></script>