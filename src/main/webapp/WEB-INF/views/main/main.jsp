<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%> 
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>HandCraft Mall</title>
    <%@ include file="/common/header.jsp" %>
  <!-- Swiper CSS -->
  <link rel="stylesheet" href="https://unpkg.com/swiper@9/swiper-bundle.min.css" />

  <!-- Custom CSS -->
  <link rel="stylesheet" type="text/css" href="${cpath}/resources/css/main/main.css">
  <script src="${cpath}/resources/js/main/mainHome.js"></script>  

</head>
<body>
  <input type="hidden" id="cpath" value="${cpath}">
  <jsp:include page="/common/main_nav.jsp" />
  
  <!-- MAIN CONTENT -->
  <main class="container-1440">

<!-- 1. 광고 배너 -->
<!-- 광고 배너 섹션 -->
<section class="banner-section">
	<!-- 왼쪽: 큰 광고 슬라이드 -->
	<div class="banner-left swiper banner-swiper">
		<div class="swiper-wrapper">
			<div class="swiper-slide banner-slide">
				<div class="banner-overlay">
					<div class="banner-text">
						<p class="banner-tag">지금이 기회!</p>
						<h2 class="banner-title">
							개인 판매, <br> 지금 시작하세요!
						</h2>
						<p class="banner-desc">수수료 0원부터 시작하는 수공예 셀러</p>
						<a href="${cpath}/main/sell/sellguide" class="banner-btn">판매하기</a>
					</div>
				</div>
				<img class="banner-background"
					src="${cpath}/resources/images/main/main_banner1.png" alt="광고1">
			</div>

			<div class="swiper-slide banner-slide">
				<div class="banner-overlay">
					<div class="banner-text">
						<p class="banner-tag">놓치지 마세요</p>
						<h2 class="banner-title">
							나만의 스토어를 <br> 오픈해보세요
						</h2>
						<p class="banner-desc2">3개 이상 판매 시 전용 스토어 개설 가능</p>
						<a href="${cpath}/main/store/description" class="banner-btn">런칭하기</a>
					</div>
				</div>
				<img class="banner-background"
					src="${cpath}/resources/images/main/main_banner2.png" alt="광고2">
			</div>
		</div>
		<div class="swiper-pagination banner-pagination"></div>
	</div>

	<!-- 오른쪽: 작은 고정 광고 2개 -->
	<div class="banner-right">

		<div class="small-banner orange">
			<div class="particles"></div>
			<div class="store-label">금주의 인기 스토어 ✨</div>
			<div class="banner-inner" id="topStore"></div>
		</div>

		<div class="small-banner white">

			<div class="banner-inner">
				<div class="text-area">
					<h4>핸드메이드 클래스 오픈 🧵</h4>
					<p class="discount">지금 신청 시 키트 무료!</p>
					<a href="#" class="side-banner-btn" onclick="alert('준비중입니다!')">클래스
						신청하기</a>
				</div>
				<div class="image-area">
					<img src="${cpath}/resources/images/main/main_small_banner2.png"
						alt="클래스 배너">
				</div>
			</div>
		</div>
	</div>
</section>

		<section>
	<div class="section-title">
		<span class="icon">⭐</span>
		<h2>인기 스토어</h2>
	</div>
	<div class="swiper store-swiper">
		<div class="swiper-wrapper" id="store-swiper-wrapper">
			<!-- 동적으로 인기 스토어 정보가 들어갈 공간 -->
		</div>
		<div class="swiper-pagination store-pagination"></div>
		<div class="swiper-button-prev store-prev"></div>
		<div class="swiper-button-next store-next"></div>
	</div>
</section>


<!-- 인기 상품 영역 디벨롭: JSP 포함 버전 -->
<section class="product-section">
	<div class="section-title">
		<span class="icon">⭐</span>
		<h2>인기 상품</h2>
	</div>
	<div class="swiper product-swiper">
		<div class="swiper-wrapper" id="swiper-wrapper">
			<!-- 인기 상품 정보가 들어갈 공간 -->
		</div>

		<div class="swiper-pagination product-pagination"></div>
		<div class="swiper-button-prev product-prev"></div>
		<div class="swiper-button-next product-next"></div>
	</div>
</section>


<!-- 4. 금주 신상품 -->
<section>
	<div class="title-bar">
		<h2>금주 신상품</h2>
		<a href="${cpath}/main/products" class="view-all">전체보기</a>
	</div>
	<div class="preview-grid" id="preview-grid">
		<!-- 신상품 정보가 들어갈 공간 -->
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
