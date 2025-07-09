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
  <section class="store-banner">
    <img src="${cpath}/resources/images/store_banner.png" alt="스토어 배너">
    <div class="store-intro">
      <h1 class="store-name">차차 스토어</h1>
      <p class="store-desc">정성스레 만든 수공예 제품을 소개합니다.</p>
    </div>
  </section>

  <!-- 🔔 스토어 공지사항 -->
  <section class="store-notice">
    <span class="notice-title">공지사항</span>
    <marquee>🎉 7월 한정 할인 이벤트 진행 중! 모든 상품 10% 할인 + 무료배송</marquee>
  </section>

  <!-- 🧭 카테고리 탭 -->
  <section class="category-tabs">
    <button class="tab active">전체</button>
    <button class="tab">인기상품</button>
    <button class="tab">신상품</button>
    <button class="tab">기획전</button>
  </section>

  <!-- 🔥 인기 상품 -->
  <section class="product-section">
    <h2>인기 상품</h2>
    <div class="product-grid" id="best-product-wrapper">
      <!-- 동적 상품 삽입 -->
    </div>
  </section>

  <!-- 🌟 대표 상품 -->
  <section class="product-section">
    <h2>대표 상품</h2>
    <div class="product-grid" id="main-product-wrapper">
      <!-- 동적 상품 삽입 -->
    </div>
  </section>

  <!-- 🧾 리뷰 요약 (선택사항) -->
  <section class="review-summary">
    <h2>고객 후기 요약</h2>
    <p>총 리뷰 수: 1,238개 · 평점 평균 4.8 / 5.0 · 만족도 98%</p>
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
