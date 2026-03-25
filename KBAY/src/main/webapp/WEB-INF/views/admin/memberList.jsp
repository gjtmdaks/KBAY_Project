<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 조회 및 수정</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/headerFooterCss/footer.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/headerFooterCss/header.css">
<link rel="stylesheet" 
	href="${pageContext.request.contextPath}/resources/css/adminCss/memberList.css">
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
                    <option value="userId">유저아이디</option>
                    <option value="userName">유저이름</option>
                    <option value="enrollDate">가입일자</option>
                </select>
                <input type="text" class="search-input" name="searchKeyword" placeholder="Search">
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
                    <%-- 1. 조회된 회원이 없을 경우 --%>
                    <c:when test="${empty list}">
                        <tr>
                            <td colspan="6" style="padding: 50px 0; text-align: center; color: #777;">
                                조회된 회원이 없습니다.
                            </td>
                        </tr>
                    </c:when>
                    
                    <%-- 2. 조회된 회원이 있을 경우 (10개씩 반복) --%>
                    <c:otherwise>
                        <c:forEach var="member" items="${list}">
                            <tr class="member-row" data-user-no="${member.userNo}">
                                <td>${member.userNo}</td>
                                <td>${member.userId}</td>
                                <td>${member.userName}</td>
                                
                                <%-- 
                                    주의: address, phone, enrollDate는 
                                    질문자님의 Member VO 클래스의 변수명에 맞게 살짝 수정해 주세요!
                                    (예: userAddress, userPhone 등)
                                --%>
                                <td>${member.address}</td>
                                <td>${member.phone}</td>
                                <td>${member.enrollDate}</td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>

        <div class="pagination-area">
            <ul class="pagination-list">
                
                <%-- 1. 이전 페이지 (<) 버튼 --%>
                <c:choose>
                    <%-- 현재 페이지가 1페이지면 클릭 안 되게 막기 --%>
                    <c:when test="${pi.currentPage eq 1}">
                        <li class="disabled"><a href="javascript:void(0)">&lt;</a></li>
                    </c:when>
                    <c:otherwise>
                        <%-- 아니면 이전 페이지(현재페이지 - 1)로 이동! (검색어 유지) --%>
                        <li><a href="${contextPath}/admin/memberList?cpage=${pi.currentPage - 1}&searchCondition=${param.searchCondition}&searchKeyword=${param.searchKeyword}">&lt;</a></li>
                    </c:otherwise>
                </c:choose>

                <%-- 2. 페이지 번호 (startPage ~ endPage까지 반복) --%>
                <c:forEach var="p" begin="${pi.startPage}" end="${pi.endPage}">
                    <c:choose>
                        <%-- 현재 페이지 번호일 경우 진하게(active) 표시하고 클릭 막기 --%>
                        <c:when test="${p eq pi.currentPage}">
                            <li class="active"><a href="javascript:void(0)">${p}</a></li>
                        </c:when>
                        <%-- 다른 페이지 번호일 경우 해당 페이지로 이동! (검색어 유지) --%>
                        <c:otherwise>
                            <li><a href="${contextPath}/admin/memberList?cpage=${p}&searchCondition=${param.searchCondition}&searchKeyword=${param.searchKeyword}">${p}</a></li>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>

                <%-- 3. 다음 페이지 (>) 버튼 --%>
                <c:choose>
                    <%-- 현재 페이지가 마지막 페이지(maxPage)면 클릭 안 되게 막기 --%>
                    <c:when test="${pi.currentPage eq pi.maxPage}">
                        <li class="disabled"><a href="javascript:void(0)">&gt;</a></li>
                    </c:when>
                    <c:otherwise>
                        <%-- 아니면 다음 페이지(현재페이지 + 1)로 이동! (검색어 유지) --%>
                        <li><a href="${contextPath}/admin/memberList?cpage=${pi.currentPage + 1}&searchCondition=${param.searchCondition}&searchKeyword=${param.searchKeyword}">&gt;</a></li>
                    </c:otherwise>
                </c:choose>
                
            </ul>
        </div>
    </div>
</div>

<div id="memberModal" class="modal-overlay">
    <div class="modal-content">
        <div class="modal-header">
            <h3>회원 상세 정보</h3>
            <button class="btn-close-modal" id="closeModalTop">&times;</button>
        </div>
        <div class="modal-body">
            <p style="color: #666; text-align: center; padding: 40px 0;">
                선택한 회원의 상세 정보 및 수정 폼이 들어갈 자리입니다.<br>
                (나중에 아이디, 이름, 권한 변경 등의 기능을 추가하세요!)
            </p>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn-cancel" id="closeModalBottom">닫기</button>
            <button type="button" class="btn-save">수정 내용 저장</button>
        </div>
    </div>
</div>

<script src="${contextPath}/resources/js/adminJs/memberList.js"></script>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>