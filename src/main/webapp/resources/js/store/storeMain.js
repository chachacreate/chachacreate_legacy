let bestSwiper = null;
let mainSwiper = null;
let cpath = "";
let storeUrl = "";

$(() => {
  cpath = document.getElementById("cpath").value;
  storeUrl = document.getElementById("storeUrl").value;

  bestProduct();
  mainProduct();
  storeNotices();
});

//스토어 소개 렌더링
function renderStoreInfo(store) {
  const storeInfoArea = document.getElementById("store-banner");
  const storeInfo = store[0]; // 대표 스토어 하나만

  const html = `
    <img src="${cpath}/resources/productImages/${storeInfo.logoImg}" alt="${storeInfo.storeName}">
    <div class="store-intro">
      <h1 class="store-name">${storeInfo.storeName}</h1>
      <p class="store-desc">${storeInfo.storeDetail}</p>
    </div>
  `;
  storeInfoArea.innerHTML = html;
}

//대표 상품 조회 및 Swiper 초기화
function mainProduct() {
  $.ajax({
    url: `${cpath}/api/${storeUrl}`,
    dataType: "json",
    success: function (result) {
      const mainProducts = result.data.mainProduct;
      renderStoreInfo(mainProducts);

      const wrapper = document.getElementById("main-product-swiper-wrapper");
      wrapper.innerHTML = "";

      mainProducts.forEach(bs => {
        const html = `
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
        wrapper.insertAdjacentHTML("beforeend", html);
      });

      // Swiper 초기화
      if (mainSwiper) mainSwiper.destroy(true, true);
      mainSwiper = new Swiper(".main-product-swiper", {
        slidesPerView: 3,
        spaceBetween: 30,
        loop: false,
        navigation: {
          nextEl: ".store-next",
          prevEl: ".store-prev"
        },
        pagination: {
          el: ".store-pagination",
          clickable: true
        },
        allowTouchMove: false
      });
    },
    error: function (err) {
      console.error("대표상품 AJAX 에러:", err);
    }
  });
}

//인기 상품 조회 및 Swiper 초기화
function bestProduct() {
  $.ajax({
    url: `${cpath}/api/${storeUrl}`,
    dataType: "json",
    success: function (result) {
      const bestProducts = result.data.bestProduct;
      renderBestProduct(bestProducts);
    },
    error: function (err) {
      console.error("인기상품 AJAX 에러:", err);
    }
  });
}

function renderBestProduct(bestProduct) {
  const bestProductArea = document.getElementById("best-product-swiper-wrapper");
  bestProductArea.innerHTML = "";

  let html = "";
  bestProduct.forEach(bf => {
    const priceText = bf.price ? Number(bf.price).toLocaleString() + "원" : "가격 정보 없음";
    html += `
      <div class="swiper-slide" onclick="location.href='${cpath}/${storeUrl}/productdetail/${bf.productId}'">
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

  // Swiper 초기화
  if (bestSwiper) bestSwiper.destroy(true, true);
  bestSwiper = new Swiper(".best-product-swiper", {
    slidesPerView: 3,
    spaceBetween: 30,
    loop: false,
    navigation: {
      nextEl: ".product-next",
      prevEl: ".product-prev"
    },
    pagination: {
      el: ".product-pagination",
      clickable: true
    },
    allowTouchMove: false
  });
}

//공지사항 조회
function storeNotices() {
  $.ajax({
    url: `${cpath}/api/${storeUrl}/seller/management/noticeselect`,
    dataType: "json",
    success: result => {
      if (!result || !Array.isArray(result.data)) return;

      const pinned = result.data.filter(n => n.noticeCheck == 1);
      if (pinned.length > 0) {
        const notice = pinned[0];
        $("#important-notice").html(`<tr><td>🎉 ${notice.noticeTitle} : ${notice.noticeText}</td></tr>`);
      } else {
        $("#important-notice").html(`<tr><td colspan="3">중요 공지가 없습니다.</td></tr>`);
      }
    },
    error: () => {
      console.error("공지사항 조회 실패");
    }
  });
}
