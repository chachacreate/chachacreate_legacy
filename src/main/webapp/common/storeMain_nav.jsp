<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn"   uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c"    uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />
<c:set var="uri"   value="${pageContext.request.requestURI}" />

<script src="${cpath}/resources/js/store/storeMain_nav.js"></script>

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

<!-- 스토어 상단 네비게이션 (스크롤 시 반투명/블러) -->
<nav
  id="store-nav"
  data-scrolled="false"
  class="sticky top-0 z-50 w-full bg-white shadow-[0_4px_8px_rgba(0,0,0,0.08)] font-jua
         transition-[background-color,backdrop-filter,box-shadow] duration-200
         data-[scrolled=true]:bg-white/70 data-[scrolled=true]:backdrop-blur
         data-[scrolled=true]:shadow data-[scrolled=true]:supports-[backdrop-filter]:bg-white/50"
  aria-label="스토어 상단 내비게이션"
>
  <div class="mx-auto w-full max-w-[1920px] px-4 md:px-6 xl:px-20 2xl:px-[240px]">
    <div class="flex items-center justify-between h-16 md:h-20">

      <!-- 로고 & 스토어명 -->
      <div class="flex items-center gap-3 md:gap-6 min-w-0">
        <a href="${cpath}/${storeUrl}" class="flex-shrink-0 hover:opacity-90" aria-label="스토어 홈">
          <img src="${logoImg}" alt="스토어 로고" class="h-12 md:h-16 w-auto object-contain" />
        </a>
        <div class="min-w-0">
          <h1 class="text-lg md:text-2xl font-bold text-[#1b2e23] truncate leading-tight">
            ${storeName}
          </h1>
        </div>
      </div>

      <!-- 데스크톱 메뉴 -->
      <div class="hidden lg:flex items-center gap-6 xl:gap-8">
        <a href="${cpath}/${storeUrl}/products"
           class="group relative text-[#2D4739] hover:text-[#1b2e23] text-base xl:text-lg pb-1
                  ${fn:contains(uri, '/products') ? 'font-bold' : ''}">
          전체상품
          <span class="pointer-events-none absolute left-0 bottom-0 h-[2px] rounded bg-[#2D4739] transition-all duration-200
                       ${fn:contains(uri, '/products') ? 'w-full' : 'w-0 group-hover:w-full'}"></span>
        </a>

        <a href="${cpath}/${storeUrl}/info"
           class="group relative text-[#2D4739] hover:text-[#1b2e23] text-base xl:text-lg pb-1
                  ${fn:contains(uri, '/info') ? 'font-bold' : ''}">
          스토어 정보
          <span class="pointer-events-none absolute left-0 bottom-0 h-[2px] rounded bg-[#2D4739] transition-all duration-200
                       ${fn:contains(uri, '/info') ? 'w-full' : 'w-0 group-hover:w-full'}"></span>
        </a>

        <a href="${cpath}/${storeUrl}/classes"
                class="group relative text-[#2D4739] hover:text-[#1b2e23] text-base xl:text-lg pb-1
                  ${fn:contains(uri, '/notices') ? 'font-bold' : ''}">
          클래스
          <span class="pointer-events-none absolute left-0 bottom-0 h-[2px] rounded bg-[#2D4739] transition-all duration-200
                       ${fn:contains(uri, '/classes') ? 'w-full' : 'w-0 group-hover:w-full'}"></span>
        </a>

        <a href="${cpath}/${storeUrl}/notices"
           class="group relative text-[#2D4739] hover:text-[#1b2e23] text-base xl:text-lg pb-1
                  ${fn:contains(uri, '/notices') ? 'font-bold' : ''}">
          공지/소식
          <span class="pointer-events-none absolute left-0 bottom-0 h-[2px] rounded bg-[#2D4739] transition-all duration-200
                       ${fn:contains(uri, '/notices') ? 'w-full' : 'w-0 group-hover:w-full'}"></span>
        </a>

        <a href="${cpath}/${storeUrl}/mypage"
           class="group relative text-[#2D4739] hover:text-[#1b2e23] text-base xl:text-lg pb-1
                  ${fn:contains(uri, '/mypage') and not fn:contains(uri, '/mypage/cart') ? 'font-bold' : ''}">
          마이페이지
          <span class="pointer-events-none absolute left-0 bottom-0 h-[2px] rounded bg-[#2D4739] transition-all duration-200
                       ${fn:contains(uri, '/mypage') and not fn:contains(uri, '/mypage/cart') ? 'w-full' : 'w-0 group-hover:w-full'}"></span>
        </a>

        <a href="${cpath}/${storeUrl}/mypage/cart"
           class="group relative text-[#2D4739] hover:text-[#1b2e23] text-base xl:text-lg pb-1
                  ${fn:contains(uri, '/mypage/cart') ? 'font-bold' : ''}">
          장바구니
          <span class="pointer-events-none absolute left-0 bottom-0 h-[2px] rounded bg-[#2D4739] transition-all duration-200
                       ${fn:contains(uri, '/mypage/cart') ? 'w-full' : 'w-0 group-hover:w-full'}"></span>
        </a>

        <c:if test="${loginMember.memberId == storeOwnerId}">
          <!-- ✅ 관리자 라우팅: /seller/${storeUrl}/main 로 통일 -->
          <a href="${cpath}/seller/${storeUrl}/main"
             class="group relative text-[#2D4739] hover:text-[#1b2e23] text-base xl:text-lg pb-1">
            스토어 관리
            <span class="pointer-events-none absolute left-0 bottom-0 h-[2px] rounded bg-[#2D4739] transition-all duration-200
                         w-0 group-hover:w-full"></span>
          </a>
        </c:if>

        <a href="${cpath}/main"
           class="group relative text-[#2D4739] hover:text-[#1b2e23] text-base xl:text-lg pb-1">
          메인 홈 
          <span class="pointer-events-none absolute left-0 bottom-0 h-[2px] rounded bg-[#2D4739] transition-all duration-200
                       w-0 group-hover:w-full"></span>
        </a>
      </div>

      <!-- 모바일/태블릿 햄버거 메뉴 -->
      <button
        type="button"
        onclick="toggleStoreMenu()"
        class="lg:hidden p-2 text-[#2D4739] hover:text-[#1b2e23]"
        aria-label="메뉴 열기"
        id="store-menu-button"
      >
        <svg class="h-6 w-6" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
          <path id="store-menu-icon" d="M3 6h18v2H3V6zm0 5h18v2H3v-2zm0 5h18v2H3v-2z" />
          <path id="store-close-icon" class="hidden" fill-rule="evenodd" d="M6.225 4.811a1 1 0 0 1 1.414 0L12 9.172l4.361-4.361a1 1 0 0 1 1.414 1.414L13.414 10.586l4.361 4.361a1 1 0 0 1-1.414 1.414L12 12l-4.361 4.361a1 1 0 0 1-1.414-1.414l4.361-4.361-4.361-4.361a1 1 0 0 1 0-1.414Z" clip-rule="evenodd" />
        </svg>
      </button>
    </div>

    <!-- 모바일 드롭다운 메뉴 -->
    <div id="store-mobile-menu" class="hidden lg:hidden border-t border-gray-200 bg-white">
      <div class="py-3 space-y-1">
        <a href="${cpath}/${storeUrl}/products"
           class="block px-3 py-2 text-base text-[#2D4739] hover:text-[#1b2e23] hover:bg-gray-50 rounded
                  ${fn:contains(uri, '/products') ? 'font-bold bg-gray-50' : ''}">
          전체상품
        </a>

        <a href="${cpath}/${storeUrl}/info"
           class="block px-3 py-2 text-base text-[#2D4739] hover:text-[#1b2e23] hover:bg-gray-50 rounded
                  ${fn:contains(uri, '/info') ? 'font-bold bg-gray-50' : ''}">
          스토어 정보 !!!!
        </a>

        <a href="${cpath}/${storeUrl}/classes"
                class="block px-3 py-2 text-base text-[#2D4739] hover:text-[#1b2e23] hover:bg-gray-50 rounded
                  ${fn:contains(uri, '/classes') ? 'font-bold bg-gray-50' : ''}">
          클래스
        </a>

        <a href="${cpath}/${storeUrl}/notices"
           class="block px-3 py-2 text-base text-[#2D4739] hover:text-[#1b2e23] hover:bg-gray-50 rounded
                  ${fn:contains(uri, '/notices') ? 'font-bold bg-gray-50' : ''}">
          공지/소식
        </a>

        <a href="${cpath}/${storeUrl}/mypage"
           class="block px-3 py-2 text-base text-[#2D4739] hover:text-[#1b2e23] hover:bg-gray-50 rounded
                  ${fn:contains(uri, '/mypage') and not fn:contains(uri, '/mypage/cart') ? 'font-bold bg-gray-50' : ''}">
          마이페이지
        </a>

        <a href="${cpath}/${storeUrl}/mypage/cart"
           class="block px-3 py-2 text-base text-[#2D4739] hover:text-[#1b2e23] hover:bg-gray-50 rounded
                  ${fn:contains(uri, '/mypage/cart') ? 'font-bold bg-gray-50' : ''}">
          장바구니
        </a>

        <c:if test="${loginMember.memberId == storeOwnerId}">
          <a href="${cpath}/seller/${storeUrl}/main"
             class="block px-3 py-2 text-base text-[#2D4739] hover:text-[#1b2e23] hover:bg-gray-50 rounded">
            스토어 관리
          </a>
        </c:if>

        <a href="${cpath}/main"
           class="block px-3 py-2 text-base text-[#2D4739] hover:text-[#1b2e23] hover:bg-gray-50 rounded">
          메인 홈
        </a>
      </div>
    </div>
  </div>
</nav>

<!-- 모바일 하단 고정 네비게이션 (스토어 전용) -->
<nav
  class="md:hidden fixed left-1/2 bottom-0 z-50 w-full -translate-x-1/2 border-t bg-white font-jua"
  style="padding-bottom: env(safe-area-inset-bottom);"
  aria-label="스토어 모바일 하단 내비게이션"
>
  <div class="mx-auto w-full max-w-[1920px] px-4">
    <ul class="grid grid-cols-4 h-14">
      <!-- 스토어 홈 -->
      <li class="flex items-center justify-center">
        <a href="${cpath}/${storeUrl}"
           class="flex flex-col items-center justify-center gap-1 w-full h-full text-[#2D4739] opacity-90 hover:opacity-100">
          <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" aria-hidden="true">
            <path d="M3 10.5L12 3l9 7.5V20a1 1 0 0 1-1 1h-5v-6H9v6H4a1 1 0 0 1-1-1v-9.5Z" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
          <span class="text-[10px] leading-none">스토어 홈</span>
        </a>
      </li>

      <!-- 전체상품 -->
      <li class="flex items-center justify-center">
        <a href="${cpath}/${storeUrl}/products"
           class="flex flex-col items-center justify-center gap-1 w-full h-full text-[#2D4739] opacity-90 hover:opacity-100">
          <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" aria-hidden="true">
            <rect x="3" y="3" width="18" height="18" rx="2" ry="2" stroke="currentColor" stroke-width="1.6"/>
            <circle cx="9" cy="9" r="2" stroke="currentColor" stroke-width="1.6"/>
            <path d="M21 15l-3.086-3.086a2 2 0 0 0-2.828 0L6 21" stroke="currentColor" stroke-width="1.6"/>
          </svg>
          <span class="text-[10px] leading-none">전체상품</span>
        </a>
      </li>

      <!-- 장바구니 -->
      <li class="flex items-center justify-center">
        <a href="${cpath}/${storeUrl}/mypage/cart"
           class="flex flex-col items-center justify-center gap-1 w-full h-full text-[#2D4739] opacity-90 hover:opacity-100">
          <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" aria-hidden="true">
            <path d="M3 3h2l2 12h10l2-8H7" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
            <circle cx="9" cy="20" r="1.5" stroke="currentColor" stroke-width="1.6"/>
            <circle cx="17" cy="20" r="1.5" stroke="currentColor" stroke-width="1.6"/>
          </svg>
          <span class="text-[10px] leading-none">장바구니</span>
        </a>
      </li>

      <!-- 마이페이지 -->
      <li class="flex items-center justify-center">
        <a href="${cpath}/${storeUrl}/mypage"
           class="flex flex-col items-center justify-center gap-1 w-full h-full text-[#2D4739] opacity-90 hover:opacity-100">
          <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" aria-hidden="true">
            <circle cx="12" cy="8" r="3.25" stroke="currentColor" stroke-width="1.6"/>
            <path d="M5 19a7 7 0 0 1 14 0" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"/>
          </svg>
          <span class="text-[10px] leading-none">마이페이지</span>
        </a>
      </li>
    </ul>
  </div>
</nav>

<!-- 스크롤 및 메뉴 토글 스크립트 -->
<script>
// 스크롤 시 반투명/블러 토글
(function () {
  var nav = document.getElementById('store-nav');
  if (!nav) return;
  function onScroll() {
    nav.dataset.scrolled = (window.scrollY > 8) ? "true" : "false";
  }
  onScroll();
  window.addEventListener('scroll', onScroll, { passive: true });
})();

// 스토어 모바일 메뉴 토글 함수
window.toggleStoreMenu = function() {
  const menu = document.getElementById('store-mobile-menu');
  const menuIcon = document.getElementById('store-menu-icon');
  const closeIcon = document.getElementById('store-close-icon');

  if (menu && menuIcon && closeIcon) {
    if (menu.classList.contains('hidden')) {
      menu.classList.remove('hidden');
      menuIcon.style.display = 'none';
      closeIcon.style.display = 'block';
    } else {
      menu.classList.add('hidden');
      menuIcon.style.display = 'block';
      closeIcon.style.display = 'none';
    }
  }
}

window.closeStoreMenu = function() {
  const menu = document.getElementById('store-mobile-menu');
  const menuIcon = document.getElementById('store-menu-icon');
  const closeIcon = document.getElementById('store-close-icon');

  if (menu && menuIcon && closeIcon) {
    menu.classList.add('hidden');
    menuIcon.style.display = 'block';
    closeIcon.style.display = 'none';
  }
}

// 문서 로드 후 이벤트 리스너 추가
document.addEventListener('DOMContentLoaded', function() {
  // 화면 밖 클릭시 모바일 메뉴 닫기
  document.addEventListener('click', function(event) {
    const mobileMenu = document.getElementById('store-mobile-menu');
    const menuButton = document.getElementById('store-menu-button');

    if (mobileMenu && !mobileMenu.contains(event.target) &&
        !menuButton.contains(event.target) &&
        !mobileMenu.classList.contains('hidden')) {
      closeStoreMenu();
    }
  });

  // 화면 크기 변경시 모바일 메뉴 닫기
  window.addEventListener('resize', function() {
    if (window.innerWidth >= 1024) { // lg breakpoint
      closeStoreMenu();
    }
  });
});
</script>
