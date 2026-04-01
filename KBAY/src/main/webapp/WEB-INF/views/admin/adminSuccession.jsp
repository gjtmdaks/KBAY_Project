<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>낙찰 승계 관리</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/adminCss/adminSuccession.css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <div class="admin-wrap">
        <%-- 사이드바 영역 --%>
        <jsp:include page="/WEB-INF/views/admin/adminSidebar.jsp" />

        <%-- 메인 컨텐츠 영역 --%>
        <main class="main-content">
            <div class="page-header">
                <h2 class="page-title">낙찰 취하 신청 및 낙찰 승계관리</h2>
            </div>

            <table class="admin-table">
                <thead>
                    <tr>
                        <th width="8%">번호</th>
                        <th width="10%">카테고리</th>
                        <th width="20%">상품명</th>
                        <th width="10%">판매자</th>
                        <th width="10%">현재 낙찰자</th>
                        <th width="12%">시작/현재가</th>
                        <th width="10%">종료일</th>
                        <th width="10%">결제 마감일</th>
                        <th width="10%">관리</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <%-- 컨트롤러에서 successionList 라는 이름으로 E 상태인 리스트를 넘겨준다고 가정 --%>
                        <c:when test="${empty successionList}">
                            <tr>
                                <td colspan="9">결제 대기 중이거나 승계 진행 중인 경매가 없습니다.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="item" items="${successionList}">
                                <tr>
                                    <td>${item.itemNo}</td>
                                    <td>${item.itemCategory}</td> <td class="title-cell" onclick="location.href='${pageContext.request.contextPath}/auction/detail/${item.itemNo}'">
                                        ${item.itemTitle}
                                    </td>
                                    <td>${item.sellerName}</td> <td>
                                        <%-- 현재 이 물품을 결제해야 하는 1등(또는 차순위 승계자) --%>
                                        <span style="color:#e74c3c; font-weight:bold;">${item.buyerName}</span>
                                    </td>
                                    <td>
                                        <fmt:formatNumber value="${item.startPrice}" pattern="#,###"/> /<br>
                                        <strong style="color:#2c3e50;"><fmt:formatNumber value="${item.currentPrice}" pattern="#,###"/>원</strong>
                                    </td>
                                    <td><fmt:formatDate value="${item.endTime}" pattern="MM.dd HH:mm" /></td>
                                    <td>
                                        <%-- 결제 마감일 표시 (추가한 PAYMENT_DEADLINE 활용) --%>
                                        <c:choose>
                                            <c:when test="${not empty item.paymentDeadline}">
                                                <strong style="color:#3498db;"><fmt:formatDate value="${item.paymentDeadline}" pattern="MM.dd HH:mm" /></strong>
                                            </c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <%-- 관리자 강제 조작 버튼 2개 --%>
                                        <button class="btn-cancel" style="background-color:#3498db; margin-bottom: 5px; width: 100%;" onclick="forceSuccession(${item.itemNo})">차순위 승계</button>
                                        <button class="btn-cancel" style="width: 100%;" onclick="forceFail(${item.itemNo})">강제 유찰</button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
            
            <%-- 페이징 영역 (필요시 주석 해제하여 사용) --%>
            <%-- 
            <div class="pagination-area">
                <ul class="pagination-list">
                    <li><a href="#">&lt;</a></li>
                    <li class="active"><a href="#">1</a></li>
                    <li><a href="#">2</a></li>
                    <li><a href="#">&gt;</a></li>
                </ul>
            </div> 
            --%>
        </main>
    </div>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />

    <%-- 버튼 클릭 시 작동할 자바스크립트 함수 (AJAX 처리 예정) --%>
    <script>
        // 1. 차순위 강제 승계 버튼
        function forceSuccession(itemNo) {
            if(confirm(itemNo + "번 경매의 현재 낙찰자를 박탈하고 차순위에게 넘기시겠습니까?")) {
                alert("승계 로직 연결 준비 중입니다!");
                // 추후 여기에 fetch() 로직 작성
            }
        }

        // 2. 강제 유찰 버튼
        function forceFail(itemNo) {
            if(confirm(itemNo + "번 경매를 강제 유찰(완전 종료) 처리하시겠습니까?\n이 작업은 되돌릴 수 없습니다.")) {
                alert("유찰 로직 연결 준비 중입니다!");
                // 추후 여기에 fetch() 로직 작성
            }
        }
    </script>
</body>
</html>