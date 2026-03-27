<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 게시글</title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mypageCss/mypage.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/boardCss/board.css">

<style>
.filter-box {
    display: flex;
    gap: 10px;
}

.filter-btn {
    padding: 6px 12px;
    border: 1px solid #ccc;
    cursor: pointer;
    background: #f5f5f5;
}

.filter-btn.active {
    background: #333;
    color: #fff;
}
</style>

</head>
<body>

<jsp:include page="/WEB-INF/views/common/header.jsp" />

<section class="mypage-container">

    <aside class="mypage-sidebar">
        <jsp:include page="mypageSidebar.jsp" />
    </aside>

    <main class="mypage-main">

        <div class="mypage-content">

            <!-- 헤더 -->
            <div class="board-header">
                <h2>내 게시글</h2>

                <!-- 🔥 카테고리 필터 -->
                <div class="filter-box">
                    <button class="filter-btn ${empty param.category ? 'active' : ''}" 
                            onclick="filterCategory('')">전체</button>

                    <button class="filter-btn ${param.category eq '2' ? 'active' : ''}" 
                            onclick="filterCategory('2')">물품자랑</button>

                    <button class="filter-btn ${param.category eq '3' ? 'active' : ''}" 
                            onclick="filterCategory('3')">구매요망</button>
                </div>
            </div>

            <!-- 테이블 -->
            <table class="board-table">
                <thead>
                    <tr>
                        <th>번호</th>
                        <th>제목</th>
                        <th>조회</th>
                        <th>등록일</th>
                    </tr>
                </thead>

                <tbody>
                    <c:choose>
                        <c:when test="${empty list}">
                            <tr>
                                <td colspan="4">게시글이 없습니다</td>
                            </tr>
                        </c:when>

                        <c:otherwise>
                            <c:forEach var="b" items="${list}" varStatus="status">
                                <tr class="clickable-row"
                                    data-href="${pageContext.request.contextPath}/board/boardDetail/${b.boardNo}">

                                    <td>${status.count}</td>
                                    <td>${b.boardTitle}</td>
                                    <td>${b.viewCount}</td>

                                    <td>
                                        <fmt:formatDate value="${b.boardDate}" pattern="yyyy.MM.dd HH:mm"/>
                                    </td>

                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>

        </div>

    </main>
</section>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />

<!-- JS -->
<script>
function filterCategory(category){
    let url = "${pageContext.request.contextPath}/mypage/boardList";

    if(category){
        url += "?category=" + category;
    }

    location.href = url;
}

// 클릭 이동
document.addEventListener("DOMContentLoaded", function(){
    document.querySelectorAll(".clickable-row").forEach(row => {
        row.addEventListener("click", function(){
            location.href = this.dataset.href;
        });
    });
});
</script>

</body>
</html>