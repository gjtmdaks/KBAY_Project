<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mypageCss/mypage.css">

<div class="mypage-container">
    <jsp:include page="/WEB-INF/views/mypage/mypageSidebar.jsp" />
    
    <main class="mypage-main"> <div class="mypage-content">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; border-bottom: 2px solid #333; padding-bottom: 10px;">
                <h2 style="font-size: 24px; margin: 0;">낙찰 받은 물품</h2>
                
                <select id="sortOrder" style="padding: 8px; border-radius: 4px; border: 1px solid #ddd; outline: none; cursor: pointer;">
                    <option value="latest" ${param.sort == 'latest' ? 'selected' : ''}>최신 낙찰순</option>
                    <option value="priceDesc" ${param.sort == 'priceDesc' ? 'selected' : ''}>높은 가격순</option>
                    <option value="priceAsc" ${param.sort == 'priceAsc' ? 'selected' : ''}>낮은 가격순</option>
                    <option value="unpaid" ${param.sort == 'unpaid' ? 'selected' : ''}>미결제 우선</option>
                    <option value="paid" ${param.sort == 'paid' ? 'selected' : ''}>결제 완료 우선</option>
                </select>
            </div>
            
            <c:choose>
                <c:when test="${empty list}">
                    <div style="text-align: center; padding: 100px 0; color: #999;">
                        <p>낙찰 받은 내역이 없습니다.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="won-item-list">
                        <c:forEach var="item" items="${list}">
                            <div class="won-item-card" onclick="location.href='${pageContext.request.contextPath}/auction/detail/${item.itemNo}'">
                                <img src="${item.imgUrl}" class="won-thumb" onerror="this.src='${pageContext.request.contextPath}/resources/images/no-image.png'">
                                
                                <div class="won-info">
                                    <span class="won-badge">낙찰</span>
                                    <h3 class="won-title">${item.itemTitle}</h3>
                                    <p class="won-date">종료일: <fmt:formatDate value="${item.endTime}" pattern="yyyy-MM-dd HH:mm"/></p>
                                </div>
                                
                                <div class="won-price-area">
                                    <p class="won-price-label">최종 낙찰가</p>
                                    <strong class="won-price"><fmt:formatNumber value="${item.currentPrice}" pattern="#,###"/> 원</strong>
                                    <div class="btn-group">
                                        <c:choose>
                                            <c:when test="${item.payStatus eq 'Y'}">
                                                <button class="pay-btn pay-btn-done" disabled>결제 완료</button>
                                            </c:when>
                                            <c:otherwise>
                                                <button class="pay-btn pay-btn-ready" onclick="proceedPayment(event, ${item.itemNo})">구매 확정/결제하기</button>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
</div>

<script>
// 정렬 변경 이벤트
document.getElementById('sortOrder').addEventListener('change', function() {
    location.href = '${pageContext.request.contextPath}/mypage/wonList?sort=' + this.value;
});

function proceedPayment(e, itemNo) {
    e.stopPropagation();
    if(!confirm("해당 물품의 결제를 진행하시겠습니까?")) return;
    location.href = '${pageContext.request.contextPath}/payment/checkout?itemNo=' + itemNo;
}
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />