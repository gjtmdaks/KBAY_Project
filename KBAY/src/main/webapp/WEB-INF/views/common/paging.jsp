<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="blockSize" value="10" />

<c:set var="startPage"
	value="${((currentPage - 1) / blockSize) * blockSize + 1}" />
<c:set var="endPage" value="${startPage + blockSize - 1}" />

<c:if test="${endPage > maxPage}">
	<c:set var="endPage" value="${maxPage}" />
</c:if>

<div class="pagination">
	<!-- 이전 블록 -->
	<c:if test="${startPage > 1}">
		<a href="?page=${startPage - 1}">&lt;</a>
	</c:if>

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

	<!-- 다음 블록 -->
	<c:if test="${endPage < maxPage}">
		<a href="?page=${endPage + 1}">&gt;</a>
	</c:if>
</div>