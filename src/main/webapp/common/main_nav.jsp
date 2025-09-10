<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%> 
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />
<c:set var="uri" value="${pageContext.request.requestURI}" />
<c:set var="servletPath" value="${pageContext.request.servletPath}" />
<c:set var="requestURL" value="${pageContext.request.requestURL}" />

<!-- 디버깅용 - 실제 요청 경로 확인 -->
<%-- <div style="position: fixed; top: 100px; left: 10px; background: red; color: white; padding: 10px; z-index: 9999; font-size: 12px; width: 400px;">
    URI: ${uri}<br/>
    ServletPath: ${servletPath}<br/>
    RequestURL: ${requestURL}<br/>
    Context Path: ${cpath}
</div> --%>

<!-- Tailwind CSS -->
  <script src="https://cdn.tailwindcss.com"></script>
  
  <!-- Google Fonts - Jua -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Jua&display=swap" rel="stylesheet">

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

<!-- 상단 네브 (스크롤 시 반투명/블러) -->
<nav
  id="main-nav"
  data-scrolled="false"
  class="sticky top-0 z-50 w-full bg-white shadow-[0_4px_8px_rgba(0,0,0,0.08)] font-jua
         transition-[background-color,backdrop-filter,box-shadow] duration-200
         data-[scrolled=true]:bg-white/70 data-[scrolled=true]:backdrop-blur
         data-[scrolled=true]:shadow data-[scrolled=true]:supports-[backdrop-filter]:bg-white/50"
>
  <div class="mx-auto w-full max-w-[1920px] px-4 md:px-6 xl:px-20 2xl:px-[240px]">
    <div class="flex items-center justify-between h-12 md:h-20">
      <!-- 로고 -->
      <div class="hidden md:flex items-center">
        <a href="${cpath}/main" class="inline-flex items-center hover:opacity-90">
          <img src="${cpath}/resources/images/logo/logohorizon_green.png" alt="뜨락상회 로고" class="h-9 md:h-20" />
        </a>
      </div>

      <!-- 상단 네브 (메뉴 부분만 교체) -->
      <div class="col-start-2 flex w-full md:w-auto justify-between md:justify-start gap-0 md:gap-8">
        <!-- 전체상품 -->
        <a href="${cpath}/main/products"
           class="group relative flex-1 md:flex-none text-center md:text-left text-[#2D4739] hover:text-[#1b2e23] text-[14px] md:text-[18px] py-2 md:py-0 md:pb-1
                  ${fn:contains(uri, 'mainAllProducts.jsp') ? 'font-bold' : ''}">
          전체상품
          <span class="pointer-events-none absolute left-0 md:bottom-[5px] bottom-[2px] h-[2px] rounded bg-[#2D4739] transition-all duration-200
                       ${fn:contains(uri, 'mainAllProducts.jsp') ? '' : 'w-0 group-hover:w-full'}"></span>
        </a>

        <!-- 스토어 -->
        <a href="${cpath}/main/stores"
           class="group relative flex-1 md:flex-none text-center md:text-left text-[#2D4739] hover:text-[#1b2e23] text-[14px] md:text-[18px] py-2 md:py-0 md:pb-1
                  ${fn:contains(uri, 'mainStoreList.jsp') ? 'font-bold' : ''}">
          스토어
          <span class="pointer-events-none absolute left-0 md:bottom-[5px] bottom-[2px] h-[2px] rounded bg-[#2D4739] transition-all duration-200
                       ${fn:contains(uri, 'mainStoreList.jsp') ? '' : 'w-0 group-hover:w-full'}"></span>
        </a>

        <!-- 개인판매 -->
        <a href="${cpath}/main/sell/sellguide"
           class="group relative flex-1 md:flex-none text-center md:text-left text-[#2D4739] hover:text-[#1b2e23] text-[14px] md:text-[18px] py-2 md:py-0 md:pb-1
                  ${fn:contains(uri, 'personalSellInfo.jsp') ? 'font-bold' : ''}">
          개인판매
          <span class="pointer-events-none absolute left-0 md:bottom-[5px] bottom-[2px] h-[2px] rounded bg-[#2D4739] transition-all duration-200
                       ${fn:contains(uri, 'personalSellInfo.jsp') ? '' : 'w-0 group-hover:w-full'}"></span>
        </a>

        <!-- 클래스 -->
        <a href="${cpath}/main/classes"
           class="group relative flex-1 md:flex-none text-center md:text-left text-[#2D4739] hover:text-[#1b2e23] text-[14px] md:text-[18px] py-2 md:py-0 md:pb-1
                  ${fn:contains(uri, '/main/classes') ? 'font-bold' : ''}">
          클래스
          <span class="pointer-events-none absolute left-0 md:bottom-[5px] bottom-[2px] h-[2px] rounded bg-[#2D4739] transition-all duration-200
                       ${fn:contains(uri, '/main/classes') ? '' : 'w-0 group-hover:w-full'}"></span>
        </a>

        <!-- 마이페이지 (장바구니 제외 매칭) -->
        <a href="${cpath}/main/mypage"
           class="group relative hidden md:inline-flex text-[#2D4739] hover:text-[#1b2e23] text-[18px] md:pb-1
                  ${fn:contains(uri, 'mainMyPage.jsp') ? 'font-bold' : ''}">
          마이페이지
          <span class="pointer-events-none absolute left-0 md:bottom-[5px] bottom-[2px] h-[2px] rounded bg-[#2D4739] transition-all duration-200
                       ${fn:contains(uri, 'mainMyPage.jsp') ? '' : 'w-0 group-hover:w-full'}"></span>
        </a>

        <!-- 장바구니 -->
        <a href="${cpath}/main/mypage/cart"
           class="group relative hidden md:inline-flex text-[#2D4739] hover:text-[#1b2e23] text-[18px] md:pb-1
                  ${fn:contains(uri, 'cart.jsp') ? 'font-bold' : ''}">
          장바구니
          <span class="pointer-events-none absolute left-0 md:bottom-[5px] bottom-[2px] h-[2px] rounded bg-[#2D4739] transition-all duration-200
                       ${fn:contains(uri, 'cart.jsp') ? '' : 'w-0 group-hover:w-full'}"></span>
        </a>
      </div>
    </div>
  </div>
</nav>

<!-- ✅ 모바일 하단 고정 네브바 (React와 동일 구성) -->
<nav
  class="md:hidden fixed left-1/2 bottom-0 z-50 w-full -translate-x-1/2 border-t bg-white font-jua"
  style="padding-bottom: env(safe-area-inset-bottom);"
  aria-label="모바일 하단 내비게이션"
>
  <div class="mx-auto w-full max-w-[1920px] px-4">
    <ul class="grid grid-cols-3 h-14">
      <!-- 홈 -->
      <li class="flex items-center justify-center">
        <a href="${cpath}/main"
           class="flex flex-col items-center justify-center gap-1 w-full h-full text-[#2D4739] opacity-90 hover:opacity-100">
          <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" aria-hidden="true">
            <path d="M3 10.5L12 3l9 7.5V20a1 1 0 0 1-1 1h-5v-6H9v6H4a1 1 0 0 1-1-1v-9.5Z" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
          <span class="text-[12px] leading-none">홈</span>
        </a>
      </li>

      <!-- 장바구니 -->
      <li class="flex items-center justify-center">
        <a href="${cpath}/main/mypage/cart"
           class="flex flex-col items-center justify-center gap-1 w-full h-full text-[#2D4739] opacity-90 hover:opacity-100">
          <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" aria-hidden="true">
            <path d="M3 3h2l2 12h10l2-8H7" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
            <circle cx="9" cy="20" r="1.5" stroke="currentColor" stroke-width="1.6"/>
            <circle cx="17" cy="20" r="1.5" stroke="currentColor" stroke-width="1.6"/>
          </svg>
          <span class="text-[12px] leading-none">장바구니</span>
        </a>
      </li>

      <!-- 마이페이지 -->
      <li class="flex items-center justify-center">
        <a href="${cpath}/main/mypage"
           class="flex flex-col items-center justify-center gap-1 w-full h-full text-[#2D4739] opacity-90 hover:opacity-100">
          <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" aria-hidden="true">
            <circle cx="12" cy="8" r="3.25" stroke="currentColor" stroke-width="1.6"/>
            <path d="M5 19a7 7 0 0 1 14 0" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"/>
          </svg>
          <span class="text-[12px] leading-none">마이페이지</span>
        </a>
      </li>
    </ul>
  </div>
</nav>

<!-- 스크롤 시 반투명/블러 토글 스크립트 -->
<script>
(function () {
  var nav = document.getElementById('main-nav');
  if (!nav) return;
  function onScroll() {
    nav.dataset.scrolled = (window.scrollY > 8) ? "true" : "false";
  }
  onScroll();
  window.addEventListener('scroll', onScroll, { passive: true });
})();
</script>