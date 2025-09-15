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
  
  <!-- Include Header & Nav -->
  <jsp:include page="/common/header.jsp" />
  <jsp:include page="/common/storeMain_nav.jsp" />
  
  <!-- Tailwind 설정 -->
  <script>
  tailwind.config = {
    theme: {
      extend: {
        fontFamily: {
          'jua': ['Jua', 'ui-sans-serif', 'system-ui', 'sans-serif'],
        },
        colors: {
          'brand-900': '#2D4739',
          'store-hero-bg': '#F3F0E8',
          'store-highlight': '#2D4739',
          'store-notice': '#7A241F',
          'store-desc': '#4B5563',
        }
      }
    }
  }
  </script>
  
  <script src="${cpath}/resources/js/store/storeMain.js"></script>
  
  <!-- Swiper CSS -->
  <link rel="stylesheet" href="https://unpkg.com/swiper@9/swiper-bundle.min.css" />
  
</head>
<body class="bg-white font-jua text-gray-900">
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
        <div class="w-full px-4 sm:px-8 xl:px-60">
          <div class="-mt-[88px] sm:-mt-[100px]">
            <div class="rounded-2xl border border-gray-200 bg-white p-6 sm:p-8 shadow-sm">
              <div id="store-banner" class="flex flex-col sm:flex-row items-start gap-4 sm:gap-6">
                <!-- 스토어 로고 -->
                <div class="w-16 h-16 sm:w-20 sm:h-20 rounded-xl overflow-hidden border border-gray-200 bg-gray-50 flex items-center justify-center flex-shrink-0">
                  <img 
                    id="store-logo" 
                    src="" 
                    alt="스토어 로고"
                    class="w-full h-full object-cover object-center opacity-0 transition-opacity duration-300"
                    onerror="this.classList.add('opacity-0'); this.parentElement.classList.add('bg-gray-100')"
                    onload="this.classList.remove('opacity-0'); this.classList.add('opacity-100')"
                  />
                  <!-- 이미지 로딩 실패시 대체 아이콘 -->
                  <div class="absolute inset-0 flex items-center justify-center text-gray-400 opacity-50 pointer-events-none">
                    <svg class="w-6 h-6 sm:w-8 sm:h-8" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
                    </svg>
                  </div>
                </div>
                
                <!-- 스토어 정보 -->
                <div class="flex-1 min-w-0">
                  <h1 id="store-title" class="text-xl sm:text-2xl lg:text-3xl font-normal tracking-wide text-gray-900">
                    <!-- 스토어명이 동적으로 들어갑니다 -->
                  </h1>
                  <p id="store-description" class="mt-2 text-sm sm:text-base leading-relaxed text-store-desc">
                    <!-- 스토어 설명이 동적으로 들어갑니다 -->
                  </p>
                  
                  <!-- 액션 버튼들 -->
                  <div class="mt-4 flex flex-wrap gap-3">
                    <a href="${cpath}/${storeUrl}/products"
                       class="inline-flex items-center justify-center rounded-lg px-4 py-2 text-sm font-normal text-white bg-store-highlight hover:opacity-95 transition-opacity tracking-wider">
                      전체 상품 보기
                      <svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
                      </svg>
                    </a>
                    <a href="${cpath}/${storeUrl}/notices"
                       class="inline-flex items-center justify-center rounded-lg px-4 py-2 text-sm font-normal text-gray-700 bg-white border border-gray-200 hover:bg-gray-50 transition-colors tracking-wider">
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
    <section class="w-full px-4 sm:px-8 xl:px-60">
      <div class="rounded-xl border border-gray-200 p-4 sm:p-5 lg:p-6 bg-white">
        <div class="text-sm font-normal mb-2 text-store-notice tracking-wider">
          공지사항
        </div>
        <div class="overflow-hidden">
          <div id="important-notice" class="text-sm sm:text-base leading-relaxed text-gray-700 animate-marquee whitespace-nowrap">
            <!-- 공지사항 내용이 동적으로 들어갑니다 -->
          </div>
        </div>
      </div>
    </section>

    <!-- 인기 상품 섹션 -->
    <section class="w-full px-4 sm:px-8 xl:px-60 mt-8 sm:mt-10">
      <div class="flex flex-col sm:flex-row sm:items-end sm:justify-between gap-2 sm:gap-4">
        <div>
          <h2 class="text-lg sm:text-xl lg:text-2xl font-normal tracking-wide text-store-highlight flex items-center gap-2">
            <span class="text-xl sm:text-2xl">⭐</span>
            인기 상품
          </h2>
          <p class="mt-1 text-xs sm:text-sm text-gray-500">구매수가 많은 상품을 모았어요</p>
        </div>
        <a href="${cpath}/${storeUrl}/products" 
           class="inline-flex items-center gap-1 text-xs sm:text-sm font-normal text-gray-700 hover:text-gray-900 transition-colors self-start sm:self-auto">
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
    <section class="w-full px-4 sm:px-8 xl:px-60 mt-8 sm:mt-10">
      <div class="flex flex-col sm:flex-row sm:items-end sm:justify-between gap-2 sm:gap-4">
        <div>
          <h2 class="text-lg sm:text-xl lg:text-2xl font-normal tracking-wide text-store-highlight flex items-center gap-2">
            <span class="text-xl sm:text-2xl">⭐</span>
            대표 상품
          </h2>
          <p class="mt-1 text-xs sm:text-sm text-gray-500">판매자가 추천하는 스토어 대표작</p>
        </div>
        <a href="${cpath}/${storeUrl}/products" 
           class="inline-flex items-center gap-1 text-xs sm:text-sm font-normal text-gray-700 hover:text-gray-900 transition-colors self-start sm:self-auto">
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
    <div class="w-full px-4 sm:px-8 xl:px-60 py-6 sm:py-8 text-xs sm:text-sm text-gray-500 text-center">
      &copy; 2025 HandCraft Mall. All Rights Reserved.
    </div>
  </footer>
  
  <!-- JS -->
  <script src="https://unpkg.com/swiper@9/swiper-bundle.min.js"></script>
  <script src="${pageContext.request.contextPath}/resources/js/main_store.js"></script>
  
  <!-- 마키 애니메이션을 위한 추가 설정 -->
  <script>
    // 마키 애니메이션 구현
    function createMarqueeEffect() {
      const noticeElement = document.getElementById('important-notice');
      if (noticeElement && noticeElement.textContent.trim()) {
        const text = noticeElement.textContent;
        noticeElement.innerHTML = `<span class="inline-block animate-marquee">${text}</span>`;
      }
    }
    
    // 페이지 로드 후 마키 효과 적용
    document.addEventListener('DOMContentLoaded', function() {
      setTimeout(createMarqueeEffect, 1000);
    });
  </script>
  
  <!-- 마키 애니메이션 CSS를 Tailwind로 추가 -->
  <style>
    @keyframes marquee {
      0% { transform: translateX(100%); }
      100% { transform: translateX(-100%); }
    }
    
    .animate-marquee {
      animation: marquee 20s linear infinite;
    }
  </style>
</body>
</html>