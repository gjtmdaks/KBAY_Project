<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/headerFooterCss/header.css">
</head>
<body>
	<header>
		<div class="container header-inner">
			<h1 class="logo">
				<a href="/kbay">K-Bay <span>Auction</span></a>
			</h1>

			<div class="search-bar">
				<form action="search.jsp" method="get" id="searchForm">
					<input type="text" name="keyword" placeholder="검색어를 입력하세요."
						id="searchInput">
					<button type="submit">검색</button>
				</form>
			</div>

			<div class="member-links">
				<a href="loginForm.me" class="hover-link">로그인</a> | 
				<a href="agreeForm.me" class="hover-link">회원가입</a>
			</div>
		</div>
	</header>
	<nav>
		<div class="container">
			<ul class="menu">
				<li><a href="ongoing.jsp" class="nav-item">현재 진행중인 경매</a></li>
				<li><a href="ended.jsp" class="nav-item">종료된 경매</a></li>
				<li><a href="upcoming.jsp" class="nav-item">시작 예정인 경매</a></li>
				<li><a href="community.me" class="nav-item">커뮤니티</a></li>
				<li><a href="item_reg.jsp" class="btn-register">물품등록</a></li>
			</ul>
		</div>
	</nav>
</body>
</html>