<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%> 
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>스토어 메인페이지</title>
  
    <!-- ✅ Include Header & Nav -->
<jsp:include page="/common/header.jsp" />
<jsp:include page="/common/storeMain_nav.jsp" />

<script src="${cpath}/resources/js/store/storeMain.js"></script>
  
  <!-- Swiper CSS -->
  <link rel="stylesheet" href="https://unpkg.com/swiper@9/swiper-bundle.min.css" />
  <!-- Custom CSS -->
  <link rel="stylesheet" type="text/css" href="${cpath}/resources/css/store/seller/storeMain.css">
</head>
<body>
<input type="hidden" id="cpath" value="${cpath}">
<input type="hidden" id="storeUrl" value="${storeUrl}">
  
  
  <!-- MAIN CONTENT -->
  <main class="container-store">
  
  <!-- 📢 상단 스토어 소개 영역 -->
  <section class="store-banner" id="store-banner">
		<!-- 스토어 소개 정보 들어갈 공간 -->
  </section>

  <!-- 🔔 스토어 공지사항 -->
  <section class="store-notice">
    <span class="notice-title">공지사항</span>
    <marquee id="important-notice"></marquee>
  </section>

  <!-- 🔥 인기 상품 -->
		<section class="product-section">
			<div class="section-title">
			<div class="section-title-left">
				<span class="icon">⭐</span>
				<h2>인기 상품</h2>
			</div>
			<a href="${cpath}/${storeUrl}/products" class="view-all">전체보기</a>
			</div>
			<div class="swiper best-product-swiper">
				<div class="swiper-wrapper" id="best-product-swiper-wrapper">
					<!-- 인기 상품 정보가 들어갈 공간 -->
				</div>

				<div class="swiper-pagination product-pagination"></div>
				<div class="swiper-button-prev product-prev"></div>
				<div class="swiper-button-next product-next"></div>
			</div>
		</section>

		<!-- 🌟 대표 상품 -->
		<section class="product-section">
			<div class="section-title">
				<div class="section-title-left">
					<span class="icon">⭐</span>
					<h2>대표 상품</h2>
				</div>
				<a href="${cpath}/${storeUrl}/products" class="view-all">전체보기</a>
			</div>
			<div class="swiper main-product-swiper">
				<div class="swiper-wrapper" id="main-product-swiper-wrapper">
					<!-- 동적으로 인기 스토어 정보가 들어갈 공간 -->
				</div>
				<div class="swiper-pagination store-pagination"></div>
				<div class="swiper-button-prev store-prev"></div>
				<div class="swiper-button-next store-next"></div>
			</div>
		</section>
	</main>
	
  <!-- FOOTER -->
  <footer>
    &copy; 2025 HandCraft Mall. All Rights Reserved.
  </footer>

  <!-- JS -->
  <script src="https://unpkg.com/swiper@9/swiper-bundle.min.js"></script>
  <script src="${pageContext.request.contextPath}/resources/js/main_store.js"></script>
</body>
</html>
