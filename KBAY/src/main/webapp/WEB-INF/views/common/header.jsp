<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/headerFooterCss/header.css">
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
				
				<a href="${contextPath}/mypage/mypage.me" class="hover-link">마이페이지</a> | 
				<sec:authorize access="hasAuthority('3')">
					<a href="${contextPath}/admin/adminPage.me" class="hover-link">관리자페이지</a> | 
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
			<li>
    		<sec:authorize access="isAnonymous()">
       	    	<%-- 비로그인이면 JS 함수 실행 --%>
            	<a href="javascript:void(0);" onclick="needLoginAlert();" class="btn-register">물품등록</a>
            </sec:authorize>
            <sec:authorize access="isAuthenticated()">
            	<%-- 로그인이면 정상 이동 --%>
            	<a href="${contextPath}/auction/itemEnroll" class="btn-register">물품등록</a>
            </sec:authorize>
            </li>
			
		</ul>
	</div>
</nav>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
    // 비로그인 시 물품등록 클릭 시 실행될 함수
    function needLoginAlert() {
        Swal.fire({
            icon: 'warning',
            title: '로그인 필요',
            text: '물품 등록은 로그인 후 이용 가능합니다.',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#aaa',
            confirmButtonText: '로그인하러 가기',
            cancelButtonText: '취소'
        }).then((result) => {
            if (result.isConfirmed) {
                location.href = "${contextPath}/member/login";
            }
        });
    }

    document.addEventListener("DOMContentLoaded", function() {
        const msg = "${alertMsg}";
        const error = "${errorMsg}";
        const isAnonymous = <sec:authorize access="isAnonymous()">true</sec:authorize><sec:authorize access="isAuthenticated()">false</sec:authorize>;

        // 1. 성공/알림 메시지 처리
        if (msg) {
            // 메시지 내용에 '성공'이나 '완료'가 포함되었을 때만 success 아이콘 사용
            const isSuccess = msg.includes("성공") || msg.includes("완료");
            
            Swal.fire({
                icon: isSuccess ? 'success' : 'info',
                title: isSuccess ? '완료!' : '알림',
                text: msg,
                // 비로그인(회원가입 직후 등)일 때만 로그인 버튼 노출
                showCancelButton: isAnonymous, 
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#4e73df',
                confirmButtonText: '확인',
                cancelButtonText: '로그인하기'
            }).then((result) => {
                if (result.isDismissed && result.dismiss === Swal.DismissReason.cancel) {
                    location.href = "${contextPath}/member/login";
                }
            });
            
        }

        // 2. 오류 메시지 처리
        if (error) {
            Swal.fire({
                icon: 'error',
                title: '오류발생',
                text: error,
                confirmButtonColor: '#d33',
                confirmButtonText: '확인'
            });
        }
		
        // 헤더 메뉴 바에 내가 보고 있는 메뉴 표시
        const currentPath = window.location.pathname; 
        const navItems = document.querySelectorAll(".nav-item");

        navItems.forEach(item => {
            const itemHref = item.getAttribute("href");
            
            // /auction/주소 에 따라 현재 보고 있는 메뉴 활성화
            if (currentPath.includes(itemHref)) {
                item.classList.add("active");
            }
            
            // 뒤에 숫자가 붙는 경우
            if (itemHref.includes("community.me") && currentPath.includes("community.me")) {
                item.classList.add("active");
            }
        });
    });
</script>

