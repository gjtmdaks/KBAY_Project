<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<header>
	<div class="container header-inner">
		<h1 class="logo">
			<a href="${contextPath}">K-Bay <span>Auction</span></a>
		</h1>

		<div class="search-bar">
			<form action="${contextPath}/auction/search" method="get"
				id="searchForm">
				<input type="text" name="keyword" placeholder="검색어를 입력하세요."
					id="searchInput">
				<button type="submit">검색</button>
			</form>
		</div>

		<div class="member-links">
			<sec:authorize access="isAnonymous()">
				<a href="${contextPath}/member/login" class="hover-link">로그인</a> | 
        <a href="${contextPath}/member/agreeForm.me" class="hover-link">회원가입</a>
			</sec:authorize>

			<sec:authorize access="isAuthenticated()">
				<strong><sec:authentication property="principal.userName" /></strong>님 환영합니다!
				
				<br>
				
				<sec:authorize access="hasAnyAuthority('1','2')">
					<a href="${contextPath}/member/mypage.me" class="hover-link">마이페이지</a> | 
				</sec:authorize>
				<sec:authorize access="hasAuthority('3')">
					<a href="${contextPath}/member/adminpage.me" class="hover-link">관리자페이지</a>
				</sec:authorize>
        		<a href="${contextPath}/member/logout" class="hover-link">로그아웃</a>
			</sec:authorize>
		</div>
	</div>
</header>
<nav>
	<div class="container">
		<ul class="menu">
			<li><a href="${contextPath}/auction/nowDeal" class="nav-item">현재
					진행중인 경매</a></li>
			<li><a href="${contextPath}/auction/endDeal" class="nav-item">종료된
					경매</a></li>
			<li><a href="${contextPath}/auction/yetDeal" class="nav-item">시작
					예정인 경매</a></li>
			<li><a href="${contextPath}/board/community.me/1"
				class="nav-item">커뮤니티</a></li>
			<li><a href="${contextPath}/auction/itemEnroll" class="btn-register">물품등록</a></li>
		</ul>
	</div>
</nav>