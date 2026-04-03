<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="type" value="${param.type}" />

<div class="mypage-card ${type}">
    <c:choose>
        <c:when test="${type == 'purchase'}">
            <h4>구매 관리</h4>
            <div class="card-buttons">
                <a href="${pageContext.request.contextPath}/mypage/bidList" class="card-btn">입찰 현황</a>
                <a href="${pageContext.request.contextPath}/mypage/wonList" class="card-btn">결제 현황</a>
            </div>
        </c:when>
        <c:when test="${type == 'sale'}">
            <h4>판매 관리</h4>
            <div class="card-buttons">
                <a href="${pageContext.request.contextPath}/mypage/saleList" class="card-btn">판매 현황</a>
                <a href="${pageContext.request.contextPath}/mypage/paymentList" class="card-btn">거래 현황</a>
            </div>
        </c:when>
        <c:when test="${type == 'activity'}">
            <h4>나의 활동</h4>
            <div class="card-buttons">
                <a href="${pageContext.request.contextPath}/mypage/faq" class="card-btn">FAQ</a>
                <a href="${pageContext.request.contextPath}/mypage/boardList" class="card-btn">나의 게시글 보기</a>
                <a href="${pageContext.request.contextPath}/mypage/reportList" class="card-btn">신고 내역</a>
                <a href="${pageContext.request.contextPath}/mypage/replyList" class="card-btn">나의 댓글 보기</a>
            </div>
        </c:when>
        <c:when test="${type == 'accident'}">
            <h4>사고 내역</h4>
            <table>
                <tr>
                    <td>나의 상태</td>
                    <td>
                        <c:choose>
                            <c:when test="${user.authority == 1}">입찰 가능</c:when>
                            <c:when test="${user.authority == 2 || user.authority == 3}">입찰 및 등록 가능</c:when>
                            <c:otherwise>확인 불가</c:otherwise>
                        </c:choose>
                    </td>
                </tr>
                <tr>
                    <td>사고 건수</td>
                    <td><a href="${pageContext.request.contextPath}/mypage/reportedList" class="card-btn">${accidentCount}건</a></td>
                </tr>
            </table>
        </c:when>
    </c:choose>
</div>