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