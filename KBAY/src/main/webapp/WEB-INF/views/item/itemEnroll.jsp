<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>K-Bay 경매 물품 등록</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/itemCss/itemEnroll.css">
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />

	<main class="enroll-container">
		<h2 class="section-title">경매 물품 등록</h2>

		<form action="${pageContext.request.contextPath}/auction/insert"
			method="post" enctype="multipart/form-data" id="enrollForm">

			<div class="form-group">
				<label for="itemCdNo">카테고리</label> <select id="itemCdNo"
					name="itemCdNo">
					<option value="1">디지털/가전</option>
					<option value="2">예술</option>
					<option value="3">도서/문헌</option>
					<option value="4">근현대생활사</option>
					<option value="5">컬렉터블</option>
					<option value="6">세컨핸드(중고)</option>
					<option value="7">키덜트</option>
				</select>
			</div>

			<div class="form-group">
				<label for="itemTitle">물품명</label> <input type="text" id="itemTitle"
					name="itemTitle" required>
			</div>

			<div class="form-group">
				<label for="startPrice">경매 시작 가격 (원)</label> <input type="number"
					id="startPrice" name="startPrice" step="1000" min="1000"
					placeholder="1000원 단위로 입력" required>
			</div>

			<div class="form-group">
				<label for="directBuy">즉시 구매 가능 여부</label> <select id="directBuy"
					name="directBuy">
					<option value="N">불가능</option>
					<option value="Y">가능</option>
				</select>
			</div>

			<div class="form-group">
				<label for="BuyNowPrice">즉시 구매 가격 (원)</label> <input type="number"
					id="BuyNowPrice" name="buyNowPrice" step="1000" min="0" value="0"
					readonly style="background-color: #f1f1f1; cursor: not-allowed;">
				<small id="priceGuide"
					style="color: #666; font-size: 12px; display: none;"> * 시작
					가격의 30% 이상 가격으로 설정해야 합니다. </small>
			</div>

			<div class="form-group">
				<label for="countryNo">제조국</label> <select id="countryNo"
					name="countryNo" required>
					<option value="">국가 선택</option>
					<option value="KOR">대한민국</option>
					<option value="USA">미국</option>
					<option value="JPN">일본</option>
					<option value="CHN">중국</option>
					<option value="FRA">프랑스</option>
					<option value="DEU">독일</option>
					<option value="RUS">러시아</option>
					<option value="BRA">브라질</option>
					<option value="IND">인도</option>
					<option value="CAN">캐나다</option>
					<option value="AUS">호주</option>
					<option value="ESP">스페인</option>
					<option value="ITA">이탈리아</option>
					<option value="ZAF">남아프리카공화국</option>
					<option value="MEX">멕시코</option>
					<option value="SWE">스웨덴</option>
					<option value="NOR">노르웨이</option>
					<option value="FIN">핀란드</option>
					<option value="GBR">영국</option>
					<option value="ETC">기타 국가</option>
				</select>
			</div>

			<div class="form-group">
				<label for="sizeUnit">물품 사이즈</label> <select id="sizeUnit"
					name="sizeUnit">
					<option value="cm">cm (센티미터)</option>
					<option value="inch">inch (인치)</option>
					<option value="㎡">㎡ (제곱미터)</option>
					<option value="kg">kg (킬로그램)</option>
				</select>
			</div>

			<div class="form-group">
				<label for="itemSize">물품 크기</label> <input type="number"
					id="itemSize" name="itemSize" step="10" min="0"
					placeholder="단위에 맞는 수치를 입력하세요">
			</div>

			<div class="form-group">
				<label for="startTime">경매 시작 일시</label> <input type="datetime-local"
					id="startTime" name="startTime" required>
			</div>
			
			<div class="form-group">
				<label for="endTime">경매 종료 일시 (최대 10일)</label> <input
					type="datetime-local" id="endTime" name="endTime" required>
			</div>

			<div class="form-group">
				<label for="itemContent">상세 설명</label>
				<textarea id="itemContent" name="itemContent" rows="5" required></textarea>
				<div id="byte-counter-area"
					style="text-align: right; margin-top: 5px; font-size: 13px; color: #666;">
					<span id="nowByte">0</span> / 200 byte
				</div>
			</div>

			<div class="form-group" id="dropZone" style="padding: 10px; border-radius: 8px; transition: 0.3s;">
			    <label for="upfiles">이미지 첨부</label> 
			    <input type="file" id="upfiles" name="upfiles" accept="image/*" multiple required>
			</div>
				<div id="image-preview-container" style="display: flex; gap: 15px; margin-top: 15px; flex-wrap: wrap;"></div>
			

			<button type="submit" class="submit-btn">물품 등록하기</button>


		</form>


	</main>



	<script src="${pageContext.request.contextPath}/resources/js/itemJs/itemEnroll.js"></script>
	

	<jsp:include page="/WEB-INF/views/common/footer.jsp" />
	
	<c:if test="${needVerification}">
	
	<script>
	    // 🔥 전역으로 선언 (핵심)
	    window.isVerified = false;
	
	    alert("물품등록을 하시려면 최초 1회 본인인증을 하셔야 합니다.");
	
	    const popup = window.open(
	        '${pageContext.request.contextPath}/member/verify',
	        'verifyPopup',
	        'width=500,height=600'
	    );
	
	    const checkPopup = setInterval(function() {
	
	        if(popup.closed) {
	            clearInterval(checkPopup);
	
	            // 🔥 최신 상태 반영됨
	            if(!window.isVerified) {
	
	                alert("본인인증이 완료되지 않았습니다. 3초 후 홈으로 이동합니다.");
	
	                setTimeout(function() {
	                    location.href = "${pageContext.request.contextPath}/";
	                }, 3000);
	            }
	        }
	
	    }, 500);
	</script>
	
	<style>
	    form input, form textarea, form select, form button {
	        pointer-events: none;
	        opacity: 0.5;
	    }
	</style>
	
	</c:if>
</body>
</html>