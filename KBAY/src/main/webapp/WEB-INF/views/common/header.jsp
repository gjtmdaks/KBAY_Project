<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
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
</body>
</html>