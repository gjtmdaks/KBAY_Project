<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!-- 남은 시간 계산 -->
<c:choose>
    <c:when test="${type eq 'yetDeal'}">
        <c:set var="remain" value="${(item.startTime.time - now.time) / 1000}" />
    </c:when>
    <c:otherwise>
        <c:set var="remain" value="${(item.endTime.time - now.time) / 1000}" />
    </c:otherwise>
</c:choose>

<a href="${pageContext.request.contextPath}/auction/detail/${item.itemNo}" class="item-link">
	<div class="item-card">
	
	    <div class="item-img">
	        <img src="${item.mainImg}"
	        	onerror="this.onerror=null; this.src='https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg';">
	    </div>
	
	    <div class="item-info">
	        <h4>${item.itemTitle}</h4>
	        
	        <!-- 가격 or 상태 -->
	        <c:choose>
	            <c:when test="${type eq 'nowDeal'}">
	                현재가 ${item.currentPrice}
	            </c:when>
	
	            <c:when test="${type eq 'endDeal'}">
	                낙찰가 ${item.currentPrice}
	            </c:when>
	
	            <c:when test="${type eq 'yetDeal'}">
	                시작가 ${item.startPrice}
	            </c:when>
	        </c:choose>
	
	        <div class="item-meta">
	            <span>판매자 ${item.userNo}</span>
	
	            <!-- 타이머 -->
				<span class="timer">
				    <c:choose>
				
				        <c:when test="${type eq 'endDeal' || remain <= 0}">
				            <strong style="color:red;">종료</strong>
				        </c:when>
				
				        <c:otherwise>
				            <c:choose>
				                <c:when test="${type eq 'yetDeal'}">
				                    시작까지 
				                </c:when>
				                <c:otherwise>
				                    종료까지 
				                </c:otherwise>
				            </c:choose>
				
				            <c:choose>
				                <c:when test="${remain < 3600}">
				                    <c:set var="mins" value="${remain / 60}" />
				                    <fmt:formatNumber value="${mins}" pattern="0"/>분
				                </c:when>
				
				                <c:when test="${remain < 259200}">
				                    <c:set var="hours" value="${remain / 3600}" />
				                    <c:set var="mins" value="${(remain % 3600) / 60}" />
				
				                    <fmt:formatNumber value="${hours}" pattern="0"/>시간
				                    <fmt:formatNumber value="${mins}" pattern="0"/>분
				                </c:when>
				
				                <c:otherwise>
				                    <c:set var="days" value="${remain / 86400}" />
				                    <c:set var="hours" value="${(remain % 86400) / 3600}" />
				                    <c:set var="mins" value="${(remain % 3600) / 60}" />
				
				                    <fmt:formatNumber value="${days}" pattern="0"/>일
				                    <fmt:formatNumber value="${hours}" pattern="0"/>시간
				                    <fmt:formatNumber value="${mins}" pattern="0"/>분
				                </c:otherwise>
				            </c:choose>
				
				            <c:if test="${remain <= 600}">
				                <span style="color:red;"> (마감임박)</span>
				            </c:if>
				        </c:otherwise>
				    </c:choose>
				</span>
	        </div>
	    </div>
	</div>
</a>