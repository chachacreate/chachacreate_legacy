let cpath="";

$(() => {
		cpath = document.getElementById("cpath").value;
		
		mainHomeInfo();
});

// 인기 스토어 조회
function mainHomeInfo(){
	const link = `${cpath}/api/main`;
	
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
      <div class="swiper-slide" onclick="location.href='${cpath}/${bs.storeUrl}'">
        <div class="card">
          <img class="store-img" src="${cpath}/resources/productImages/${bs.logoImg}" alt="${bs.storeName}">
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

// 인기 상품 렌더링
function renderBestProduct(bestProduct) {
  const bestProductArea = document.getElementById("swiper-wrapper");

  let html = "";

  bestProduct.forEach((bf) => {
    const priceText = bf.price
      ? Number(bf.price).toLocaleString() + "원"  : "가격 정보 없음";

    html += `
      <div class="swiper-slide" onclick="location.href='${cpath}/main/productdetail/${bf.productId}'">
        <div class="product-card">   
          <div class="product-image-box">
            <img class="product-img" src="${cpath}/resources/productImages/${bf.pimgUrl}" alt="${bf.productName}">
            <div class="product-icon">
              <a href="${cpath}/main/productdetail/${bf.productId}">
                <span class="material-symbols-outlined">arrow_outward</span>
              </a>
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


// 신상품 렌더링
function renderNewProduct(newProduct) {
  const newProductArea = document.getElementById("preview-grid");

  if (!newProductArea) {
    console.warn("❗ preview-grid 요소가 존재하지 않습니다.");
    return;
  }

  let html = "";

  newProduct.forEach((nf) => {
    const priceText = nf.price
      ? Number(nf.price).toLocaleString() + "원"
      : "가격 정보 없음";

    html += `
      <div class="preview-card" onclick="location.href='${cpath}/main/productdetail/${nf.productId}'">
        <img class="new-product-img" src="${cpath}/resources/productImages/${nf.pimgUrl}" alt="${nf.productName}">
        <p class="product-name">${nf.productName}</p>
        <p class="product-price">${priceText}</p>
      </div>    		
    `;
  });

  newProductArea.innerHTML = html;
}


// 금주의 인기 스토어 1위
function renderTopStore(store){
	topStoreArea = document.getElementById("topStore");
	
	let html =`
				<div class="text-area" >
				<h4>${store.categoryName} '${store.storeName}'</h4>
			      <p class="discount">${store.storeDetail}</p>
			      <a href="${cpath}/${store.storeUrl}" class="side-banner-btn">바로가기</a>
			    </div>
			    <div class="image-area">
			      <img src="${cpath}/resources/images/${store.logoImg}"
			      style="height: 120px;"
			       alt="${store.storeName}">
			    </div>	
	`;
	topStoreArea.innerHTML = html;
};





























