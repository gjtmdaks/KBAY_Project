<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>경매 강제 관리 | KBAY 관리자</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/adminCss/adminAuctionCancel.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="admin-wrap">
    <%-- 사이드바 --%>
    <jsp:include page="/WEB-INF/views/admin/adminSidebar.jsp" />

    <main class="main-content">
        <div class="page-header">
            <h2 class="page-title">경매 강제 관리 (종료 및 취소)</h2>
        </div>
        
        <table class="admin-table">
            <thead>
                <tr>
                    <th style="width: 8%">번호</th>
                    <th style="width: 12%">카테고리</th>
                    <th style="width: 25%">상품명</th>
                    <th style="width: 12%">판매자</th>
                    <th style="width: 18%">시작가 / 현재가</th>
                    <th style="width: 8%">입찰수</th>
                    <th style="width: 12%">종료 예정일</th>
                    <th style="width: 10%">관리</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty itemList}">
                        <tr>
                            <td colspan="8" style="padding: 50px 0; color: #999;">진행 중인 경매 내역이 없습니다.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="item" items="${itemList}">
                            <tr>
                                <td>${item.itemNo}</td>
                                <td>${item.categoryName}</td>
                                <td class="title-cell" onclick="openBidHistory(${item.itemNo}, '${item.itemTitle}')">
                                    ${item.itemTitle}
                                </td>
                                <td>${item.userId}</td>
                                <td>
                                    <small style="color: #7f8c8d;">시작: <fmt:formatNumber value="${item.startPrice}" pattern="#,###"/>원</small><br>
                                    <b style="color: #2c3e50;">현재: <fmt:formatNumber value="${item.currentPrice}" pattern="#,###"/>원</b>
                                </td>
                                <td>
                                    <span class="bid-badge">${item.bidCount}건</span>
                                </td>
                                <td>
                                    <small><fmt:formatDate value="${item.endTime}" pattern="MM-dd HH:mm"/></small>
                                </td>
                                <td>
                                    <button class="btn-cancel" onclick="processAuction(${item.itemNo}, 'C')">강제취소</button>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>

        <%-- 🚨 페이징 바 영역 (신고 내역 페이지와 동일한 스타일) --%>
        <div class="pagination-area">
            <ul class="pagination-list">
                <%-- 이전 페이지로 --%>
                <c:if test="${pi.currentPage > 1}">
                    <li><a href="adminAuctionCancel?cp=${pi.currentPage - 1}">&lt;</a></li>
                </c:if>

                <%-- 페이지 번호 목록 --%>
                <c:forEach var="p" begin="${pi.startPage}" end="${pi.endPage}">
                    <li class="${p == pi.currentPage ? 'active' : ''}">
                        <a href="adminAuctionCancel?cp=${p}">${p}</a>
                    </li>
                </c:forEach>

                <%-- 다음 페이지로 --%>
                <c:if test="${pi.currentPage < pi.maxPage}">
                    <li><a href="adminAuctionCancel?cp=${pi.currentPage + 1}">&gt;</a></li>
                </c:if>
            </ul>
        </div>
    </main>
</div>

<%-- 입찰 기록 모달창 --%>
<div id="bidModal" class="modal-overlay" style="display:none;">
    <div class="modal-content bid-modal">
        <div class="modal-header">
            <h3 id="modalItemTitle">경매 입찰 기록</h3>
            <button class="btn-close" onclick="closeBidModal()">X</button>
        </div>
        <div class="modal-body">
            <table class="bid-history-table">
                <thead>
                    <tr>
                        <th>입찰번호</th>
                        <th>입찰자ID</th>
                        <th>입찰금액</th>
                        <th>입찰시간</th>
                        <th>입찰자IP</th>
                    </tr>
                </thead>
                <tbody id="bidHistoryList">
                    <%-- AJAX로 데이터가 들어올 자리 --%>
                </tbody>
            </table>
            <%-- 모달 안에서 사용할 페이징 영역 --%>
            <div id="modalPagination"></div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
<script>
    // JS 파일에서 사용할 컨텍스트 패스 전역 변수 설정
    const contextPath = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/resources/js/adminJs/adminAuctionCancel.js"></script>
</body>
</html>