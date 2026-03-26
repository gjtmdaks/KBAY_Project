<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> <%-- 🌟 날짜 포맷용 추가 --%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 관리 페이지 - K-BAY</title>
<link rel="stylesheet" href="${contextPath}/resources/css/headerFooterCss/footer.css">
<link rel="stylesheet" href="${contextPath}/resources/css/headerFooterCss/header.css">
<link rel="stylesheet" href="${contextPath}/resources/css/adminCss/memberList.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="admin-wrap">
    <jsp:include page="/WEB-INF/views/admin/adminSidebar.jsp" />

    <div class="main-content">
        <div class="page-header">
            <h2 class="page-title">전체 사용자 조회</h2>
            
            <div class="search-area">
                <select class="search-select" name="searchCondition">
                    <option value="userId" ${param.searchCondition == 'userId' ? 'selected' : ''}>유저아이디</option>
                    <option value="userName" ${param.searchCondition == 'userName' ? 'selected' : ''}>유저이름</option>
                </select>
                <input type="text" class="search-input" name="searchKeyword" value="${param.searchKeyword}" placeholder="Search">
                <button type="button" class="btn-search">검색</button>
            </div>
        </div>

        <table class="member-table">
            <thead>
                <tr>
                    <th>유저번호</th>
                    <th>유저아이디</th>
                    <th>유저이름</th>
                    <th>유저주소</th>
                    <th>유저전화번호</th>
                    <th>가입일자</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty list}">
                        <tr>
                            <td colspan="6" style="padding: 50px 0; text-align: center; color: #777;">
                                조회된 회원이 없습니다.
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="member" items="${list}">
                            <tr class="member-row" data-user-no="${member.userNo}">
                                <td>${member.userNo}</td>
                                <td>${member.userId}</td>
                                <td>${member.userName}</td>
                                <td>${member.userAddress}</td>
                                <td>${member.userPhone}</td>
                                <td>
                                	<fmt:parseDate value="${member.userEnrollDate}" var="parsedDate" 
                                                   pattern="E MMM dd HH:mm:ss z yyyy" parseLocale="en_US" />
                                    <fmt:formatDate value="${parsedDate}" pattern="yyyy.MM.dd HH:mm" />
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>

        <%-- 페이징 영역 (기존 유지) --%>
        <div class="pagination-area">
            <ul class="pagination-list">
                <c:if test="${pi.currentPage > 1}">
                    <li><a href="${contextPath}/admin/memberList?cpage=${pi.currentPage - 1}&searchCondition=${param.searchCondition}&searchKeyword=${param.searchKeyword}">&lt;</a></li>
                </c:if>

                <c:forEach var="p" begin="${pi.startPage}" end="${pi.endPage}">
                    <li class="${p == pi.currentPage ? 'active' : ''}">
                        <a href="${contextPath}/admin/memberList?cpage=${p}&searchCondition=${param.searchCondition}&searchKeyword=${param.searchKeyword}">${p}</a>
                    </li>
                </c:forEach>

                <c:if test="${pi.currentPage < pi.maxPage}">
                    <li><a href="${contextPath}/admin/memberList?cpage=${pi.currentPage + 1}&searchCondition=${param.searchCondition}&searchKeyword=${param.searchKeyword}">&gt;</a></li>
                </c:if>
            </ul>
        </div>
    </div>
</div>

<%-- 모달창 --%>
<div id="memberModal" class="modal-overlay"> <div class="modal-content">
        <div class="modal-header">
            <h3>회원 관리 메뉴</h3> <button class="btn-close-modal" id="closeModalTop">&times;</button>
        </div>
        
        <div class="modal-body">
            <%-- 1. 회원 요약 정보 영역 --%>
            <div class="user-info-summary">
                <span class="user-badge">회원 No. <span id="targetUserNo"></span></span>
                <h4 id="targetUserName">사용자 이름</h4>
                <p id="targetUserId"></p>
            </div>

            <%-- 2. 5개 관리 메뉴 그리드 (이모지 제거, 클래스 추가) --%>
            <div class="admin-menu-grid">
                <button type="button" class="menu-btn" onclick="viewUserAuctions()">경매 내역</button>
                <button type="button" class="menu-btn" onclick="viewUserPosts()">작성 글</button>
                <button type="button" class="menu-btn" onclick="viewUserComments()">작성 댓글</button>
                <button type="button" class="menu-btn" onclick="viewUserReports()">신고 내역</button>
                
                <button type="button" class="menu-btn full-width" onclick="openEditForm()">정보 수정</button>
            </div>
        </div>
        
        <div class="modal-footer">
            <button type="button" class="btn-cancel" id="closeModalBottom">닫기</button>
        </div>
    </div>
</div>

<%-- 🌟 자바스크립트 통역사 배치 (contextPath 전달) --%>
<script>
    const contextPath = "${contextPath}";
</script>
<script src="${contextPath}/resources/js/adminJs/memberList.js"></script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>