<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>K-Bay 경매 물품 등록</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/headerFooterCss/header.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/headerFooterCss/footer.css">
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
				<label for="sizeUnit">측정 단위</label> <select id="sizeUnit"
					name="sizeUnit">
					<option value="cm">cm (센티미터)</option>
					<option value="inch">inch (인치)</option>
					<option value="㎡">㎡ (제곱미터)</option>
					<option value="kg">kg (킬로그램)</option>
				</select>
			</div>

			<div class="form-group">
				<label for="itemSize">물품 크기/수량</label> <input type="number"
					id="itemSize" name="itemSize" step="10" min="0"
					placeholder="단위에 맞는 수치를 입력하세요">
			</div>

			<div class="form-group">
				<label for="endTime">경매 종료 일시 (최대 10일)</label> <input
					type="datetime-local" id="endTime" name="endTime" required>
			</div>

			<div class="form-group">
				<label for="itemContent">상세 설명</label>
				<textarea id="itemContent" name="itemContent" rows="5" required></textarea>
			</div>

			<div class="form-group">
				<label for="upfiles">이미지 첨부</label> <input type="file"
					id="upfiles" name="upfiles" accept="image/*" multiple required>

				<div id="image-preview-container"
					style="display: flex; gap: 15px; margin-top: 15px; flex-wrap: wrap;"></div>
			</div>

			<button type="submit" class="submit-btn">물품 등록하기</button>


		</form>


	</main>



	<script>
		document.addEventListener('DOMContentLoaded', function() {
			const directBuy = document.getElementById('directBuy');
			const buyNowPrice = document.getElementById('BuyNowPrice');
			const priceGuide = document.getElementById('priceGuide');
			const sizeUnit = document.getElementById('sizeUnit');
			const itemSize = document.getElementById('item_Size');
			const startPriceInput = document.getElementById('startPrice');
			const upfiles = document.getElementById('upfiles');
			const previewContainer = document.getElementById('image-preview-container');
			
	        buyNowPrice.addEventListener('click', function() {
	            if (this.readOnly) {
	                alert("즉시 구매 가능 여부를 '가능'으로 먼저 변경해주세요");
	                directBuy.focus();
	            }
	        });
			
			
			// 이미지 미리보기 및 삭제(초기화) 로직
			upfiles.addEventListener('change', function(e) {
				previewContainer.innerHTML = "";
				const files = Array.from(e.target.files); 

				
				files.forEach(file => {
					if (!file.type.match('image.*')) {
						alert("이미지 파일만 업로드 가능합니다.");
						return;
					}
				
					const reader = new FileReader();
					reader.onload = function(event) {
						const card = document.createElement('div');
						card.style.cssText = "width: 120px; border: 1px solid #eee; padding: 5px; border-radius: 8px; background: #f9f9f9; text-align: center; position: relative;";

						const delBtn = document.createElement('button');
						delBtn.innerHTML = "&times;";
						delBtn.style.cssText = "position: absolute; top: -5px; right: -5px; width: 20px; height: 20px; border-radius: 50%; background: #ff5f5f; color: white; border: none; cursor: pointer;";
							
						delBtn.onclick = function() {
							upfiles.value = "";
							previewContainer.innerHTML = "";
						};
					
						const img = document.createElement('img');
						img.src = event.target.result;
						img.style.cssText = "width: 100%; height: 100px; object-fit: cover; border-radius: 5px;";

						const nameLabel = document.createElement('p');
						nameLabel.innerText = file.name;
						nameLabel.style.cssText = "font-size: 11px; color: #555; margin-top: 5px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;";

						card.appendChild(delBtn);
						card.appendChild(img);
						card.appendChild(nameLabel);
						previewContainer.appendChild(card);
					};
					reader.readAsDataURL(file);
				});
			});

			sizeUnit.addEventListener('change', function() {
				itemSize.placeholder = this.value + "를 입력하세요";
			});

			directBuy.addEventListener('change', function() {
				if (this.value === 'Y') {
					buyNowPrice.readOnly = false;
					buyNowPrice.style.backgroundColor = "#fff";
					buyNowPrice.style.cursor = "text";
					buyNowPrice.value = "";
					priceGuide.style.display = "block";
				} else {
					buyNowPrice.readOnly = true;
					buyNowPrice.style.backgroundColor = "#f1f1f1";
					buyNowPrice.style.cursor = "not-allowed";
					buyNowPrice.value = "0";
					priceGuide.style.display = "none";
				}
			});

			document.getElementById('enrollForm').addEventListener('submit', function(e) {
				const sPrice = parseInt(startPriceInput.value);
				const bPrice = parseInt(buyNowPrice.value);

				if (sPrice % 1000 !== 0 || (directBuy.value === 'Y' && bPrice % 1000 !== 0)) {
					alert("가격은 1000원 단위로만 입력이 가능합니다.");
					e.preventDefault();
					return;
				}
				
				if (directBuy.value === 'Y') {
					const minPrice = sPrice * 1.3;
					if (bPrice < minPrice) {
						alert("즉시 구매 가격은 시작 가격의 30% 이상 높아야 합니다.\n(최소 금액: " + Math.ceil(minPrice) + "원)");
						buyNowPrice.focus();
						e.preventDefault();
						return;
					}
				}
			});

			// 날짜 제한 설정
			const now = new Date();
			const tenDaysLater = new Date();
			tenDaysLater.setDate(now.getDate() + 10);

			function formatDate(date) {
				const tzOffset = date.getTimezoneOffset() * 60000;
				return new Date(date - tzOffset).toISOString().slice(0, 16);
			}

			const endTimeInput = document.getElementById('endTime');
			endTimeInput.min = formatDate(now);
			endTimeInput.max = formatDate(tenDaysLater);
		});
	</script>

	<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>