<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mypageCss/mypageSidebar.css">
<aside class="sidebar">
    <h2 class="sidebar-title">마이페이지</h2>
    <ul class="sidebar-menu">
		<li><a href="${pageContext.request.contextPath}/mypage/mypage.me">마이페이지 홈</a></li>
		<li><a href="${pageContext.request.contextPath}/mypage/wonList">낙찰받은 물품</a></li>
		<li><a href="${pageContext.request.contextPath}/mypage/faq">FAQ</a></li>
		<li><a href="${pageContext.request.contextPath}/mypage/bidList">입찰 현황</a></li>
		<li><a href="${pageContext.request.contextPath}/mypage/paymentList">거래 현황</a></li>
		<li><a href="${pageContext.request.contextPath}/mypage/wishList">찜 목록</a></li>
		<li><a href="${pageContext.request.contextPath}/mypage/reportList">신고 내역</a></li>
		<li><a href="${pageContext.request.contextPath}/mypage/reportedList">사고 내역</a></li>
		<li><a href="${pageContext.request.contextPath}/mypage/updateStatus">나의 정보</a></li>
    </ul>
</aside>