window.product = null;

document.addEventListener("DOMContentLoaded", function () {
  const pathSegments = window.location.pathname.split("/");
  const storeUrl = pathSegments[pathSegments.length - 3];
  const productId = pathSegments[pathSegments.length - 1];
  const cpath = document.body.getAttribute("data-cpath") || "";
  const apiUrl = `${cpath}/legacy/${storeUrl}/productdetail/${productId}`;
  
  // 나의 상품이면 수정 버튼 보이게
	$.ajax({
	  url: `${cpath}/legacy/auth/editable/${productId}`,
	  method: "GET",
	  dataType: "json",
	  success: function(res) {
	    if (res.data === true) {
	      $('#editProductBtn').show().on('click', function () {
	        if (storeUrl === 'main') {
	          window.location.href = `${cpath}/main/sell/sellregister`;
	        } else {
	          window.location.href = `${cpath}/${storeUrl}/seller/productupdate/${productId}`;
	        }
	      });
	    }
	  },
	  error: function(xhr, status, err) {
	    console.warn("수정 권한 확인 실패", err);
	  }
	});


  // 이미지 경로를 절대 경로로 변환(추후 변경 필요할 수도)
  function getImageUrl(imgPath) {
    if (!imgPath) return "";
    if (imgPath.startsWith("http://") || imgPath.startsWith("https://")) {
      return imgPath;
    }
    if (imgPath.includes("resources/productImages")) {
      return `${cpath}/${imgPath}`;
    }
    return `${imgPath}`;
  }

  $.ajax({
    url: apiUrl,
    method: "GET",
    dataType: "json",
    success: function (res) {
      const detail = res.data;
      product = detail.productDetail;

      // 기본 정보 세팅
      document.getElementById("productName").textContent = product.productName;
      document.getElementById("productTypeCategory").textContent = product.typeCategoryName;
      document.getElementById("productUCategory").textContent = product.ucategoryName;
      document.getElementById("productDCategory").textContent = product.dcategoryName;

      const storeLink = document.getElementById("storeNameLink");
      if (storeLink) {
        storeLink.textContent = product.storeName || "뜨락상회";
        if(storeLink.textContent === "뜨락상회") {
        		storeLink.href = `${cpath}/main/products`;
        	} else storeLink.href = `${cpath}/${storeUrl}/info`;
        }

      // 가격 및 수량 관련 로직
      const priceElement = document.getElementById("productPrice");
      const unitPrice = product.price;
      let quantity = 1;
      const maxQuantity = product.stock;

      const updateTotalPrice = () => {
        priceElement.textContent = `${(unitPrice * quantity).toLocaleString()} 원`;
      };

      // 메인 이미지 및 썸네일 설정
      const mainImg = document.querySelector(".main-image img");
      const thumbRow = document.getElementById("thumbnailRow");
      mainImg.src = getImageUrl(detail.mainThumbnailUrl);
      thumbRow.innerHTML = "";

      detail.thumbnailImageUrls.forEach(imgName => {
        const img = document.createElement("img");
        img.src = getImageUrl(imgName);
        img.alt = "썸네일";
        img.classList.add("thumbnail");
        thumbRow.appendChild(img);
      });

      // 상세 설명 이미지 출력
      const detailImgContainer = document.querySelector(".img-ex");
      detailImgContainer.innerHTML = "";
      detail.descriptionImageUrls.forEach(imgName => {
        const img = document.createElement("img");
        img.src = getImageUrl(imgName);
        img.classList.add("detail-img");
        detailImgContainer.appendChild(img);
      });

      document.querySelector(".detail-text-middle").innerHTML = `<b>${product.productDetail}</b>`;

      // 수량 조절 버튼
      const minusBtn = document.querySelector(".quantity-btn.minus");
      const plusBtn = document.querySelector(".quantity-btn.plus");
      const display = document.querySelector(".quantity-display");

      const updateDisplay = () => {
        display.textContent = quantity;
        updateTotalPrice();
      };

      minusBtn.addEventListener("click", () => {
        if (quantity > 1) {
          quantity--;
          updateDisplay();
        }
      });

      plusBtn.addEventListener("click", () => {
        if (quantity < maxQuantity) {
          quantity++;
          updateDisplay();
        }
      });

      updateDisplay();

      // 썸네일 클릭 시 메인 이미지 변경
      document.addEventListener("click", function (e) {
        if (e.target.classList.contains("thumbnail")) {
          mainImg.src = e.target.src;
        }
      });

      // 장바구니 버튼 클릭 시 상품 추가
        const cartBtn = document.querySelector(".cart-button");
		cartBtn.addEventListener("click", function (e) {
		e.preventDefault();
		  const cartData = {
		    productId: product.productId,
		    productCnt: quantity
		  };
		
		  $.ajax({
		    url: `${cpath}/legacy/main/mypage/cart`,
		    method: "POST",
		    contentType: "application/json",
		    data: JSON.stringify(cartData),
		    success: function(response) {
		      alert("장바구니에 추가되었습니다.");
		      // 성공 후 장바구니 페이지로 이동
		      if (!confirm("장바구니로 이동하시겠습니까?")) return;
		      location.href = `${cpath}/${storeUrl}/mypage/cart`;
		    },
		    error: function(xhr, status, error) {
		      alert("장바구니 추가 실패: " + error);
		      console.error(error);
		    }
		  });
		});
		
		// 선택된 상품을 session에 저장해 order로 보내기
		$(document).on("click", ".buy-button", function () {
		  const productId = product.productId;
		  const productName = $("#productName").text().trim();
		  const storeName = $("#storeName").text().trim();
		  const quantity = parseInt($(".quantity-display").text(), 10);
		  const price = product.price;
		  const pimgUrl = $(".main-image img").attr("src");
		
		  if (!productId || quantity <= 0) {
		    alert("상품 정보가 유효하지 않습니다.");
		    return;
		  }
		
		  const item = {
		    productId,
		    productName,
		    storeName,
		    productCnt: quantity,
		    price,
		    pimgUrl
		  };
		
		  // sessionStorage에 저장
		  sessionStorage.setItem("orderItems", JSON.stringify([item]));
		  console.log(item);
		
		  // 결제 페이지로 이동
		  window.location.href = `${cpath}/${storeUrl}/order`;
		});

		
		
		
 	  // 판매자 신고 모달
      $('#reportBtn').off('click').on('click', function () {
        if (!window.loggedInMemberId || window.loggedInMemberId === 'null') {
          alert('로그인이 필요합니다.');
          location.href = `${cpath}/auth/login`;
          return;
        }
        $('#reportModal').fadeIn();
      });

      $('#cancelReport').on('click', function () {
        $('#reportModal').fadeOut();
        $('#reportTitle').val('');
        $('#reportText').val('');
      });

      $('#submitReport').on('click', function () {
        const title = $('#reportTitle').val().trim();
        const reason = $('#reportText').val().trim();
        const memberCheck = 0;
        const storeId = product.storeId;

        if (!title || !reason) {
          alert('신고 제목과 사유를 모두 입력하세요.');
          return;
        }

        const reportData = {
          storeId: storeId,
          reportTitle: title,
          reportText: reason,
          memberCheck: memberCheck
        };

        $.ajax({
          url: `${cpath}/legacy/${storeUrl}/reportinsert`,
          method: 'POST',
          contentType: 'application/json',
          data: JSON.stringify(reportData),
          success: function (res) {
            if (res.status === 201) {
              alert('신고가 접수되었습니다.');
              $('#reportModal').fadeOut();
              $('#reportTitle').val('');
              $('#reportText').val('');
            } else {
              alert('신고 실패: ' + res.message);
            }
          },
          error: function (xhr) {
            alert('신고 처리 중 오류 발생');
            console.error(xhr);
          }
        });
      });
    },
    error: function (xhr, status, error) {
      console.error("상품 정보 로딩 실패:", error);
      alert("상품 정보를 불러오지 못했습니다.");
    }
  });
});