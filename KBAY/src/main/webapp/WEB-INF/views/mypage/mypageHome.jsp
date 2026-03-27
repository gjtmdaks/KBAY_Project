<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mypageCss/mypage.css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <section class="mypage-container">
        <aside class="mypage-sidebar">
            <jsp:include page="mypageSidebar.jsp" />
        </aside>

        <main class="mypage-main">
            <div class="mypage-greeting">
                <strong>${user.userName}</strong>님, 반갑습니다!
                <p>👍 나의 거래 좋아요 수: ${user.likeCount}</p>
                <div class="mypage-actions">
                	<a href="${pageContext.request.contextPath}/mypage/updateStatus" class="card-btn">내 정보 수정</a>
                	<a href="${pageContext.request.contextPath}/mypage/wishList" class="card-btn">찜 목록</a>
                	<a href="${pageContext.request.contextPath}/mypage/payList" class="card-btn">결제 정보</a>
                </div>
            </div>

            <div class="mypage-cards">
                <jsp:include page="mypageCard.jsp">
                    <jsp:param name="type" value="purchase" />
                </jsp:include>
                <jsp:include page="mypageCard.jsp">
                    <jsp:param name="type" value="sale" />
                </jsp:include>
                <jsp:include page="mypageCard.jsp">
                    <jsp:param name="type" value="activity" />
                </jsp:include>
                <jsp:include page="mypageCard.jsp">
                    <jsp:param name="type" value="accident" />
                </jsp:include>
            </div>
        </main>
    </section>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>