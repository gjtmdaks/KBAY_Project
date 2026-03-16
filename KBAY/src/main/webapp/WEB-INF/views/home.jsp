<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>K-Bay Auction</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/home.css">
</head>
<body>
    <header>
        <div class="container header-inner">
            <h1 class="logo"><a href="index.jsp">K-Bay <span>Auction</span></a></h1>

            <div class="search-bar">
                <form action="search.jsp" method="get" id="searchForm">
                    <input type="text" name="keyword" placeholder="검색어를 입력하세요." id="searchInput">
                    <button type="submit">검색</button>
                </form>
            </div>

            <div class="member-links">
                <a href="login.jsp" class="hover-link">로그인</a> |
                <a href="register.jsp" class="hover-link">회원가입</a>
            </div>
        </div>
    </header>

    <nav>
        <div class="container">
            <ul class="menu">
                <li><a href="ongoing.jsp" class="nav-item">현재 진행중인 경매</a></li>
                <li><a href="ended.jsp" class="nav-item">종료된 경매</a></li>
                <li><a href="upcoming.jsp" class="nav-item">시작 예정인 경매</a></li>
                <li><a href="community.jsp" class="nav-item">커뮤니티</a></li>
                <li><a href="item_reg.jsp" class="btn-register">물품등록</a></li>
            </ul>
        </div>
    </nav>

    <section class="banner">
        <div class="container">
            <h2>K-Bay만의 특별한 경매 이벤트</h2>
            <p>신뢰할 수 있는 실시간 입찰 시스템</p>
        </div>
    </section>

    <section class="best-items container">
        <h3 class="section-title">BEST ITEM</h3>
        <div class="scroll-container">
            <div class="item-grid">
                <article class="item-card">
                    <div class="item-img">ITEM IMAGE</div>
                    <div class="item-info">
                        <h4>한정판 빈티지 시계</h4>
                        <p class="price">현재가 <strong>117,000원</strong></p>
                        <div class="item-meta"><span>입찰 5회</span><span class="timer">05:02:11</span></div>
                    </div>
                </article>
                </div>
        </div>
    </section>

    <footer>
        <div class="container">
            <div class="footer-links">
                <a href="#" class="f-link">회사소개</a>
                <a href="#" class="f-link">이용약관</a>
                <a href="#" class="f-link privacy">개인정보취급방침</a>
                <a href="#" class="f-link">이메일무단수집거부</a>
                <a href="#" class="f-link">고객센터</a>
                <a href="#" class="f-link">공지사항</a>
            </div>
            <div class="footer-info">
                <p>(주)K-Bay Auction | 대표이사: 심기범 | 사업자등록번호: 000-00-00000</p>
                <p>Copyright &copy; K-Bay Auction. All Rights Reserved.</p>
            </div>
        </div>
    </footer>



    <script src="domain.js"></script>
</body>
</html>