let cpath="";

$(() => {
		cpath = document.getElementById("cpath").value;
		
		mainHomeInfo();
});

// 인기 스토어 조회
function mainHomeInfo(){
	const link = `${cpath}/legacy/main`;
	
	$.ajax({
		url: link,
		dataType: "json",
		success:function(result){
			bestStore = result.data.bestStore.filter(store => store.storeName !== null);
			bestProduct = result.data.bestProduct;
			newProduct = result.data.newProduct;
			topRankStore = result.data.bestStore[0];
			renderBestStore(bestStore);
			renderBestProduct(bestProduct);
			renderNewProduct(newProduct);
			renderTopStore(topRankStore);
		},
		error: function (xhr, status, error) {
	      console.error("전체 조회 실패:", error);
	    }
	});
};


// 인기 스토어 렌더링
function renderBestStore(bestStore) {
  const storeArea = document.getElementById("store-swiper-wrapper");

  let html = "";

  bestStore.forEach((bs) => {
    html += `
      <div class="swiper-slide" onclick="clickStore('${bs.storeId}', '${bs.storeUrl}')">
        <div class="card">
          <img class="store-img" src="${bs.logoImg}" alt="${bs.storeName}">
          <h3>${bs.storeName}</h3>
          <div class="category-list">
            <span class="category-tag">${bs.categoryName}</span>
          </div>
          <p class="store-desc">${bs.storeDetail}</p>
        </div>
      </div>
    `;
  });

  storeArea.innerHTML = html;
}

// 스토어 클릭 시: GET 요청 + 페이지 이동
function clickStore(storeId, storeUrl) {
  $.ajax({
    url: `${cpath}/legacy/main/store/click/${storeId}`,
    method: "GET",
    success: function () {
      window.location.href = `${cpath}/${storeUrl}`;
    },
    error: function () {
      window.location.href = `${cpath}/${storeUrl}`;
    }
  });
}

// 인기 상품 렌더링
function renderBestProduct(bestProduct) {
  const bestProductArea = document.getElementById("swiper-wrapper");

  let html = "";

  bestProduct.forEach((bf) => {
    const priceText = bf.price
      ? Number(bf.price).toLocaleString() + "원"  : "가격 정보 없음";

    html += `
      <div class="swiper-slide" onclick="clickProduct('${bf.productId}', '${bf.storeUrl || 'main'}')">
        <div class="product-card">   
          <div class="product-image-box">
            <img class="product-img" src="${bf.pimgUrl}" alt="${bf.productName}">
            <div class="product-icon">
              <div onclick="clickProduct('${bf.productId}')">
                <span class="material-symbols-outlined">arrow_outward</span>
              </div>
            </div>
          </div>
          <div class="product-content">
            <h3>${bf.productName}</h3>
            <div class="category-badges">
              <span class="badge">${bf.typeCategoryName}</span>
              <span class="badge">${bf.ucategoryName}</span>
              <span class="badge">${bf.dcategoryName}</span>
            </div>
            <p class="product-price">${priceText}</p>
          </div>
        </div>
      </div>
    `;
  });

  bestProductArea.innerHTML = html;
}

// 상품 클릭 시: GET 요청 + 페이지 이동
function clickProduct(productId, storeUrl) {
  $.ajax({
    url: `${cpath}/legacy/click/${productId}`,
    method: "GET",
    success: function () {
      window.location.href = `${cpath}/${storeUrl}/products/${productId}`;
    },
    error: function () {
      window.location.href = `${cpath}/${storeUrl}/products/${productId}`;
    }
  });
}


// 신상품 렌더링
function renderNewProduct(newProduct) {
  const newProductArea = document.getElementById("preview-grid");

  if (!newProductArea) {
    console.warn("❗ preview-grid 요소가 존재하지 않습니다.");
    return;
  }

  let html = "";

  newProduct.forEach((nf) => {
  	if(nf.storeUrl === null){nf.storeUrl = "main";}
    const priceText = nf.price
      ? Number(nf.price).toLocaleString() + "원"
      : "가격 정보 없음";

    html += `
      <div class="preview-card" onclick="clickProductWithStoreUrl('${nf.productId}', '${nf.storeUrl}')">
        <img class="new-product-img" src="${nf.pimgUrl}" alt="${nf.productName}">
        <p class="product-name">${nf.productName}</p>
        <p class="product-price">${priceText}</p>
      </div>    		
    `;
  });

  newProductArea.innerHTML = html;
}

// 상품 클릭 시: GET 요청 + 스토어 페이지 이동
function clickProductWithStoreUrl(productId, storeUrl) {
  $.ajax({
    url: `${cpath}/legacy/click/${productId}`,
    method: "GET",
    success: function () {
      window.location.href = `${cpath}/${storeUrl}/products/${productId}`;
    },
    error: function () {
      window.location.href = `${cpath}/${storeUrl}/products/${productId}`;
    }
  });
}

// 금주의 인기 스토어 1위
function renderTopStore(store){
	topStoreArea = document.getElementById("topStore");
	
	let html =`
				<div class="image-area" onclick="clickStore('${store.storeId}', '${store.storeUrl}')">
			      <img src="${store.logoImg}"
			      style="height: 80px;"
			       alt="${store.storeName}">
			    </div>	
				<div class="text-area" >
				<h4>${store.categoryName} '${store.storeName}'</h4>
			          <p style="
					      display: -webkit-box;
					      -webkit-line-clamp: 1;
					      -webkit-box-orient: vertical;
					      overflow: hidden;
					      text-overflow: ellipsis;
					      margin: 0;
					    ">${store.storeDetail}</p>
			    </div>
	`;
	topStoreArea.innerHTML = html;
};





























