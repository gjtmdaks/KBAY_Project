<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:choose>
    <c:when test="${param.type == 'yet'}">
        <c:set var="remain" value="${(item.startTime.time - now.time) / 1000}" />
    </c:when>
    <c:otherwise>
        <c:set var="remain" value="${(item.endTime.time - now.time) / 1000}" />
    </c:otherwise>
</c:choose>

<div class="item-card">

    <div class="item-img">
        <img src="${pageContext.request.contextPath}/resources/images/noimage.png">
    </div>

    <div class="item-info">
        <h4>${item.itemTitle}</h4>

        <c:choose>
            <c:when test="${param.type == 'now'}">
                현재가 ${item.currentPrice}
            </c:when>

            <c:when test="${param.type == 'end'}">
                낙찰가 ${item.currentPrice}
            </c:when>

            <c:when test="${param.type == 'yet'}">
                시작까지 ${remain / 3600}시간 ${(remain % 3600) / 60}분
            </c:when>
        </c:choose>

        <div class="item-meta">
            <span>판매자 ${item.sellerNo}</span>

            <span class="timer">
			    <c:choose>
			        <c:when test="${param.type == 'end'}">
			            종료
			        </c:when>
			        <c:otherwise>
			            <c:if test="${remain > 0}">
			                ${remain / 3600}시간 ${(remain % 3600) / 60}분
			            </c:if>
			            <c:if test="${remain <= 0}">
			                종료
			            </c:if>
			        </c:otherwise>
			    </c:choose>
			</span>
        </div>
    </div>
</div>