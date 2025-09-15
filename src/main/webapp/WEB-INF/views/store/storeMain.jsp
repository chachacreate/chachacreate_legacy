<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%> 
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>스토어 메인페이지</title>
  
  <!-- Include Header & Nav (헤더가 먼저 로드되어야 Tailwind 설정이 적용됨) -->
  <jsp:include page="/common/header.jsp" />
  <jsp:include page="/common/storeMain_nav.jsp" />
  
  <!-- 추가 스토어 전용 Tailwind 설정 -->
  <script>
  tailwind.config = {
    theme: {
      extend: {
        fontFamily: {
          'jua': ['Jua', 'ui-sans-serif', 'system-ui', 'sans-serif'],
        },
        colors: {
          'brand-900': '#2D4739',
        },
        maxWidth: {
          '1440': '1440px',
        }
      }
    }
  }
  </script>
  
  <script src="${cpath}/resources/js/store/storeMain.js"></script>
  
  <!-- Swiper CSS -->
  <link rel="stylesheet" href="https://unpkg.com/swiper@9/swiper-bundle.min.css" />
  
  <!-- 커스텀 스타일 -->
  <style>
    /* 헤더 색상 강제 적용 (브랜드 색상이 제대로 로드되지 않을 경우 대비) */
    .bg-brand-900 {
      background-color: #2D4739 !important;
    }
    
    /* Swiper 커스터마이징 */
    .swiper-button-prev:after,
    .swiper-button-next:after {
      font-size: 16px !important;
      font-weight: 600;
    }
    
    .swiper-pagination-bullet {
      width: 8px !important;
      height: 8px !important;
      margin: 0 4px !important;
    }
    
    .swiper-pagination-bullet-active {
      transform: scale(1.2);
    }

    /* 마키 애니메이션 개선 */
    marquee {
      animation-duration: 20s;
    }
    
    /* 반응형 스와이퍼 간격 */
    @media (max-width: 640px) {
      .swiper-slide {
        padding: 0 8px;
      }
    }
    
    @media (min-width: 641px) {
      .swiper-slide {
        padding: 0 12px;
      }
    }

    /* 반응형 패딩 조정 */
    .responsive-padding {
      padding-left: 1rem;
      padding-right: 1rem;
    }
    
    @media (min-width: 640px) {
      .responsive-padding {
        padding-left: 2rem;
        padding-right: 2rem;
      }
    }
    
    @media (min-width: 1280px) {
      .responsive-padding {
        padding-left: 240px;
        padding-right: 240px;
      }
    }

    /* Jua 폰트 강제 적용 */
    body, * {
      font-family: 'Jua', ui-sans-serif, system-ui, sans-serif !important;
    }
    
    /* 특정 요소들의 폰트 가중치 조정 (Jua는 단일 가중치만 제공) */
    .font-bold, .font-semibold, .font-medium {
      font-weight: 400 !important;
      letter-spacing: 0.025em;
    }
    
    /* 이미지 깨짐 방지 및 일관된 디자인 */
    .product-image-box {
      aspect-ratio: 1 / 1;
      overflow: hidden;
      border-radius: 12px;
      background: #f8fafc;
      position: relative;
    }
    
    .product-image-box > .product-img {
      width: 100%;
      height: 100%;
      display: block;
      object-fit: cover;
      object-position: center;
      transition: transform 0.3s ease;
    }
    
    .product-image-box:hover > .product-img {
      transform: scale(1.05);
    }

    /* ---------- 수정: 스토어 로고 이미지 고정 컨테이너 + 이미지 채우기 ---------- */
    /* 기존 min-width/min-height 제거하고, 컨테이너 기준 100% 채우기 */
    #store-logo {
      width: 100%;
      height: 100%;
      object-fit: cover;
      object-position: center;
      transition: opacity 0.3s ease;
      background: #f8fafc;
      display: block;
    }

    /* 메인 제품 카드 이미지 */
    .card .store-img {
      width: 100%;
      aspect-ratio: 1 / 1;
      display: block;
      object-fit: cover;
      object-position: center;
      border-radius: 12px;
      background: #f8fafc;
      transition: transform 0.3s ease;
    }
    
    .card:hover .store-img {
      transform: scale(1.05);
    }

    /* 이미지 로딩 상태 */
    .image-loading {
      background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
      background-size: 200% 100%;
      animation: loading 1.5s infinite;
    }
    
    @keyframes loading {
      0% { background-position: 200% 0; }
      100% { background-position: -200% 0; }
    }

    /* 이미지 에러 상태 */
    .image-error {
      display: flex;
      align-items: center;
      justify-content: center;
      background: #f8fafc;
      color: #6b7280;
      font-size: 12px;
      text-align: center;
    }
    
    .image-error::before {
      content: "📷";
      display: block;
      font-size: 24px;
      margin-bottom: 4px;
    }
    
    /* Lazy loading을 위한 스타일 */
    .lazy-image {
      opacity: 0;
      transition: opacity 0.3s ease;
    }
    
    .lazy-image.loaded {
      opacity: 1;
    }
  </style>
</head>
<body class="bg-white font-store text-gray-900">
<input type="hidden" id="cpath" value="${cpath}">
<input type="hidden" id="storeUrl" value="${storeUrl}">

  <!-- MAIN CONTENT -->
  <main class="w-full">
  
    <!-- 히어로 섹션 -->
    <section class="w-full">
      <div class="w-full bg-store-hero-bg">
        <div class="h-[200px] sm:h-[240px] lg:h-[280px]"></div>
      </div>
      <div class="relative">
        <div class="w-full responsive-padding">
          <div class="-mt-[88px] sm:-mt-[100px]">
            <div class="rounded-2xl border border-gray-200 bg-white p-6 sm:p-8 shadow-sm">
              <div id="store-banner" class="flex flex-col sm:flex-row items-start gap-4 sm:gap-6">
                <!-- 스토어 로고 (수정: 고정 정사각형 컨테이너) -->
                <div class="relative w-16 h-16 sm:w-20 sm:h-20 rounded-xl overflow-hidden border border-gray-200 bg-[#f8fafc] flex-shrink-0">
                  <img 
  id="store-logo" 
  src="" 
  alt="스토어 로고" 
  class="lazy-image w-full h-full object-cover object-center"
  style="width: 100% !important; height: 100% !important; object-fit: cover !important;"
  loading="lazy"
  onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';"
/>
                  <div class="absolute inset-0 rounded-xl image-error" style="display: none;">
                    이미지 없음
                  </div>
                </div>
                
                <!-- 스토어 정보 -->
                <div class="flex-1 min-w-0">
                  <h1 id="store-title" class="text-xl sm:text-2xl lg:text-3xl font-bold tracking-tight text-gray-900">
                    <!-- 스토어명이 동적으로 들어갑니다 -->
                  </h1>
                  <p id="store-description" class="mt-2 text-sm sm:text-base leading-relaxed text-store-desc">
                    <!-- 스토어 설명이 동적으로 들어갑니다 -->
                  </p>
                  
                  <!-- 액션 버튼들 -->
                  <div class="mt-4 flex flex-wrap gap-3">
                    <a href="${cpath}/${storeUrl}/products"
                       class="inline-flex items-center justify-center rounded-lg px-4 py-2 text-sm font-semibold text-white bg-store-highlight hover:opacity-95 transition-opacity">
                      전체 상품 보기
                      <svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
                      </svg>
                    </a>
                    <a href="${cpath}/${storeUrl}/notices"
                       class="inline-flex items-center justify-center rounded-lg px-4 py-2 text-sm font-semibold text-gray-700 bg-white border border-gray-200 hover:bg-gray-50 transition-colors">
                      공지사항
                    </a>
                  </div>
                </div>
              </div>
            </div>
            <div class="h-6"></div>
          </div>
        </div>
      </div>
    </section>

    <!-- 스토어 공지사항 -->
    <section class="w-full responsive-padding">
      <div class="rounded-xl border border-gray-200 p-4 sm:p-5 lg:p-6 bg-white">
        <div class="text-sm font-semibold mb-2 text-store-notice">
          공지사항
        </div>
        <div class="overflow-hidden">
          <marquee id="important-notice" class="text-sm sm:text-base leading-relaxed text-gray-700">
            <!-- 공지사항 내용이 동적으로 들어갑니다 -->
          </marquee>
        </div>
      </div>
    </section>

    <!-- 인기 상품 섹션 -->
    <section class="w-full responsive-padding mt-8 sm:mt-10">
      <div class="flex flex-col sm:flex-row sm:items-end sm:justify-between gap-2 sm:gap-4">
        <div>
          <h2 class="text-lg sm:text-xl lg:text-2xl font-bold tracking-tight text-store-highlight flex items-center gap-2">
            <span class="text-xl sm:text-2xl">⭐</span>
            인기 상품
          </h2>
          <p class="mt-1 text-xs sm:text-sm text-gray-500">구매수가 많은 상품을 모았어요</p>
        </div>
        <a href="${cpath}/${storeUrl}/products" 
           class="inline-flex items-center gap-1 text-xs sm:text-sm font-medium text-gray-700 hover:text-gray-900 transition-colors self-start sm:self-auto">
          전체보기
          <svg class="w-3 h-3 sm:w-4 sm:h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
          </svg>
        </a>
      </div>
      
      <div class="mt-4 sm:mt-5 relative">
        <div class="swiper best-product-swiper overflow-hidden rounded-xl">
          <div class="swiper-wrapper" id="best-product-swiper-wrapper">
            <!-- 인기 상품 정보가 들어갈 공간 -->
          </div>
          
          <!-- Navigation - 모바일에서는 숨김 -->
          <div class="swiper-button-prev product-prev hidden sm:block !w-8 !h-8 lg:!w-10 lg:!h-10 !mt-0 !left-2 !top-1/2 !-translate-y-1/2 
                      bg-white/90 rounded-full shadow-lg border border-gray-200 
                      after:!text-gray-600 after:!text-xs lg:after:!text-sm after:!font-bold
                      hover:bg-white transition-all duration-200"></div>
          <div class="swiper-button-next product-next hidden sm:block !w-8 !h-8 lg:!w-10 lg:!h-10 !mt-0 !right-2 !top-1/2 !-translate-y-1/2 
                      bg-white/90 rounded-full shadow-lg border border-gray-200 
                      after:!text-gray-600 after:!text-xs lg:after:!text-sm after:!font-bold
                      hover:bg-white transition-all duration-200"></div>
          
          <!-- Pagination -->
          <div class="swiper-pagination product-pagination !bottom-2 sm:!bottom-4 
                      [&_.swiper-pagination-bullet]:!bg-white/70 [&_.swiper-pagination-bullet]:!border [&_.swiper-pagination-bullet]:!border-gray-300
                      [&_.swiper-pagination-bullet-active]:!bg-store-highlight [&_.swiper-pagination-bullet-active]:!border-store-highlight"></div>
        </div>
      </div>
    </section>

    <!-- 대표 상품 섹션 -->
    <section class="w-full responsive-padding mt-8 sm:mt-10">
      <div class="flex flex-col sm:flex-row sm:items-end sm:justify-between gap-2 sm:gap-4">
        <div>
          <h2 class="text-lg sm:text-xl lg:text-2xl font-bold tracking-tight text-store-highlight flex items-center gap-2">
            <span class="text-xl sm:text-2xl">⭐</span>
            대표 상품
          </h2>
          <p class="mt-1 text-xs sm:text-sm text-gray-500">판매자가 추천하는 스토어 대표작</p>
        </div>
        <a href="${cpath}/${storeUrl}/products" 
           class="inline-flex items-center gap-1 text-xs sm:text-sm font-medium text-gray-700 hover:text-gray-900 transition-colors self-start sm:self-auto">
          전체보기
          <svg class="w-3 h-3 sm:w-4 sm:h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
          </svg>
        </a>
      </div>
      
      <div class="mt-4 sm:mt-5 relative">
        <div class="swiper main-product-swiper overflow-hidden rounded-xl">
          <div class="swiper-wrapper" id="main-product-swiper-wrapper">
            <!-- 대표 상품 정보가 들어갈 공간 -->
          </div>
          
          <!-- Navigation - 모바일에서는 숨김 -->
          <div class="swiper-button-prev store-prev hidden sm:block !w-8 !h-8 lg:!w-10 lg:!h-10 !mt-0 !left-2 !top-1/2 !-translate-y-1/2 
                      bg-white/90 rounded-full shadow-lg border border-gray-200 
                      after:!text-gray-600 after:!text-xs lg:after:!text-sm after:!font-bold
                      hover:bg-white transition-all duration-200"></div>
          <div class="swiper-button-next store-next hidden sm:block !w-8 !h-8 lg:!w-10 lg:!h-10 !mt-0 !right-2 !top-1/2 !-translate-y-1/2 
                      bg-white/90 rounded-full shadow-lg border border-gray-200 
                      after:!text-gray-600 after:!text-xs lg:after:!text-sm after:!font-bold
                      hover:bg-white transition-all duration-200"></div>
          
          <!-- Pagination -->
          <div class="swiper-pagination store-pagination !bottom-2 sm:!bottom-4 
                      [&_.swiper-pagination-bullet]:!bg-white/70 [&_.swiper-pagination-bullet]:!border [&_.swiper-pagination-bullet]:!border-gray-300
                      [&_.swiper-pagination-bullet-active]:!bg-store-highlight [&_.swiper-pagination-bullet-active]:!border-store-highlight"></div>
        </div>
      </div>
    </section>

    <!-- 여백 -->
    <div class="h-8 sm:h-12"></div>
  </main>
  
  <!-- FOOTER -->
  <footer class="mt-8 sm:mt-12 w-full bg-gray-50">
    <div class="w-full responsive-padding py-6 sm:py-8 text-xs sm:text-sm text-gray-500 text-center">
      &copy; 2025 HandCraft Mall. All Rights Reserved.
    </div>
  </footer>
  
  <!-- JS -->
  <script src="https://unpkg.com/swiper@9/swiper-bundle.min.js"></script>
  <script src="${pageContext.request.contextPath}/resources/js/main_store.js"></script>
  
  <!-- 이미지 로딩 및 에러 처리 스크립트 -->
  <script>
    // 이미지 로딩 개선 함수
    function handleImageLoad(img) {
      img.classList.add('loaded');
    }
    
    function handleImageError(img) {
      img.style.display = 'none';
      const errorDiv = img.nextElementSibling;
      if (errorDiv && errorDiv.classList.contains('image-error')) {
        errorDiv.style.display = 'flex';
      }
    }
    
    // 페이지 로드 후 이미지 처리
    document.addEventListener('DOMContentLoaded', function() {
      // 모든 이미지에 로딩 처리 추가
      const images = document.querySelectorAll('img');
      images.forEach(img => {
        // 이미 로드된 이미지 처리
        if (img.complete && img.naturalHeight !== 0) {
          handleImageLoad(img);
        } else {
          // 로딩 중인 이미지 처리
          img.addEventListener('load', () => handleImageLoad(img));
          img.addEventListener('error', () => handleImageError(img));
        }
      });
    });
    
    // 동적으로 추가되는 이미지 처리를 위한 MutationObserver
    const observer = new MutationObserver(function(mutations) {
      mutations.forEach(function(mutation) {
        mutation.addedNodes.forEach(function(node) {
          if (node.nodeType === 1) { // Element node
            const images = node.tagName === 'IMG' ? [node] : node.querySelectorAll('img');
            images.forEach(img => {
              img.addEventListener('load', () => handleImageLoad(img));
              img.addEventListener('error', () => handleImageError(img));
            });
          }
        });
      });
    });
    
    observer.observe(document.body, {
      childList: true,
      subtree: true
    });
  </script>
</body>
</html>
