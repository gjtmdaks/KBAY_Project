<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="type" value="${param.type}" />

<div class="mypage-card ${type}">
    <c:choose>
        <c:when test="${type == 'purchase'}">
            <h4>구매 관리</h4>
            <div class="card-buttons">
                <button>입찰 현황</button>
                <button>결제 현황</button>
                <button>사고 내역</button>
            </div>
        </c:when>
        <c:when test="${type == 'sale'}">
            <h4>판매 관리</h4>
            <div class="card-buttons">
                <button>판매 현황</button>
                <button>거래 현황</button>
                <button>사고 내역</button>
            </div>
        </c:when>
        <c:when test="${type == 'activity'}">
            <h4>나의 활동</h4>
            <div class="card-buttons">
                <button>FAQ</button>
                <button>나의 게시글 보기</button>
                <button>신고 내역</button>
                <button>나의 댓글 보기</button>
            </div>
        </c:when>
        <c:when test="${type == 'accident'}">
            <h4>사고 내역</h4>
            <table>
                <tr>
                    <td>나의 상태</td>
                    <td>입찰/등록 가능</td>
                </tr>
                <tr>
                    <td>사고 건수</td>
                    <td>0건</td>
                </tr>
            </table>
        </c:when>
    </c:choose>
</div>