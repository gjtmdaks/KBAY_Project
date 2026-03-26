<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/headerFooterCss/paging.css">
<c:set var="blockSize" value="10" />

<!-- startPage 계산 -->
<c:set var="startPage"
       value="${(currentPage - 1) - ((currentPage - 1) % blockSize) + 1}" />

<c:set var="endPage" value="${startPage + blockSize - 1}" />

<c:if test="${endPage > maxPage}">
    <c:set var="endPage" value="${maxPage}" />
</c:if>

<div class="pagination">

    <!-- 이전 버튼 -->
    <c:choose>
        <c:when test="${currentPage <= 1}">
            <span class="disabled">&lt;</span>
        </c:when>
        <c:otherwise>
            <a href="${pageContext.request.contextPath}/auction/${type}?page=${currentPage - 1}&keyword=${keyword}">&lt;</a>
        </c:otherwise>
    </c:choose>

    <!-- 페이지 번호 -->
    <c:forEach var="i" begin="${startPage}" end="${endPage}">
        <c:choose>
            <c:when test="${i == currentPage}">
                <span class="active">${i}</span>
            </c:when>
            <c:otherwise>
                <a href="?page=${i}">${i}</a>
            </c:otherwise>
        </c:choose>
    </c:forEach>

    <!-- 다음 버튼 -->
    <c:choose>
        <c:when test="${currentPage == maxPage}">
            <span class="disabled">&gt;</span>
        </c:when>
        <c:otherwise>
            <a href="${pageContext.request.contextPath}/auction/${type}?page=${currentPage + 1}&keyword=${keyword}">&gt;</a>
        </c:otherwise>
    </c:choose>

</div>