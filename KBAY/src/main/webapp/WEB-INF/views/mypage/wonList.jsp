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
                                <img src="${item.imgUrl}" class="won-thumb"
                                     onerror="this.onerror=null; this.src='https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg';">
                                
                                <div class="won-info">
                                    <span class="won-badge">낙찰</span>
                                    <h3 class="won-title">${item.itemTitle}</h3>
                                    <p class="won-date">종료일: <fmt:formatDate value="${item.endTime}" pattern="yyyy-MM-dd HH:mm"/></p>
                                </div>
                                
                                <div class="won-price-area">
                                    <p class="won-price-label">최종 낙찰가</p>
                                    <strong class="won-price"><fmt:formatNumber value="${item.currentPrice}" pattern="#,###"/> 원</strong>
                                    <div class="btn-group" style="display: flex; gap: 10px;">
   									 <c:choose>
      								  <c:when test="${item.payStatus eq 'Y'}">
      								      <button class="pay-btn pay-btn-done" style="flex: 1;" disabled>결제 완료</button>
     								      <button class="pay-btn pay-btn-view" style="flex: 1; background-color: #f2f4f6; color: #3282f6; border: 1px solid #3282f6;"
       								             onclick="viewReceipt(event, ${item.itemNo})">내역 보기</button>
     										 </c:when>
  								  		  	   <c:otherwise>
  						               		    <button class="pay-btn pay-btn-ready" onclick="proceedPayment(event, ${item.itemNo})">
  								                 구매 확정/결제하기
  								      		    </button>
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
        
        <div id="receiptModal" class="modal-overlay">
    		<div class="receipt-card modal-content">
		        <div class="receipt-header">
		            <div class="success-icon">
		                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
		                    <polyline points="20 6 9 17 4 12"></polyline>
		                </svg>
		            </div>
		            <h2>결제 내역 상세</h2>
		            <span class="close-modal" onclick="closeReceiptModal()">&times;</span>
		        </div>

		        <div class="receipt-body">
		            <div class="item-summary">
		                <span class="label">결제 상품</span>
		                <strong id="m-orderName" class="value"></strong>
		            </div>
		            
		            <div class="price-major">
		                <span class="label">최종 결제 금액</span>
		                <strong class="amount">
		                    <span id="m-totalAmount"></span>
		                    <span class="unit">원</span>
		                </strong>
		            </div>
		
		            <div class="detail-list">
		                <div class="detail-item">
		                    <span class="d-label">주문번호</span>
		                    <span id="m-orderId" class="d-value"></span>
		                </div>
		                <div class="detail-item">
		                    <span class="d-label">결제수단</span>
		                    <span id="m-method" class="d-value"></span>
		                </div>
		                <div class="detail-item">
		                    <span class="d-label">결제일시</span>
		                    <span id="m-approvedAt" class="d-value"></span>
		                </div>
		            </div>
		        </div>
		
		        <div class="receipt-footer">
		            <button type="button" class="btn-secondary" id="m-receiptUrlBtn">
		                공식 영수증 확인
		            </button>
		            <button type="button" class="btn-primary" onclick="closeReceiptModal()">
		                닫기
		            </button>
		        </div>
		    </div>
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

function viewReceipt(e, itemNo) {
    e.stopPropagation();
    
    fetch(`${pageContext.request.contextPath}/payment/api/receipt/` + itemNo)
        .then(response => response.json())
        .then(data => {
            document.getElementById("m-orderName").innerText = data.orderName;
            document.getElementById("m-totalAmount").innerText = data.totalAmount.toLocaleString();
            document.getElementById("m-orderId").innerText = data.orderId;
            document.getElementById("m-method").innerText = data.method;
            
            let dateStr = data.approvedAt;
            if(dateStr && dateStr.includes('T')) {
                dateStr = dateStr.substring(0,10) + " " + dateStr.substring(11,19);
            }
            document.getElementById("m-approvedAt").innerText = dateStr;
            
            document.getElementById("m-receiptUrlBtn").onclick = () => {
                window.open(data.receiptUrl, 'receipt', 'width=500,height=700');
            };
            
            document.getElementById("receiptModal").style.display = "flex";
        })
        .catch(err => {
            console.error(err);
            alert("결제 내역을 불러오는 중 오류가 발생했습니다.");
        });
}

function closeReceiptModal() {
    document.getElementById("receiptModal").style.display = "none";
}

window.onclick = function(event) {
    const modal = document.getElementById("receiptModal");
    if (event.target == modal) {
        modal.style.display = "none";
    }
}
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />