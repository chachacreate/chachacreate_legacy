<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%> 
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />


<!DOCTYPE html>
<html>
<link rel="stylesheet" href="${cpath}/resources/css/store/storeAllProducts.css">
<jsp:include page="/common/header.jsp" />
<jsp:include page="/common/storeMain_nav.jsp" />
<script src="${cpath}/resources/js/store/storeAllProduct.js"></script>
<script src="${cpath}/resources/js/store/store_pagination.js"></script>

<head>
<meta charset="UTF-8">
<title>스토어 전체 상품 페이지</title>

</head>
<body>
<input type="hidden" id="cpath" value="${cpath}">
<input type="hidden" id="storeUrl" value="${storeUrl}">
<!-- 검색창 -->
<div id="product-search">
  <div id="search-form" >
    <input type="text" placeholder="상품명으로 검색하세요" id="keyword" />
    <button type="button" id="search-button">🔍</button>
  </div>
</div>

<!-- 정렬 탭 -->

<!-- 상단 스토어명 -->
<div id="sort-group">
  <div id="sort-header">
    <h1 id="storename"><span id="store-name-dynamic"></span> 전체 상품</h1>
    <hr class="store-underline">
  </div>
</div>

<h3 class="category-title">상세카테고리</h3>
<!-- typeCategory 들어갈 공간 -->
<div id="type-category-section"></div>
<div id="category-section">
  <!-- 이 안에 JS로 <div class="main-category-block"> 들이 들어갈 예정 -->
</div> 

  <!-- 검색 버튼 -->
  <div class="category-search-btn-wrapper">
    <button type="button" class="category-search-btn">검색하기</button>
  </div>

<hr class="divider">

<div id="sort-tabs">
  <div class="sort-tab active" data-sort="latest">전체상품</div>
  <div class="sort-tab" data-sort="popular">구매많은 순</div>
  <div class="sort-tab" data-sort="lowprice">낮은 가격 순</div>
  <div class="sort-tab" data-sort="highprice">높은 가격 순</div>
</div>


<div id="product-list" class="product-grid">
  <!-- 결과 상품들이 동적으로 들어가는 공간 -->
</div>

<!-- 페이지네이션 영역 -->
	<div id="pagination" class="pagination">
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