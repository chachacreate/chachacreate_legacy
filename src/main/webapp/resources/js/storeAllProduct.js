document.addEventListener("DOMContentLoaded", function () {
  // 1. 스토어 이름 동적 삽입
  fetch(`/api/store/${storeUrl}/name`)
    .then(res => res.json())
    .then(data => {
      document.getElementById("store-name-dynamic").textContent = data.storeName;
    });

  // 2. 카테고리 목록 동적 삽입
  fetch(`/api/store/${storeUrl}/categories`)
    .then(res => res.json())
    .then(categories => {
      const section = document.getElementById("category-section");
      section.innerHTML = "";
      categories.forEach(cat => {
        const block = document.createElement("div");
        block.className = "main-category-block";
        block.innerHTML = `
          <div class="main-category-header">
            <span class="category-name">${cat.name}</span>
            <span class="toggle-arrow">🔽</span>
            <label class="select-all"><input type="checkbox" class="check-all"> 전체 선택</label>
          </div>
          <div class="subcategory-container">
            ${cat.subcategories.map(sc => `
              <label><input type="checkbox" name="subcategory" value="${sc.id}"> ${sc.name}</label>
            `).join("")}
          </div>
        `;
        section.appendChild(block);
      });
    });

  // 3. 상품 목록 불러오기
  function fetchAndRenderProducts(page = 1, sort = 'latest', keyword = '') {
    const url = new URL(`/api/store/${storeUrl}/products`, window.location.origin);
    url.searchParams.append("page", page);
    url.searchParams.append("sort", sort);
    if (keyword) url.searchParams.append("query", keyword);

    fetch(url)
      .then(res => res.json())
      .then(data => {
        renderProductList(data.products);
        renderPagination(data.totalPages, page);
      });
  }

  function renderProductList(products) {
    const list = document.getElementById("product-list");
    list.innerHTML = "";
    products.forEach(p => {
      const div = document.createElement("div");
      div.className = "product-card";
      div.innerHTML = `
        <img class="product-img" src="${p.imageUrl}" alt="${p.name}">
        <div class="product-name">${p.name}</div>
        <div class="product-category-list">
          ${p.categories.map(c => `<span class="product-category">${c}</span>`).join("")}
        </div>
        <div class="product-price">${p.price.toLocaleString()} 원</div>
      `;
      list.appendChild(div);
    });
  }

  function renderPagination(totalPages, currentPage) {
    const pagination = document.getElementById("pagination");
    pagination.innerHTML = "";
    for (let i = 1; i <= totalPages; i++) {
      const btn = document.createElement("button");
      btn.textContent = i;
      if (i === currentPage) btn.classList.add("active");
      btn.addEventListener("click", () => fetchAndRenderProducts(i));
      pagination.appendChild(btn);
    }
  }

  // 4. 정렬 탭 클릭 처리
  document.querySelectorAll(".sort-tab").forEach(tab => {
    tab.addEventListener("click", () => {
      document.querySelectorAll(".sort-tab").forEach(t => t.classList.remove("active"));
      tab.classList.add("active");
      fetchAndRenderProducts(1, tab.dataset.sort);
    });
  });

  // 5. 검색폼 이벤트
  document.getElementById("search-form").addEventListener("submit", e => {
    e.preventDefault();
    const keyword = document.getElementById("search-input").value.trim();
    fetchAndRenderProducts(1, 'latest', keyword);
  });

  // 초기 데이터 호출
  fetchAndRenderProducts();
});


// 6. 페이지네이션 렌더링
const ITEMS_PER_PAGE = 9;
const PAGE_LIMIT = 5;

let storeData = [];
let currentPage = 1;
let currentCategory = null;

function renderPagination() {
  const pagination = document.getElementById('pagination');
  pagination.innerHTML = '';

  const filtered = currentCategory
    ? storeData.filter(store => store.categories.includes(currentCategory))
    : storeData;

  const totalPages = Math.ceil(filtered.length / ITEMS_PER_PAGE);
  if (totalPages === 0) return;

  // 1) 항상 < 버튼 (첫 페이지로 이동)
  const firstBtn = document.createElement('button');
  firstBtn.innerHTML = '&lt;';
  firstBtn.className = 'page-nav';
  firstBtn.onclick = function () {
    currentPage = 1;
    renderStores(currentPage);
    renderPagination();
  };
  pagination.appendChild(firstBtn);

  // 2) 표시할 페이지 범위 계산
  const totalPageGroups = Math.ceil(totalPages / PAGE_LIMIT);
  const currentPageGroup = Math.floor((currentPage - 1) / PAGE_LIMIT);
  const startPage = currentPageGroup * PAGE_LIMIT + 1;
  const endPage = Math.min(startPage + PAGE_LIMIT - 1, totalPages);

  // 3) 숫자 버튼 렌더링
  for (let i = startPage; i <= endPage; i++) {
    const btn = document.createElement('button');
    btn.textContent = i;
    btn.className = (i === currentPage) ? 'active' : '';
    btn.onclick = function () {
      currentPage = i;
      renderStores(i);
      renderPagination();
    };
    pagination.appendChild(btn);
  }

  // 4) 항상 > 버튼 (마지막 페이지로 이동 or 다음 그룹으로)
  const lastBtn = document.createElement('button');
  lastBtn.innerHTML = '&gt;';
  lastBtn.className = 'page-nav';
  lastBtn.onclick = function () {
    const nextGroupStart = startPage + PAGE_LIMIT;
    if (nextGroupStart <= totalPages) {
      currentPage = nextGroupStart;
    } else {
      currentPage = totalPages;
    }
    renderStores(currentPage);
    renderPagination();
  };
  pagination.appendChild(lastBtn);
}
