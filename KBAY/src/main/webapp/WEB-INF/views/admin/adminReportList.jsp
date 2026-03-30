<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> <%-- 날짜 포맷팅용 --%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/adminCss/adminReportList.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<%-- 전체 레이아웃을 감싸는 래퍼 (사이드바 + 메인 콘텐츠) --%>
<div class="admin-wrap">
    <jsp:include page="/WEB-INF/views/admin/adminSidebar.jsp" />

    <div class="main-content">
        <div class="page-header">
            <h2 class="page-title"> 접수된 신고 내역</h2>
            
            <%-- 검색 및 필터링 폼 --%>
            <form action="${contextPath}/admin/adminReportList" method="GET" id="searchForm">
                <div class="search-area">
                    <%-- 처리 상태 필터링 (전체 / 대기 / 완료) --%>
                    <select class="search-select" name="reportStatus">
                        <option value="ALL" ${param.reportStatus == 'ALL' ? 'selected' : ''}>전체 상태</option>
                        <option value="N" ${param.reportStatus == 'N' ? 'selected' : ''}>처리 대기</option>
                        <option value="Y" ${param.reportStatus == 'Y' ? 'selected' : ''}>처리 완료</option>
                    </select>
                    
                    <%-- 신고 유형 필터링 --%>
                    <select class="search-select" name="targetType">
					    <option value="ALL" ${param.targetType == 'ALL' ? 'selected' : ''}>전체 유형</option>
					    <option value="item" ${param.targetType == 'item' ? 'selected' : ''}>경매 상품</option>
					    <option value="board" ${param.targetType == 'board' ? 'selected' : ''}>게시글</option>
					    <option value="reply" ${param.targetType == 'reply' ? 'selected' : ''}>댓글</option>
					</select>

                    <button type="submit" class="btn-search">검색</button>
                </div>
            </form>
        </div>

        <%-- 신고 내역 테이블 --%>
        <table class="report-table">
            <thead>
                <tr>
                    <th width="8%">신고번호</th>
                    <th width="12%">구분</th>
                    <th width="15%">신고자 (ID)</th>
                    <th width="25%">신고 사유(카테고리)</th>
                    <th width="15%">신고일시</th>
                    <th width="10%">상태</th>
                    <th width="15%">관리</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty reportList}">
                        <tr>
                            <td colspan="7" style="padding: 50px 0; text-align: center; color: #777;">
                                접수된 신고 내역이 없습니다.
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="report" items="${reportList}">
                            <tr>
                                <td>${report.reportNo}</td>
                                
                                <%-- 대상 구분 배지 --%>
                                <td>
                                    <span class="type-badge type-${report.targetType}">
                                        ${report.targetType} (No.${report.targetNo})
                                    </span>
                                </td>
                                
                                <td>${report.reporterId}</td>
                                
                                <%-- 신고 사유 --%>
                                <td class="text-left" style="font-weight: bold; color: #c0392b;">
                                    ${report.reportCategoryName}
                                </td>
                                
                                <%-- 날짜 포맷 --%>
                                <td>
                                    <fmt:parseDate value="${report.createdAt}" var="parsedDate" pattern="E MMM dd HH:mm:ss z yyyy" parseLocale="en_US" />
                                    <fmt:formatDate value="${parsedDate}" pattern="yyyy.MM.dd HH:mm" />
                                </td>
                                
                                <%-- 처리 상태 배지 --%>
                                <td>
                                    <c:choose>
                                        <c:when test="${report.status == 'N'}">
                                            <span style="color:#e74c3c; font-weight:bold;">대기중</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color:#2ecc71;">처리완료</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                
                                <%-- 상세 보기 버튼 --%>
                                <td>
								    <button class="btn-detail" onclick="openReportDetail('${report.targetType}', ${report.targetNo})">상세/처리</button>
								</td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>

        <%-- 페이징 영역 --%>
        <div class="pagination-area">
            <ul class="pagination-list">
                <%-- 이전 페이지 --%>
                <c:if test="${pi.currentPage > 1}">
                    <li><a href="${contextPath}/admin/adminReportList?cpage=${pi.currentPage - 1}&reportStatus=${param.reportStatus}&targetType=${param.targetType}">&lt;</a></li>
                </c:if>

                <%-- 페이지 번호 --%>
                <c:forEach var="p" begin="${pi.startPage}" end="${pi.endPage}">
                    <li class="${p == pi.currentPage ? 'active' : ''}">
                        <a href="${contextPath}/admin/adminReportList?cpage=${p}&reportStatus=${param.reportStatus}&targetType=${param.targetType}">${p}</a>
                    </li>
                </c:forEach>

                <%-- 다음 페이지 --%>
                <c:if test="${pi.currentPage < pi.maxPage}">
                    <li><a href="${contextPath}/admin/adminReportList?cpage=${pi.currentPage + 1}&reportStatus=${param.reportStatus}&targetType=${param.targetType}">&gt;</a></li>
                </c:if>
            </ul>
        </div>
    </div>
</div>
<div id="reportModal" class="modal-overlay" style="display: none;">
    <div class="modal-content">
        <div class="modal-header">
            <h3>🚨 신고 대상 상세/처리</h3>
            <button class="btn-close" onclick="closeModal()">X</button>
        </div>
        
        <div class="modal-body">
            <div class="target-info-box">
                <span id="modalWriter" class="writer-badge">작성자: 알수없음</span>
                <h4 id="modalTitle">글 제목이 들어갈 자리</h4>
                <div id="modalContent" class="content-scroll">글 내용이 들어갈 자리...</div>
            </div>
            
            <div class="stats-box">
                <h4>📊 누적 신고: 총 <span id="modalTotal" style="color:#e74c3c; font-weight:bold;">0</span>건</h4>
                <ul id="modalStatsList" class="stats-list">
                    </ul>
            </div>
        </div>
        
        <div class="modal-footer">
            <button class="btn-delete" onclick="processReport('DELETE')">강제 삭제</button>
            <button class="btn-keep" onclick="processReport('KEEP')">정상 유지(반려)</button>
        </div>
    </div>
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />
<script>
    const contextPath = "${contextPath}"; 
</script>
<script src="${pageContext.request.contextPath}/resources/js/adminJs/adminReportList.js"></script>
</body>
</html>