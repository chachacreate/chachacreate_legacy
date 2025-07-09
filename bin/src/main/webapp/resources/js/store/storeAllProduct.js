let cpath = "";
let storeUrl = "";
let allProducts = [];  // 전체 상품 저장
const PRODUCTS_PER_PAGE = 16;

$(() => {
  cpath = document.getElementById("cpath").value;
  storeUrl = document.getElementById("storeUrl").value;

	  // 페이지 로드되면 전체상품 조회
	  allProduct();
  
	  // 카테고리 영역 
	  loadCategories();
	  
	  // UCategory 버튼 클릭시 존재하는 DCategory 조회
	  $(document).on("click", ".toggle-arrow", function () {
	  const uCategoryName = $(this).data("category-id");
	  const dAreaId = `dCategory-area-${uCategoryName}`;
	  const $target = $(`#${dAreaId}`);
	
	  if ($target.is(":visible")) {
	    $target.slideUp();
	  } else {
	    if ($target.children().length === 0) {
	      selectDCategory(uCategoryName, renderDCategories);
	    } else {
	      $target.slideDown();
	    }
	  }
	});
	
	
		 // 검색하기 버튼 클릭시 선택한 카테고리가 .존재하는 상품 조회
	 	 $(document).on("click",".category-search-btn",function () {
		  const filters = collectCategoryFilters();
		  fetchFilteredProducts(filters);
		});
  

	 // 조건 조회시
	 $(".sort-tab").on("click",function(){
	 	$(".sort-tab").removeClass("active");
	 	$(this).addClass("active");
	 	
	 	const sortValue = $(this).data("sort");
	 	sortProducts(sortValue);
	 });
 
	  // 상품명으로 검색시
	  $("#search-button").on("click", function () {
	    const inputData = $("#keyword").val();
	    if (inputData.trim() !== "") {
	      searchProductName(inputData);
	    } else {
	      alert("상품명을 입력하세요.");
	    }
	  });
  
	  // 전체선택 체크시 하위 체크박스 전체 선택
	  $(document).on("change", ".check-all", function () {
	  // 해당 전체선택 체크박스가 속한 main-category-block 찾기
	  const $mainBlock = $(this).closest(".main-category-block");
	  // 해당 블록 안의 모든 서브카테고리 체크박스를 선택 또는 해제
	  const isChecked = $(this).is(":checked");
	  $mainBlock.find(".subcategory-container input[type='checkbox']").prop("checked", isChecked);
	});
	
});


// 체크박스의 체크된 카테고리의 ID값을 수집하는 함수
function collectCategoryFilters() {
  const typeIds = $('.type-checkbox:checked').map(function () {
    return $(this).val();
  }).get();

  const uIds = $('.u-checkbox:checked').map(function () {
    return $(this).val();
  }).get();

  const dIds = $('.d-checkbox:checked').map(function () {
    return $(this).val();
  }).get();

  const keyword = $('#search-input').val();  // 검색어
  const sort = $('.sort-tab.active').data('sort') || 'latest';  // 선택된 정렬 기준

  return { type: typeIds, u: uIds, d: dIds, keyword, sort };
}




// 조건조회
function sortProducts(sort){
  const link = `${cpath}/api/${storeUrl}/products`;
  
  $.ajax({
  	url: link,
  	dataType: "Json",
  	data: {sort : sort},
  	success: function(result){
  	renderProductList(result.data);
  	},
  	error: function (xhr, status, error) {
      console.error("조건조회 요청 실패:", error);
    }
  });
};

// 카테고리 조회
function loadCategories() {
  const link = `${cpath}/api/${storeUrl}/categories`;

  $.ajax({
    url: link,
    dataType: "json",
    success: function (result) {
      const typeC = result.typeCategory;
      const uC = result.uCategory;
	  renderTypeCategories(typeC);
	  renderUCategories(uC);	
    },
    error: function (xhr, status, error) {
      console.error("카테고리 요청 실패:", error);
    }
  });
};

// U카테고리에 해당하는 D카테고리 조회 함수
function selectDCategory(uCategoryName, renderDCategories){
	const link = `${cpath}/api/${storeUrl}/categories`;
	
	$.ajax({
		url: link,
		data: { uCategoryName },
		dataType: "json",
		success: function(result){
		console.log("D카테고리 : " , result);
			renderDCategories(result, uCategoryName);
		},
		error: function (xhr, status, error) {
      	console.error("D카테고리 요청 실패:", error);
    }
	});
};

// Type카테고리 조회
function renderTypeCategories(typeC){
	const typeArea = document.getElementById("type-category-section");
  typeArea.innerHTML = "";

  let html = "";

  typeC.forEach(t => {
    html += `
      <div class="type-category-block">
        <div class="main-category-header">
          <span class="category-name">${t.name}</span>
          <label class="select">
            <input type="checkbox"  class="type-checkbox" value="${t.id}"> 선택
          </label>
        </div>
      </div>
    `;
  });

  typeArea.innerHTML = html;
};

// U카테고리 조회
function renderUCategories(uC) {
  const uArea = document.getElementById("category-section");
  uArea.innerHTML = "";

  let html = "";

  uC.forEach(u => {
    html += `
      <div id="uCategory-area" class="main-category-block" data-category-id="${u.name}">
        <div class="main-category-header">
          <span class="category-name">${u.name}</span>
          <div class="toggle-arrow" data-category-id="${u.name}">🔽  </div>
          <label class="select-all">
            <input type="checkbox" class="check-all u-checkbox" value="${u.id}"> 전체 선택
          </label>
        </div>
        <!-- 여기에만 subcategory-container 존재 -->
        <div class="subcategory-container" id="dCategory-area-${u.name}" style="display: none;"></div>
      </div>
    `;
  });

  uArea.innerHTML = html;
}


// D카테고리 조회
function renderDCategories(dC, uCategoryName) {
  const dArea = document.getElementById(`dCategory-area-${uCategoryName}`);
  if (!dArea) return;

  let html = "";

  dC.forEach((d) => {
    html += `
      <label>
        <input type="checkbox" class="d-checkbox" value="${d.id}"> ${d.name}
      </label>
    `;
  });

  dArea.innerHTML = html;
  dArea.style.display = "block";
}


// 체크박스의 체크된 카테고리 요청 함수
function fetchFilteredProducts(filters) {
  const url = `${cpath}/api/${storeUrl}/products`;
  
  Object.keys(filters).forEach(key => {
  	if(Array.isArray(filters[key]) && filters[key].length === 0){
  		filters[key] = '';				// 빈 배열이면 빈 문자열로
  	}
  });
	
  $.ajax({
    url: url,
    method: 'GET',
    data: filters,
    traditional: true,  						// 배열 쿼리 파라미터를 name=value1&name=value2로 보냄
    success: function (result) {
      renderProductList(result.data);
    },
    error: function (xhr, status, error) {
      console.error('상품 조회 실패:', error);
    }
  });
}


// 전체상품 조회
function allProduct() {
  const link = `${cpath}/api/${storeUrl}/products`;

  $.ajax({
    url: link,
    dataType: "json",
    success: function (result) {
    
      allProducts = result.data || [];
      renderProductList(allProducts.slice(0, PRODUCTS_PER_PAGE));
      renderPagination(allProducts.length, 1);
      
    },
    error: function (xhr, status, error) {
      console.error("전체상품 조회 실패:", error);
    }
  });
}

// 페이지네이션을 위해 외부JS호출할 함수
function changePage(pageNumber) {
  const startIndex = (pageNumber - 1) * PRODUCTS_PER_PAGE;
  const endIndex = startIndex + PRODUCTS_PER_PAGE;
  const paginated = allProducts.slice(startIndex, endIndex);

  renderProductList(paginated); // 상품 표시 함수
  renderPagination(allProducts.length, pageNumber); // 페이지네이션 재렌더링
}


// 상품명 검색 조회
function searchProductName(keyword) {
  const link = `${cpath}/api/${storeUrl}/products`;

  $.ajax({
    url: link,
    data: { keyword: keyword },
    dataType: "json",
    success: function (result) {
      console.log("검색 결과:", result.data);
      renderProductList(result.data);
    },
    error: function (xhr, status, error) {
      console.error("검색 요청 실패:", error);
      alert("검색 실패, 다시 입력해주세요.");
    }
  });
}


// 공통 사용 함수
function renderProductList(products) {
  const wrapper = document.getElementById("product-list");
  wrapper.innerHTML = "";

  products.forEach(product => {
    const priceText = product.price
      ? Number(product.price).toLocaleString() + "원"
      : "가격 정보 없음";

    const html = `
      <div class="product-card" onclick="location.href='${cpath}/${storeUrl}/productdetail/${product.productId}'">
        <img class="product-img" src="${cpath}/resources/productImages/${product.pimgUrl}" alt="${product.productName}" />
        <div class="product-name">${product.productName}</div>
        <div class="product-category-list">
          <span class="product-category">${product.categoryName || ''}</span>
          <span class="product-category">${product.ucategoryName || ''}</span>
          <span class="product-category">${product.dcategoryName || ''}</span>
        </div>
        <div class="product-price">${priceText}</div>
      </div>
    `;
    wrapper.insertAdjacentHTML("beforeend", html);
  });
}
