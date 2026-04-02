<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mypageCss/mypage.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mypageCss/wonList.css">

<div class="mypage-container">
    <jsp:include page="/WEB-INF/views/mypage/mypageSidebar.jsp" />
    
    <main class="mypage-main"> 
        <div class="mypage-content">
            <div class="content-title" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; border-bottom: 2px solid #333; padding-bottom: 10px;">
                <h2 style="font-size: 24px; margin: 0;">낙찰 받은 물품</h2>
                
                <select id="sortOrder" class="sort-select">
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
                                <img src="${item.imgUrl}" class="won-thumb" onerror="this.onerror=null; this.src='https://kbay.s3.ap-northeast-2.amazonaws.com/default/no-image.png';">
                                
                                <div class="won-info">
                                    <c:choose>
                                        <c:when test="${item.payStatus eq 'Y'}"><span class="badge badge-y">결제 완료</span></c:when>
                                        <c:when test="${item.payStatus eq 'S'}"><span class="badge badge-s">배송 중</span></c:when>
                                        <c:when test="${item.payStatus eq 'P'}"><span class="badge badge-p">거래 완료</span></c:when>
                                        <c:when test="${item.payStatus eq 'C'}"><span class="badge badge-c">취소됨</span></c:when>
                                        <c:otherwise><span class="badge badge-n">미결제</span></c:otherwise>
                                    </c:choose>
                                    
                                    <h3 class="won-title">${item.itemTitle}</h3>
                                    <p class="won-date">종료일: <fmt:formatDate value="${item.endTime}" pattern="yyyy-MM-dd HH:mm"/></p>
                                </div>
                                
                                <div class="won-price-area">
                                    <p class="won-price-label">최종 낙찰가</p>
                                    <strong class="won-price"><fmt:formatNumber value="${item.currentPrice}" pattern="#,###"/> 원</strong>
                                    
                                    <div class="btn-group">
                                        <c:choose>
                                            <%-- 1. 미결제 (N) --%>
                                            <c:when test="${empty item.payStatus or item.payStatus eq 'N'}">
                                                <button type="button" class="pay-btn-ready" onclick="proceedPayment(event, ${item.itemNo})">결제하기</button>
                                                <button type="button" class="btn-cancel" onclick="cancelOrder(event, ${item.itemNo})">취소</button>
                                            </c:when>

                                            <%-- 2. 결제 완료(Y) 또는 배송 중(S) --%>
                                            <c:when test="${item.payStatus eq 'Y' or item.payStatus eq 'S'}">
                                                <button type="button" class="btn-outline-blue" onclick="openDetailModal(event, ${item.itemNo})">내역 보기</button>
                                            </c:when>

                                            <%-- 3. 거래 완료(P) --%>
                                            <c:when test="${item.payStatus eq 'P'}">
                                                <button type="button" class="btn-review" onclick="openReviewModal(event, ${item.itemNo}, '${item.sellerName != null ? item.sellerName : '판매자'}')">거래 후기</button>
                                                <button type="button" class="btn-outline-blue" onclick="openDetailModal(event, ${item.itemNo})">내역 보기</button>
                                            </c:when>
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

<div id="detailModal" class="modal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.5); z-index: 1000;">
    <div class="modal-content" style="background: white; width: 400px; margin: 150px auto; padding: 25px; border-radius: 12px; text-align: center; position: relative;">
        <h3 style="margin-bottom: 20px;">거래 상세 내역</h3>
        <div style="display: flex; flex-direction: column; gap: 15px;">
            <button type="button" id="btnReceipt" class="btn-blue" style="width: 100%; padding: 12px; cursor: pointer; background: #3282f6; color: white; border: none; border-radius: 6px;">📄 영수증 보기</button>
            <button type="button" id="btnDelivery" class="btn-receipt" style="width: 100%; padding: 12px; cursor: pointer; background: #f8f9fa; border: 1px solid #ddd; border-radius: 6px;">🚚 배송내역 조회</button>
            <button type="button" onclick="closeDetailModal()" class="btn-gray" style="width: 100%; padding: 12px; cursor: pointer; background: #eee; border: none; border-radius: 6px;">닫기</button>
        </div>
        <div id="deliveryInfoArea" style="display: none; margin-top: 20px; padding: 15px; background: #f8f9fa; border-radius: 8px; text-align: left; font-size: 0.9em; border: 1px solid #eee;">
            <p style="margin: 5px 0;"><strong>택배사:</strong> <span id="textCourier"></span></p>
            <p style="margin: 5px 0;"><strong>운송장 번호:</strong> <span id="textTracking"></span></p>
            <p style="color: #3282f6; font-size: 0.8em; margin-top: 10px;">* 실제 배송 추적은 해당 택배사 홈페이지를 이용해주세요.</p>
        </div>
    </div>
</div>
	
	<%-- 거래 완료 후 좋아요 모달 --%> 
<div id="reviewModal" class="modal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.5); z-index: 1100;">
    <div class="modal-content" style="background: white; width: 350px; margin: 200px auto; padding: 25px; border-radius: 12px; text-align: center;">
        <h3 id="reviewTitle" style="margin-bottom: 20px; font-size: 1.1em; line-height: 1.5;"></h3>
        <input type="hidden" id="reviewItemNo">
        <div style="display: flex; gap: 10px;">
            <button type="button" onclick="submitReview('like')" style="flex: 1; padding: 12px; background: #3282f6; color: white; border: none; border-radius: 6px; font-weight: bold; cursor: pointer;">네, 최고예요! 👍</button>
            <button type="button" onclick="closeReviewModal()" style="flex: 1; padding: 12px; background: #eee; border: none; border-radius: 6px; font-weight: bold; cursor: pointer;">아니요</button>
        </div>
    </div>
</div>

<script>
document.getElementById('sortOrder').addEventListener('change', function() {
    location.href = '${pageContext.request.contextPath}/mypage/wonList?sort=' + this.value;
});

function proceedPayment(e, itemNo) {
    if (e) e.stopPropagation();
    if(!confirm("해당 물품의 결제를 진행하시겠습니까?")) return;
    location.href = '${pageContext.request.contextPath}/payment/checkout?itemNo=' + itemNo;
}

function openDetailModal(e, itemNo) {
    if (e) {
        e.stopPropagation();
        e.preventDefault();
    }

    document.getElementById("deliveryInfoArea").style.display = "none";
    document.getElementById("textCourier").innerText = "";
    document.getElementById("textTracking").innerText = "";

    fetch('${pageContext.request.contextPath}/payment/api/detail/' + itemNo)
    .then(res => res.json())
    .then(data => {
        const pay = data.payment;
        const del = data.delivery;

        if(pay && pay.receiptUrl) {
            document.getElementById("btnReceipt").onclick = function() {
                window.open(pay.receiptUrl, 'receipt', 'width=500,height=700');
            };
            document.getElementById("btnReceipt").style.display = "block";
        } else {
            document.getElementById("btnReceipt").style.display = "none";
        }

        if(del && del.trackingNo) {
            document.getElementById("btnDelivery").onclick = function() {
                document.getElementById("textCourier").innerText = del.courier;
                document.getElementById("textTracking").innerText = del.trackingNo;
                document.getElementById("deliveryInfoArea").style.display = "block";
            };
        } else {
            document.getElementById("btnDelivery").onclick = function() {
                alert("아직 판매자가 배송 정보를 등록하지 않았습니다.");
            };
        }

        document.getElementById("detailModal").style.display = "block";
    })
    .catch(err => {
        console.error(err);
        alert("내역을 불러오는 중 오류가 발생했습니다.");
    });
}

function closeDetailModal() {
    document.getElementById("detailModal").style.display = "none";
}

window.onclick = function(event) {
    const detailModal = document.getElementById("detailModal");
    if (event.target == detailModal) {
        detailModal.style.display = "none";
    }
}

function openReviewModal(e, itemNo, sellerName) {
    if (e) e.stopPropagation();
    document.getElementById("reviewItemNo").value = itemNo;
    document.getElementById("reviewTitle").innerHTML = `<strong>\${sellerName}</strong>님과의 거래,<br>만족스러우셨나요?`;
    document.getElementById("reviewModal").style.display = "block";
}

function closeReviewModal() {
    document.getElementById("reviewModal").style.display = "none";
}

function submitReview(type) {
    const itemNo = document.getElementById("reviewItemNo").value;
    
    fetch(`${pageContext.request.contextPath}/mypage/increaseLike?itemNo=\${itemNo}`, { method: 'POST' })
    .then(res => res.text())
    .then(result => {
        if(result === "success") {
            alert("후기가 반영되었습니다! 감사합니다.");
            location.reload();
        }
    });
}

function cancelOrder(e, itemNo) {
    if (e) e.stopPropagation();
    if(confirm("정말 낙찰을 취소하시겠습니까?")) {
        // 취소 로직 (상태를 'C'로 변경)
        location.href = `${pageContext.request.contextPath}/mypage/cancelOrder?itemNo=\${itemNo}`;
    }
}
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />