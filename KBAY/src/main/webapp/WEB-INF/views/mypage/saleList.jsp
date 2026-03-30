<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:useBean id="now" class="java.util.Date" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>판매 현황</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mypageCss/mypage.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<section class="mypage-container">
    <aside class="mypage-sidebar">
        <jsp:include page="mypageSidebar.jsp" />
    </aside>

    <main class="mypage-main">
        <div class="mypage-content">

            <h2>판매 현황</h2>

            <table class="mypage-table">
                <thead>
                    <tr>
                        <th>구분</th>
                        <th>이미지</th>
                        <th>물품번호/물품명</th>
                        <th>현재가</th>
                        <th>입찰수</th>
                        <th>조회수</th>
                        <th>마감일</th>
                        <th>구매자</th>
                    </tr>
                </thead>

                <tbody>
                    <c:forEach var="i" items="${list}">
                        <tr class="clickable-row"
                            data-href="${pageContext.request.contextPath}/auction/detail/${i.itemNo}">

                            <!-- 상태 -->
                            <td>${i.statusText}</td>

                            <!-- 이미지 -->
                            <td>
                                <img src="${i.imgUrl}" class="thumb"
                                     onerror="this.onerror=null; this.src='https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg';">
                            </td>

                            <!-- 상품 -->
                            <td>
                                ${i.itemNo}<br>
                                ${i.itemTitle}
                            </td>

                            <!-- 현재가 -->
                            <td>${i.currentPrice}</td>

                            <!-- 입찰수 -->
                            <td>${i.bidCount}</td>

                            <!-- 조회수 -->
                            <td>${i.views}</td>

                            <!-- 마감일 -->
                            <td>
							    <c:choose>
							        <c:when test="${i.endTime.time lt now.time}">
							            <span style="color:red; font-weight:bold;">마감</span>
							        </c:when>
							        <c:otherwise>
							            <fmt:formatDate value="${i.endTime}" pattern="MM-dd HH:mm"/>
							        </c:otherwise>
							    </c:choose>
							</td>

                            <!-- 구매자 -->
                            <td>
                                <c:choose>
                                    <c:when test="${i.buyerId != null}">
                                        ${i.buyerId}
                                    </c:when>
                                    <c:otherwise>
                                        -
                                    </c:otherwise>
                                </c:choose>
                            </td>

                        </tr>
                    </c:forEach>
                </tbody>
            </table>

        </div>
    </main>
</section>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />

<script>
document.addEventListener("DOMContentLoaded", function(){
    document.querySelectorAll(".clickable-row").forEach(row => {
        row.addEventListener("click", function(){
            window.location.href = this.dataset.href;
        });
    });
});
</script>
</body>
</html>