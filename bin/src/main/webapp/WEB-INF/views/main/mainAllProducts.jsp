<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>전체 상품 목록</title>
  <%@ include file="/common/header.jsp" %>
  <link rel="stylesheet" href="${cpath}/resources/css/main/mainAllProducts.css">
</head>
<body>
  <jsp:include page="/common/main_nav.jsp" />
<!-- ✅ 전체 페이지 컨테이너 -->
<div class="store-page-container">

  <!-- ✅ 검색창 -->
  <div id="product-search">
    <form id="search-form" action="/api/main/productlist" method="get">
      <input type="text" name="query" placeholder="Search" id="search-input" />
      <button type="submit" id="search-button">🔍</button>
    </form>
  </div>

  <!-- 전체 상품 제목 -->
  <h1 class="store-title">전체 상품</h1>

  <!-- 정렬 필터 버튼 -->
  <div class="filter-buttons">
    <button class="filter-button active">최신순</button>
    <button class="filter-button">인기순</button>
    <button class="filter-button">낮은 가격순</button>
    <button class="filter-button">높은 가격순</button>
    <button class="filter-button" id="toggle-category">카테고리별 ▼</button>
  </div>

  <!-- 카테고리 필터 영역 -->
  <div id="category-section" class="category-hidden">
    <div class="filter-group">
      <div class="filter-group-title">카테고리</div>
      <div class="filter-options">
        <button class="filter-btn">문구</button>
        <button class="filter-btn selected">리빙</button>
        <button class="filter-btn">패션</button>
      </div>
    </div>

    <div class="filter-group">
      <div class="filter-group-title">브랜드</div>
      <div class="filter-options">
        <button class="filter-btn selected">나이키</button>
        <button class="filter-btn">커버낫</button>
        <button class="filter-btn">아디다스</button>
      </div>
    </div>

    <div class="filter-group">
      <div class="filter-group-title">가격</div>
      <div class="filter-options">
        <button class="filter-btn">5천원 이하</button>
        <button class="filter-btn selected">5천원~1만원</button>
        <button class="filter-btn">1만원 이상</button>
      </div>
    </div>

    <div class="selected-filters">
      <button class="reset-btn">↻</button>
      <div class="selected-tag">리빙 <button class="remove-tag">✕</button></div>
      <div class="selected-tag">나이키 <button class="remove-tag">✕</button></div>
      <div class="selected-tag">5천원~1만원 <button class="remove-tag">✕</button></div>
    </div>
  </div>

  <!-- 상품 목록 -->
  <div class="product-grid-container">
    <div class="product-card">
      <div class="product-image"><img class="product-img" src="${cpath}/resources/images/chat_bg1.jpg" /></div>
      <div class="product-content">
        <h2 class="product-name">상품명</h2>
        <div class="product-price">10,000 원</div>
      </div>
    </div>
    
    <div class="product-card">
      <div class="product-image"><img class="product-img" src="${cpath}/resources/images/chat_bg1.jpg" /></div>
      <div class="product-content">
        <h2 class="product-name">상품명</h2>
        <div class="product-price">10,000 원</div>
      </div>
    </div>
    
    <div class="product-card">
      <div class="product-image"><img class="product-img" src="${cpath}/resources/images/chat_bg1.jpg" /></div>
      <div class="product-content">
        <h2 class="product-name">상품명</h2>
        <div class="product-price">10,000 원</div>
      </div>
    </div>
    
    <div class="product-card">
      <div class="product-image"><img class="product-img" src="${cpath}/resources/images/chat_bg1.jpg" /></div>
      <div class="product-content">
        <h2 class="product-name">상품명</h2>
        <div class="product-price">10,000 원</div>
      </div>
    </div>
    
    <div class="product-card">
      <div class="product-image"><img class="product-img" src="${cpath}/resources/images/chat_bg1.jpg" /></div>
      <div class="product-content">
        <h2 class="product-name">상품명</h2>
        <div class="product-price">10,000 원</div>
      </div>
    </div>
    <!-- 추가 상품 반복 -->
  </div>

  <!-- 페이지네이션 -->
  <div id="pagination" class="pagination">
    <button class="active">1</button>
    <button>2</button>
    <button>3</button>
    <button>4</button>
    <button>5</button>
  </div>

</div>

<script>
document.addEventListener('DOMContentLoaded', function () {
  const filterButtons = document.querySelectorAll('.filter-btn');
  const selectedFiltersContainer = document.querySelector('.selected-filters');

  filterButtons.forEach(btn => {
    btn.addEventListener('click', () => {
      const value = btn.textContent.trim();
      const alreadySelected = btn.classList.contains('selected');

      btn.classList.toggle('selected');

      if (!alreadySelected) {
        const tag = document.createElement('div');
        tag.className = 'selected-tag';
        tag.setAttribute('data-value', value);
        tag.innerHTML = `${value} <button class="remove-tag">✕</button>`;
        selectedFiltersContainer.appendChild(tag);
        attachRemoveEvent(tag.querySelector('.remove-tag'));
      } else {
        const tagToRemove = selectedFiltersContainer.querySelector(`.selected-tag[data-value="${value}"]`);
        if (tagToRemove) tagToRemove.remove();
      }
    });
  });

  function attachRemoveEvent(button) {
    button.addEventListener('click', (e) => {
      const tag = e.target.closest('.selected-tag');
      const value = tag.getAttribute('data-value');
      tag.remove();

      filterButtons.forEach(btn => {
        if (btn.textContent.trim() === value) {
          btn.classList.remove('selected');
        }
      });
    });
  }

  const resetBtn = document.querySelector('.reset-btn');
  if (resetBtn) {
    resetBtn.addEventListener('click', () => {
      selectedFiltersContainer.querySelectorAll('.selected-tag').forEach(tag => tag.remove());
      filterButtons.forEach(btn => btn.classList.remove('selected'));
    });
  }

  const toggleCategoryBtn = document.getElementById('toggle-category');
  const categorySection = document.getElementById('category-section');

  toggleCategoryBtn.addEventListener('click', () => {
    categorySection.classList.toggle('category-hidden');
  });
});
</script>
</body>
</html>