<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>스토어 전체 상품 페이지</title>
  <%@ include file="/common/header.jsp" %>
  <link rel="stylesheet" href="${cpath}/resources/css/main/mainAllProducts.css">
<jsp:include page="/common/storeMain_nav.jsp" />
<script src="${cpath}/resources/js/store/store_pagination.js"></script>
<script src="${cpath}/resources/js/store/storeAllProduct.js"></script>
</head>
<body>
<input type="hidden" id="cpath" value="${cpath}">
<input type="hidden" id="storeUrl" value="${storeUrl}">

<!-- ✅ 전체 페이지 컨테이너 -->
<div class="store-page-container">


  <!-- ✅ 검색창 -->
<div id="product-search">
  <div id="search-form" >
    <input type="text" placeholder="상품명으로 검색하세요" id="keyword" />
    <button type="button" id="search-button">🔍</button>
  </div>
</div>


  <h1 class="store-title" >전체 상품</h1>



<!-- 정렬 필터 버튼 -->
  <div class="filter-buttons">
    <button class="filter-button active" data-sort="latest">최신순</button>
    <button class="filter-button" data-sort="popular">인기순</button>
    <button class="filter-button" data-sort="lowprice">낮은 가격순</button>
    <button class="filter-button" data-sort="highprice">높은 가격순</button>
    <button class="filter-button" id="toggle-category">카테고리별 ▼</button>
  </div>

  <!-- 카테고리 필터 영역 -->
  <div id="category-section" class="category-hidden">
    <div class="filter-group">
      <div class="filter-group-title">공예 종류</div>
      <div class="filter-options" id="typeCategory">
      
      </div>
    </div>

    <div class="filter-group">
      <div class="filter-group-title">카테고리</div>
      <div class="filter-options" id="uCategory">
        <!-- uCategory들어가는 공간 -->
      </div>
     <div class="subcategory-container" id="dCategory-area" style="display: none;">
     	<!-- dCagegory들어가는 공간 -->
     </div> 
    </div>

    <div class="selected-filters">
      <button class="reset-btn">↻</button>
    </div>
    <div class="category-search-btn-wrapper">
      	<button type="button" class="category-search-btn">검색하기</button>
      </div>
  </div>



  <!-- 상품 목록 -->
  <div class="product-grid-container">
  	<!-- 상품list 들어가는 공간 -->
  </div>

  <!-- 페이지네이션 -->
  <div id="pagination" class="pagination">
	<!-- 페이지네이션 들어가는 공간 -->
  </div>
</div>
<!-- FOOTER -->
  <footer>
    &copy; 2025 HandCraft Mall. All Rights Reserved.
  </footer>

  <!-- JS -->
  <script src="https://unpkg.com/swiper@9/swiper-bundle.min.js"></script>
  <script src="${pageContext.request.contextPath}/resources/js/main_store.js"></script>

</body>
</html>