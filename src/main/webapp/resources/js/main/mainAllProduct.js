// ===============================
// 전역 변수 선언
// ===============================
let cpath = "";
let openedUCategoryId = null; // 현재 열린 u카테고리 ID (같은 버튼 다시 누르면 접기 위함)
let allProducts = []; // 전체 상품 데이터 저장
const PRODUCTS_PER_PAGE = 16;

// ===============================
// 초기 실행: DOM 로드 시 실행할 초기 설정
// ===============================
$(() => {
  cpath = document.getElementById("cpath").value;

  		allProduct(); // 전체 상품 조회

		//  [1] 전체 상품 텍스트 클릭 시 전체 상품 다시 조회
		$(".store-title").on("click", () => allProduct());
		
		//  [2] 검색 버튼 클릭 시 상품명 기반 조회
		$("#search-button").on("click", function () {
		    const inputData = $("#keyword").val();
		    if (inputData.trim() !== "") {
		      searchProductName(inputData);
		    } else {
		      alert("상품명을 입력하세요.");
		    }
		});
		
		//  [3] 정렬 조건 버튼 클릭 시
		$(".filter-button").on("click", function () {
		    $(".filter-button").removeClass("active");
		    $(this).addClass("active");
		
		    const sortValue = $(this).data("sort");
		    if (!sortValue) return; // 카테고리 버튼이라면 무시
		
		    console.log("조건조회 실행 :", sortValue);
		    sortProducts(sortValue);
		});
		
		//  [4] 카테고리 조회 버튼 클릭 시
		$("#toggle-category").on("click", function () {
		    categorySelect();
		});
		
		//  [5] u카테고리 버튼 클릭 시 d카테고리 조회 또는 토글
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
		
		//  [6] u카테고리 전체 선택 체크 시 연결된 d카테고리 버튼들도 selected 처리
		$(document).on("change", ".u-checkbox", function () {
		  const uCategoryId = $(this).val();
		  const isChecked = $(this).is(":checked");
		  const uCategoryName = $(`.toggle-uCategory[data-category-id="${uCategoryId}"]`).data("category-name");
		
		  $(`.filter-btn[data-uid="${uCategoryId}"]`).toggleClass("selected", isChecked);
		  $(`.toggle-uCategory[data-category-id="${uCategoryId}"]`).toggleClass("selected", isChecked);
		
		  const selectedFiltersContainer = document.querySelector(".selected-filters");
		  const existingTag = selectedFiltersContainer.querySelector(`.selected-tag[data-value="${uCategoryName}"]`);
		
		  if (isChecked && !existingTag) {
		    const tag = document.createElement("div");
		    tag.className = "selected-tag";
		    tag.setAttribute("data-value", uCategoryName);
		    tag.innerHTML = `${uCategoryName} <button class="remove-tag">✕</button>`;
		    selectedFiltersContainer.appendChild(tag);
		    attachRemoveEvent(tag.querySelector(".remove-tag"));
		  } else if (!isChecked && existingTag) {
		    existingTag.remove();
		  }
		});
		
		//  [7] filter-btn 클릭 시 selected 토글 + 선택 태그 추가/삭제
		const selectedFiltersContainer = document.querySelector(".selected-filters");
		 
		// toggle-uCategory 클래스가 있는 버튼은 선택 태그에 추가되지 않도록 제외 
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
		
		 //  [8] 초기화 버튼 클릭 시 선택 초기화
		$(document).on("click", ".reset-btn", function () {
		  document.querySelectorAll(".selected-tag").forEach(tag => tag.remove());
		  $(".filter-btn").removeClass("selected");
		  $(".u-checkbox").prop("checked", false);  // 🔹 체크박스도 초기화
		});
		
		  
		
		  //  [9] 카테고리 열고닫기 버튼
		  const toggleCategoryBtn = document.getElementById("toggle-category");
		  const categorySection = document.getElementById("category-section");
		  if (toggleCategoryBtn && categorySection) {
		    toggleCategoryBtn.addEventListener("click", () => {
		      categorySection.classList.toggle("category-hidden");
		    });
		  }
		  
		// [10] 카테고리 기반 검색 버튼 클릭 시
		$(document).on("click", ".category-search-btn", function () {
		  const filters = collectSelectedCategories(); 				// 선택된 카테고리 수집
		  fetchFilteredProducts(filters);              						// AJAX로 상품 조회 요청
		});
		
});


// ===============================
// 선택된 카테고리 찾는 함수
// ===============================
function collectSelectedCategories() {
  const type = [];
  const u = [];
  const d = [];

  // 선택된 태그를 기준으로 어떤 카테고리인지 분기
  $(".selected-tag").each(function () {
    const value = $(this).data("value");

    // 타입 카테고리
    $(".filter-btn").each(function () {
      if ($(this).text().trim() === value && !$(this).hasClass("toggle-uCategory")) {
        const uid = $(this).attr("value"); // typeCategory button에만 value 속성 존재
        if (uid) type.push(uid);
      }
    });

    // u카테고리는 toggle-uCategory에 해당
    $(".toggle-uCategory").each(function () {
      if ($(this).text().trim() === value) {
        const uid = $(this).data("category-id");
        if (uid) u.push(uid);
      }
    });

    // d카테고리는 data-uid 속성 존재
    $(".d-checkbox").each(function () {
      if ($(this).text().trim() === value) {
        const did = $(this).val();
        if (did) d.push(did);
      }
    });
  });

  return { type, u, d };
}


// ===============================
// 필터 조건으로 상품 조회
// ===============================
function fetchFilteredProducts(filters) {
  const { type, u, d } = filters;
  const link = `${cpath}/api/main/products`;

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
// ✕ 버튼 클릭 시 필터 해제
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
  const link = `${cpath}/api/main/products`;

  $.ajax({
    url: link,
    dataType: "json",
    success: function (result) {
      allProducts = result.data || [];
      console.log("전체 상품:", allProducts);
      renderProductList(allProducts.slice(0, PRODUCTS_PER_PAGE));
      renderPagination(allProducts.length, 1);
    },
    error: function (xhr, status, error) {
      console.error("전체상품 조회 실패:", error);
    }
  });
}

// ===============================
// 상품명 검색
// ===============================
function searchProductName(keyword) {
  const link = `${cpath}/api/main/products`;
  $.ajax({
    url: link,
    data: { keyword },
    dataType: "json",
    success: function (result) {
      console.log("검색 결과:", result.data);
      renderProductList(result.data);
    },
    error: function (xhr, status, error) {
      console.error("검색 실패:", error);
      alert("검색 실패, 다시 입력해주세요.");
    }
  });
}

// ===============================
// 정렬 조건으로 조회
// ===============================
function sortProducts(sort) {
  const link = `${cpath}/api/main/products`;
  $.ajax({
    url: link,
    dataType: "json",
    data: { sort },
    success: function (result) {
      renderProductList(result.data);
    },
    error: function (xhr, status, error) {
      console.error("정렬 조회 실패:", error);
    }
  });
}

// ===============================
// 카테고리 정보 조회
// ===============================
function categorySelect() {
  const link = `${cpath}/api/main/categories`;
  $.ajax({
    url: link,
    dataType: "json",
    success: function (result) {
      renderTypeCategory(result.typeCategory);
      renderUCategory(result.uCategory);
    },
    error: function (xhr, status, error) {
      console.error("카테고리 요청 실패:", error);
    }
  });
}

// ===============================
// u카테고리 클릭 시 d카테고리 요청
// ===============================
function selectDCategory(uCategoryId, uCategoryName, renderDCategories) {
  const link = `${cpath}/api/main/categories`;

  $.ajax({
    url: link,
    data: { uCategoryName },
    dataType: "json",
    success: function (result) {
      renderDCategories(result, uCategoryId, uCategoryName);
    },
    error: function (xhr, status, error) {
      console.error("D카테고리 요청 실패:", error);
    },
  });
}

// ===============================
// Type 카테고리 렌더링
// ===============================
function renderTypeCategory(typeC) {
  const typeArea = document.getElementById("typeCategory");
  typeArea.innerHTML = "";

  let html = "";
  typeC.forEach(t => {
    html += `<button class="filter-btn" value="${t.id}">${t.name}</button>`;
  });

  typeArea.innerHTML = html;
}

// ===============================
// U 카테고리 렌더링
// ===============================
function renderUCategory(uC) {
  const ucArea = document.getElementById("uCategory");
  ucArea.innerHTML = "";

  let html = "";
  uC.forEach(u => {
    html += `
      <button class="filter-btn toggle-uCategory" data-category-id="${u.id}" data-category-name="${u.name}">
        ${u.name}
      </button>
      <label class="select-all">
        <input type="checkbox" class="check-all u-checkbox" value="${u.id}"> 전체 선택
      </label>
    `;
  });

  ucArea.innerHTML = html;
}

// ===============================
// D 카테고리 렌더링
// ===============================
function renderDCategories(dC, uCategoryId, uCategoryName) {
  const dArea = document.getElementById("dCategory-area");
  if (!dArea) return;

  let html = "";
  dC.forEach((d) => {
    html += `
      <button class="filter-btn d-checkbox"
              data-uid="${uCategoryId}"
              data-uname="${uCategoryName}"
              value="${d.id}">
        ${d.name}
      </button>
    `;
  });

  dArea.innerHTML = html;
  dArea.style.display = "block";
}


// ===============================
// 페이지네이션을 위해 외부 JS호출할 함수
// ===============================
function changePage(pageNumber) {
  const startIndex = (pageNumber - 1) * PRODUCTS_PER_PAGE;
  const endIndex = startIndex + PRODUCTS_PER_PAGE;
  const paginated = allProducts.slice(startIndex, endIndex);

  renderProductList(paginated); // 상품 표시 함수
  renderPagination(allProducts.length, pageNumber); // 페이지네이션 재렌더링
}


// ===============================
// 상품 목록 렌더링
// ===============================
function renderProductList(products) {
  const wrapper = document.querySelector(".product-grid-container");
  wrapper.innerHTML = "";

  products.forEach(product => {
    const priceText = product.price ? Number(product.price).toLocaleString() + "원" : "가격 정보 없음";

    const html = `
      <div class="product-card" onclick="location.href='${cpath}/main/productdetail/${product.productId}'">
        <div class="product-image">
          <img class="product-img" src="${cpath}/resources/productImages/${product.pimgUrl}" alt="${product.productName}" />
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

    wrapper.insertAdjacentHTML("beforeend", html);
  });
}
