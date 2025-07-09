document.addEventListener("DOMContentLoaded", function () {
  const pathSegments = window.location.pathname.split("/");
  const storeUrl = pathSegments[2];
  const productId = pathSegments[4];
  const cpath = document.body.getAttribute("data-cpath") || "";
  const apiUrl = `${cpath}/api/${storeUrl}/productdetail/${productId}`;

  // 이미지 경로를 절대 경로로 변환(추후 변경 필요할 수도)
  function getImageUrl(imgPath) {
    if (!imgPath) return "";
    if (imgPath.startsWith("http://") || imgPath.startsWith("https://")) {
      return imgPath;
    }
    if (imgPath.includes("resources/productImages")) {
      return `${cpath}/${imgPath}`;
    }
    return `${cpath}/resources/productImages/${imgPath}`;
  }

  $.ajax({
    url: apiUrl,
    method: "GET",
    dataType: "json",
    success: function (res) {
      const detail = res.data;
      const product = detail.productDetail;

      // 기본 정보 세팅
      document.getElementById("productTitle").textContent = product.productName;
      document.getElementById("productTypeCategory").textContent = product.typeCategoryName;
      document.getElementById("productUCategory").textContent = product.ucategoryName;
      document.getElementById("productDCategory").textContent = product.dcategoryName;

      const storeLink = document.getElementById("storeNameLink");
      if (storeLink) {
        storeLink.href = `${cpath}/store/info`;
        storeLink.textContent = product.storeName;
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
		    url: `${cpath}/api/main/mypage/cart`,
		    method: "POST",
		    contentType: "application/json",
		    data: JSON.stringify(cartData),
		    success: function(response) {
		      alert("장바구니에 추가되었습니다.");
		      // 성공 후 장바구니 페이지로 이동
		      location.href = `${cpath}/main/mypage/cart`;
		    },
		    error: function(xhr, status, error) {
		      alert("장바구니 추가 실패: " + error);
		      console.error(error);
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