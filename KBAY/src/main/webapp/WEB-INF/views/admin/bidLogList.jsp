<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/adminCss/admin.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/adminCss/bidLogs.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<div class="admin-wrap">
    <jsp:include page="/WEB-INF/views/admin/adminSidebar.jsp" />

    <main class="main-content">
        
		<h2>입찰 로그 관리</h2>
		
		<table class="item-table">
		    <tr>
		        <th>상품번호</th>
		        <th>상품명</th>
		        <th>현재가</th>
		        <th>입찰수</th>
		        <th>상태</th>
		    </tr>
		
		    <c:forEach var="i" items="${list}">
		        <tr onclick="openBidLog(${i.ITEM_NO})">
		            <td>${i.ITEM_NO}</td>
		            <td>${i.ITEM_TITLE}</td>
		            <td>${i.CURRENT_PRICE}</td>
		            <td>${i.BID_COUNT}</td>
		            <td>${i.STATUS}</td>
		        </tr>
		    </c:forEach>
		</table>
		
		<!-- 모달 -->
		<div id="bidModal" class="modal" style="display:none">
		    <div class="modal-content">
		        <span class="close" onclick="closeModal()">×</span>
		        <h3>입찰 로그</h3>
		
		        <table id="bidTable" class="bidTable">
		            <thead>
		                <tr>
		                    <th>시간</th>
		                    <th>유저</th>
		                    <th>입찰가</th>
		                    <th>순위</th>
		                    <th>IP</th>
		                </tr>
		            </thead>
		            <tbody></tbody>
		        </table>
		    </div>
		</div>


    </main>
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />
<script>
const contextPath = "${contextPath}";

window.openBidLog = function(itemNo) {
    $.ajax({
        url: contextPath + "/admin/logs/" + itemNo,
        method: "GET",
        success: function(data) {
            let tbody = $("#bidTable tbody");
            tbody.empty();

            data.forEach(b => {
            	let timeStr = formatTime(b.bidTime);
            	let priceStr = formatPrice(b.bidPrice);
            	let rowClass = "";
            	if (b.ranking === 1) {
            	    rowClass = "bid-winner";
            	}
            	if (b.ranking > 3) {
            	    rowClass = "bid-loser";
            	}

            	let row = `
            	<tr class="${rowClass}">
            	    <td class="bid-time">\${timeStr}</td>
            	    <td>\${b.userId}</td>
            	    <td class="bid-price">\${priceStr}</td>
            	    <td>\${b.ranking == null ? '-' : b.ranking}</td>
            	    <td>\${b.bidIp}</td>
            	</tr>
            	`;
                tbody.append(row);
            });

            $("#bidModal").show();
        }
    });
};

function closeModal() {
    $("#bidModal").hide();
}

function formatTime(time) {
    if (!time) return '-';
    return new Date(time).toLocaleString();
}

function formatPrice(price) {
    if (!price) return '-';
    return price.toLocaleString() + "원";
}
</script>
</body>
</html>