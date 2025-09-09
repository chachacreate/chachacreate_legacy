// ===============================
// 전역 변수 선언
// ===============================
let cpath = "";
let storeUrl = "";
let openedUCategoryId = null;
let allProducts = [];
const PRODUCTS_PER_PAGE = 16;

// ===============================
// 초기 실행: DOM 로드 시 실행할 초기 설정
// ===============================
$(() => {
  cpath = document.getElementById("cpath").value;
  storeUrl = document.getElementById("storeUrl").value;

  allProduct(); // 전체 상품 조회

  // [1] 전체 상품 텍스트 클릭 시 전체 상품 다시 조회
  $(".store-title").on("click", () => allProduct());

  // [2] 검색 버튼 클릭 시 상품명 기반 조회
  $("#search-button").on("click", function () {
    const inputData = $("#keyword").val();
    if (inputData.trim() !== "") {
      searchProductName(inputData);
    } else {
      alert("상품명을 입력하세요.");
    }
  });

  // [3] 정렬 조건 버튼 클릭 시
  $(".filter-button").on("click", function () {
    $(".filter-button").removeClass("active");
    $(this).addClass("active");

    const sortValue = $(this).data("sort");
    if (!sortValue) return;

    console.log("조건조회 실행 :", sortValue);
    sortProducts(sortValue);
  });

  // [4] 카테고리 조회 버튼 클릭 시
  $("#toggle-category").on("click", function () {
    categorySelect();
  });

  // [5] u카테고리 버튼 클릭 시 d카테고리 조회 또는 토글
  $(document).on("click", ".toggle-uCategory", function () {
    const uCategoryId = $(this).data("category-id");
    const uCategoryName = $(this).data("category-name");
    const $target = $("#dCategory-area");

    if (openedUCategoryId === uCategoryId) {
      $target.slideUp();
      openedUCategoryId = null;
      return;
    }

    selectDCategory(uCategoryId, uCategoryName, renderDCategories);
    $target.slideDown();
    openedUCategoryId = uCategoryId;
  });

  // [6] u카테고리 전체 선택 체크 시 연결된 버튼 selected 처리
  $(document).on("change", ".u-checkbox", function () {
    const uCategoryId = $(this).val();
    const isChecked = $(this).is(":checked");
    const uCategoryName = $(`.toggle-uCategory[data-category-id="${uCategoryId}"]`).data("category-name");

    $(`.filter-btn[data-uid="${uCategoryId}"]`).toggleClass("selected", isChecked);
    $(`.toggle-uCategory[data-category-id="${uCategoryId}"]`).toggleClass("selected", isChecked);

    const container = document.querySelector(".selected-filters");
    const existingTag = container.querySelector(`.selected-tag[data-value="${uCategoryName}"]`);

    if (isChecked && !existingTag) {
      const tag = document.createElement("div");
      tag.className = "selected-tag";
      tag.setAttribute("data-value", uCategoryName);
      tag.innerHTML = `${uCategoryName} <button class="remove-tag">✕</button>`;
      container.appendChild(tag);
      attachRemoveEvent(tag.querySelector(".remove-tag"));
    } else if (!isChecked && existingTag) {
      existingTag.remove();
    }
  });

  // [7] filter-btn 클릭 시 태그 추가/삭제
  const selectedFiltersContainer = document.querySelector(".selected-filters");

  $(document).on("click", ".filter-btn:not(.toggle-uCategory)", function () {
    const btn = this;
    const value = btn.textContent.trim();
    const isSelected = btn.classList.contains("selected");

    btn.classList.toggle("selected");

    if (!isSelected) {
      const tag = document.createElement("div");
      tag.className = "selected-tag";
      tag.setAttribute("data-value", value);
      tag.innerHTML = `${value} <button class="remove-tag">\u2715</button>`;
      selectedFiltersContainer.appendChild(tag);
      attachRemoveEvent(tag.querySelector(".remove-tag"));
    } else {
      const tagToRemove = selectedFiltersContainer.querySelector(`.selected-tag[data-value="${value}"]`);
      if (tagToRemove) tagToRemove.remove();
    }
  });

  // [8] 초기화 버튼 클릭 시 전체 해제
  $(document).on("click", ".reset-btn", function () {
    document.querySelectorAll(".selected-tag").forEach(tag => tag.remove());
    $(".filter-btn").removeClass("selected");
    $(".u-checkbox").prop("checked", false);
  });

  // [9] 카테고리 토글 열기/닫기
  const toggleCategoryBtn = document.getElementById("toggle-category");
  const categorySection = document.getElementById("category-section");
  if (toggleCategoryBtn && categorySection) {
    toggleCategoryBtn.addEventListener("click", () => {
      categorySection.classList.toggle("category-hidden");
    });
  }

  // [10] 선택한 카테고리 기반 상품 검색
  $(document).on("click", ".category-search-btn", function () {
    const filters = collectSelectedCategories();
    fetchFilteredProducts(filters);
  });
});

// ===============================
// 선택된 카테고리 필터 수집
// ===============================
function collectSelectedCategories() {
  const type = [];
  const u = [];
  const d = [];

  $(".selected-tag").each(function () {
    const value = $(this).data("value");

    $(".filter-btn").each(function () {
      if ($(this).text().trim() === value && !$(this).hasClass("toggle-uCategory")) {
        const id = $(this).attr("value");
        if (id) type.push(id);
      }
    });

    $(".toggle-uCategory").each(function () {
      if ($(this).text().trim() === value) {
        const id = $(this).data("category-id");
        if (id) u.push(id);
      }
    });

    $(".d-checkbox").each(function () {
      if ($(this).text().trim() === value) {
        const id = $(this).val();
        if (id) d.push(id);
      }
    });
  });

  return { type, u, d };
}

// ===============================
// ✕ 태그 제거 이벤트
// ===============================
function attachRemoveEvent(button) {
  button.addEventListener("click", (e) => {
    const tag = e.target.closest(".selected-tag");
    const value = tag.getAttribute("data-value");
    tag.remove();

    document.querySelectorAll(".filter-btn").forEach(btn => {
      if (btn.textContent.trim() === value) {
        btn.classList.remove("selected");
      }
    });
  });
}

// ===============================
// 전체 상품 조회
// ===============================
function allProduct() {
  $.ajax({
    url: `${cpath}/legacy/${storeUrl}/products`,
    dataType: "json",
    success: result => {
      allProducts = result.data || [];
      renderProductList(allProducts.slice(0, PRODUCTS_PER_PAGE));
      renderPagination(allProducts.length, 1);
    },
    error: (xhr, status, error) => console.error("전체상품 조회 실패:", error)
  });
}

// ===============================
// 상품명 검색
// ===============================
function searchProductName(keyword) {
  $.ajax({
    url: `${cpath}/legacy/${storeUrl}/products`,
    data: { keyword },
    dataType: "json",
    success: result => renderProductList(result.data),
    error: (xhr, status, error) => {
      console.error("검색 실패:", error);
      alert("검색 실패, 다시 입력해주세요.");
    }
  });
}

// ===============================
// 정렬 조건 조회
// ===============================
function sortProducts(sort) {
  $.ajax({
    url: `${cpath}/legacy/${storeUrl}/products`,
    dataType: "json",
    data: { sort },
    success: result => renderProductList(result.data),
    error: (xhr, status, error) => console.error("정렬 실패:", error)
  });
}

// ===============================
// 카테고리 정보 조회
// ===============================
function categorySelect() {
  $.ajax({
    url: `${cpath}/legacy/${storeUrl}/categories`,
    dataType: "json",
    success: result => {
      renderTypeCategory(result.typeCategory);
      renderUCategory(result.uCategory);
    },
    error: (xhr, status, error) => console.error("카테고리 조회 실패:", error)
  });
}

// ===============================
// U카테고리 클릭 시 D카테고리 조회
// ===============================
function selectDCategory(uCategoryId, uCategoryName, renderDCategories) {
  $.ajax({
    url: `${cpath}/legacy/${storeUrl}/categories`,
    data: { uCategoryName },
    dataType: "json",
    success: result => renderDCategories(result, uCategoryId, uCategoryName),
    error: (xhr, status, error) => console.error("D카테고리 요청 실패:", error)
  });
}

// ===============================
// Type 카테고리 렌더링
// ===============================
function renderTypeCategory(typeC) {
  const area = document.getElementById("typeCategory");
  area.innerHTML = "";

  typeC.forEach(t => {
    area.innerHTML += `<button class="filter-btn" value="${t.id}">${t.name}</button>`;
  });
}

// ===============================
// U 카테고리 렌더링
// ===============================
function renderUCategory(uC) {
  const area = document.getElementById("uCategory");
  area.innerHTML = "";

  uC.forEach(u => {
    area.innerHTML += `
      <button class="filter-btn toggle-uCategory" data-category-id="${u.id}" data-category-name="${u.name}">${u.name}</button>
      <label class="select-all">
        <input type="checkbox" class="check-all u-checkbox" value="${u.id}"> 전체 선택
      </label>
    `;
  });
}

// ===============================
// D 카테고리 렌더링
// ===============================
function renderDCategories(dC, uCategoryId, uCategoryName) {
  const area = document.getElementById("dCategory-area");
  if (!area) return;

  let html = "";
  dC.forEach(d => {
    html += `<button class="filter-btn d-checkbox" data-uid="${uCategoryId}" data-uname="${uCategoryName}" value="${d.id}">${d.name}</button>`;
  });

  area.innerHTML = html;
  area.style.display = "block";
}

// ===============================
// 상품 목록 렌더링
// ===============================
function renderProductList(products) {
  const wrapper = document.querySelector(".product-grid-container");
  wrapper.innerHTML = "";

  products.forEach(product => {
    const priceText = product.price ? Number(product.price).toLocaleString() + "원" : "가격 정보 없음";

    wrapper.innerHTML += `
      <div class="product-card" onclick="location.href='${cpath}/${storeUrl}/products/${product.productId}'">
        <div class="product-image">
          <img class="product-img" src="${product.pimgUrl}" alt="${product.productName}" />
        </div>
        <div class="product-content">
          <h2 class="product-name">${product.productName}</h2>
          <div class="product-category-list">
          <span class="product-category">${product.categoryName || ''}</span>
          <span class="product-category">${product.ucategoryName || ''}</span>
          <span class="product-category">${product.dcategoryName || ''}</span>
          </div>
          <div class="product-price">${priceText}</div>
        </div>
      </div>
    `;
  });
}

// ===============================
// 필터 조건으로 상품 조회
// ===============================
function fetchFilteredProducts(filters) {
console.log("필터조건으로 상품조회 실행");
  const { type, u, d } = filters;
  const link = `${cpath}/legacy/${storeUrl}/products`;
    
  $.ajax({
    url: link,
    type: "GET",
    data: {
      type: type,
      u: u,
      d: d,
    },
    traditional: true, // 배열 파라미터 전송을 위해 필요함
    dataType: "json",
    success: function (result) {
      const productList = result.data;
      renderProductList(productList);
    },
    error: function (xhr, status, error) {
      console.error("조건 검색 실패:", error);
      alert("상품 검색에 실패했습니다.");
    }
  });
}

// ===============================
// 페이지네이션
// ===============================
function changePage(pageNumber) {
  const start = (pageNumber - 1) * PRODUCTS_PER_PAGE;
  const paginated = allProducts.slice(start, start + PRODUCTS_PER_PAGE);
  renderProductList(paginated);
  renderPagination(allProducts.length, pageNumber);
}
