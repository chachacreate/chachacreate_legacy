<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>장바구니</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  
  <!-- 기존 CSS (데스크톱용) -->
  <link rel="stylesheet" href="${cpath}/resources/css/store/buyer/mypage/cart.css" />
  
  <!-- Tailwind CSS 추가 (모바일 스타일링용) -->
  <script>
  tailwind.config = {
    theme: {
      extend: {
        fontFamily: { 'jua': ['Jua','ui-sans-serif','system-ui','sans-serif'] }
      }
    }
  }
  </script>
  <script src="https://cdn.tailwindcss.com"></script>
  
  <!-- 기존 JS -->
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="${cpath}/resources/js/store/buyer/mypage/cart.js" defer></script>
  
  <style>
    /* 모바일 전용 스타일 */
    @media (max-width: 1023px) {
      .wrapper { display: none !important; }
    }
    
    /* 데스크톱 전용 스타일 */
    @media (min-width: 1024px) {
      .mobile-only { display: none !important; }
    }
    
    .line-clamp-2 {
      display: -webkit-box;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
      overflow: hidden;
    }
  </style>
</head>
<body>

<!-- 모바일 전용 뷰 -->
<div class="mobile-only bg-gray-50 font-sans">
  <!-- 상단 헤더 -->
  <div class="sticky top-0 z-50 bg-white border-b border-gray-200">
    <div class="px-4 py-3 flex items-center gap-3">
      <button type="button" 
              class="w-10 h-10 rounded-full bg-white border border-gray-200 shadow-sm hover:bg-gray-50 flex items-center justify-center"
              onclick="(history.length>1)?history.back():location.href='${cpath}/main/mypage'">
        <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none">
          <path d="M15 19l-7-7 7-7" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
      </button>
      <h1 class="text-lg font-bold text-gray-900">장바구니</h1>
      <div class="flex-1"></div>
    </div>
  </div>

  <!-- 모바일 콘텐츠 -->
  <div class="min-h-screen bg-gray-50">
    <div class="px-4 py-4">
      <!-- 전체 선택 및 삭제 버튼 -->
      <div class="flex items-center justify-between mb-4 bg-white rounded-lg p-3 shadow-sm">
        <div class="flex items-center gap-2">
          <input type="checkbox" id="mobile-select-all" class="select-all" />
          <label for="mobile-select-all" class="text-sm font-medium">전체 선택</label>
        </div>
        <div class="flex gap-2">
          <button class="delete-button text-sm px-3 py-1 bg-red-500 text-white rounded hover:bg-red-600">삭제</button>
          <button class="delete-all-button text-sm px-3 py-1 bg-gray-500 text-white rounded hover:bg-gray-600">비우기</button>
        </div>
      </div>

      <!-- 현재 스토어 -->
      <div class="mb-6">
        <h2 class="text-lg font-bold text-gray-900 mb-3">현재 스토어 장바구니</h2>
        <div class="bg-gray-200 h-px mb-4"></div>
        <div id="mobile-current-store-cart">
          <!-- JS에서 현재 스토어 장바구니 아이템 렌더링 -->
        </div>
      </div>

      <!-- 전체 스토어 -->
      <div class="mb-6">
        <h2 class="text-lg font-bold text-gray-900 mb-3">전체 스토어 장바구니</h2>
        <div class="bg-gray-200 h-px mb-4"></div>
        <div id="mobile-all-store-cart">
          <!-- JS에서 전체 스토어 장바구니 아이템 렌더링 -->
        </div>
      </div>
    </div>

    <!-- 모바일 하단 고정 주문 요약 -->
    <div class="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 p-4 shadow-lg">
      <div id="mobile-order-summary">
        <!-- JS에서 동적으로 요약 렌더링 -->
        <div class="flex items-center justify-between mb-3">
          <span class="text-sm text-gray-600">선택 상품 (0)</span>
          <button class="text-sm text-blue-600 font-medium">상세보기</button>
        </div>
        <div class="flex items-center justify-between mb-4">
          <span class="text-lg font-bold text-gray-900">총 금액</span>
          <span class="text-xl font-bold text-blue-600">0원</span>
        </div>
        <button class="checkout-btn w-full bg-blue-600 text-white font-bold py-3 rounded-xl hover:bg-blue-700 transition-colors">
          결제하기
        </button>
      </div>
    </div>

    <!-- 하단 고정 버튼 공간 확보 -->
    <div class="pb-32"></div>
  </div>
</div>

<!-- 데스크톱 전용 뷰 (마이페이지 스타일 적용) -->
<div class="wrapper hidden lg:block font-jua">
  <script>
    window.loggedInMemberId = ${loginMember != null ? loginMember.memberId : 'null'};
  </script>
  
  <div class="min-h-screen flex flex-col" style="background: linear-gradient(135deg,#f8fafc 0%,#f1f5f9 100%);">
    <!-- Include Header & Nav -->
    <jsp:include page="/common/header.jsp" />
    
    <!-- storeUrl 기반 동적 네비게이션 -->
    <c:choose>
      <c:when test="${empty storeUrl}">
        <jsp:include page="/common/main_nav.jsp" />
      </c:when>
      <c:otherwise>
        <jsp:include page="/common/storeMain_nav.jsp" />
      </c:otherwise>
    </c:choose>
    
    <!-- 메인 -->
    <main class="w-full max-w-[1920px] mx-auto px-4 md:px-6 xl:px-20 2xl:px-[240px] py-6 flex-1">
      <!-- 레이아웃: 데스크톱 2열(사이드바+콘텐츠) -->
      <div class="grid grid-cols-[240px_minmax(0,1fr)] gap-6">
        <!-- 왼쪽 사이드바 -->
        <jsp:include page="/common/main_mypage_sidenav.jsp" />
        
        <!-- 오른쪽 콘텐츠 -->
        <section class="bg-white rounded-2xl shadow-lg border border-gray-100 overflow-hidden">
          <!-- 헤더 -->
          <div class="bg-gradient-to-r from-brand-900 to-gray-800 px-6 md:px-8 py-5 md:py-6">
            <h2 class="text-xl md:text-2xl text-white mb-1.5 md:mb-2">장바구니</h2>
            <p class="text-gray-200 text-xs md:text-sm">선택한 상품들을 확인하고 주문하세요</p>
          </div>

          <!-- 콘텐츠 -->
          <div class="p-6 md:p-8" data-cpath="${cpath}">
            <!-- 전체 선택 및 삭제 컨트롤 -->
            <div class="flex items-center justify-between mb-6 bg-gray-50 rounded-xl p-4 border border-gray-100">
              <div class="flex items-center gap-3">
                <input type="checkbox" id="select-all" class="select-all w-4 h-4 text-brand-900 bg-gray-100 border-gray-300 rounded focus:ring-brand-900"/>
                <label for="select-all" class="text-sm font-medium text-gray-700">전체 선택</label>
              </div>
              <div class="flex gap-2">
                <button class="delete-button px-4 py-2 text-sm bg-red-500 text-white rounded-lg hover:bg-red-600 focus:outline-none focus:ring-2 focus:ring-red-500 transition font-medium">삭제</button>
                <button class="delete-all-button px-4 py-2 text-sm bg-gray-500 text-white rounded-lg hover:bg-gray-600 focus:outline-none focus:ring-2 focus:ring-gray-500 transition font-medium">비우기</button>
              </div>
            </div>

            <!-- 현재 스토어 장바구니 -->
            <section class="mb-8">
              <div class="flex items-center mb-4">
                <svg class="w-5 h-5 mr-2 text-brand-900" fill="currentColor" viewBox="0 0 20 20">
                  <path d="M3 4a1 1 0 011-1h12a1 1 0 011 1v2a1 1 0 01-1 1H4a1 1 0 01-1-1V4zM3 10a1 1 0 011-1h6a1 1 0 011 1v6a1 1 0 01-1 1H4a1 1 0 01-1-1v-6zM14 9a1 1 0 00-1 1v6a1 1 0 001 1h2a1 1 0 001-1v-6a1 1 0 00-1-1h-2z"/>
                </svg>
                <h3 class="text-lg font-semibold text-gray-800">현재 스토어 장바구니</h3>
              </div>
              <div class="bg-gray-50 rounded-xl p-5 border border-gray-100">
                <div id="current-store-cart">
                  <!-- JS에서 현재 스토어 장바구니 아이템 렌더링 -->
                </div>
              </div>
            </section>

            <!-- 전체 스토어 장바구니 -->
            <section class="mb-8">
              <div class="flex items-center mb-4">
                <svg class="w-5 h-5 mr-2 text-green-600" fill="currentColor" viewBox="0 0 20 20">
                  <path d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
                <h3 class="text-lg font-semibold text-gray-800">전체 스토어 장바구니</h3>
              </div>
              <div class="bg-green-50 rounded-xl p-5 border border-green-100">
                <div id="all-store-cart">
                  <!-- JS에서 전체 스토어 장바구니 아이템 렌더링 -->
                </div>
              </div>
            </section>

            <!-- 주문 요약 -->
            <section class="bg-blue-50 rounded-xl p-5 md:p-6 border border-blue-100">
              <h3 class="text-lg font-semibold text-gray-800 mb-4 flex items-center">
                <svg class="w-5 h-5 mr-2 text-blue-600" fill="currentColor" viewBox="0 0 20 20">
                  <path fill-rule="evenodd" d="M4 4a2 2 0 00-2 2v4a2 2 0 002 2V6h10a2 2 0 00-2-2H4zm2 6a2 2 0 012-2h8a2 2 0 012 2v4a2 2 0 01-2 2H8a2 2 0 01-2-2v-4zm6 4a2 2 0 100-4 2 2 0 000 4z" clip-rule="evenodd"/>
                </svg>
                주문 예상 금액
              </h3>
              
              <div id="order-summary">
                <!-- JS에서 동적으로 요약 렌더링 -->
                <div class="space-y-3 mb-4">
                  <div class="flex justify-between text-sm text-gray-600">
                    <span>선택 상품</span>
                    <span>0개</span>
                  </div>
                  <div class="flex justify-between text-sm">
                    <span>상품 총액</span>
                    <span>0원</span>
                  </div>
                  <div class="flex justify-between text-sm">
                    <span>배송비</span>
                    <span>0원</span>
                  </div>
                </div>

                <div class="border-t border-blue-200 pt-4 mb-6">
                  <div class="flex justify-between items-center">
                    <span class="text-lg font-bold text-gray-900">총 금액</span>
                    <span class="text-xl font-bold text-brand-900">0원</span>
                  </div>
                </div>

                <button class="checkout-btn w-full bg-brand-900 text-white font-bold py-3 rounded-xl hover:bg-brand-800 focus:outline-none focus:ring-2 focus:ring-brand-900 transition shadow-lg">
                  결제하기
                </button>
              </div>
            </section>
          </div>
        </section>
      </div>
    </main>
    
    <!-- 푸터 -->
    <footer class="bg-white border-t border-gray-200 py-8 mt-16">
      <div class="max-w-1200 mx-auto px-6 text-center">
        <p class="text-gray-600">&copy; 2025 HandCraft Mall. All Rights Reserved.</p>
      </div>
    </footer>
  </div>
</div>

<script>
// 모바일/데스크톱 공통 함수들을 위한 추가 스크립트
document.addEventListener('DOMContentLoaded', function() {
  // 모바일 전체 선택 체크박스 동기화
  const mobileSelectAll = document.getElementById('mobile-select-all');
  const desktopSelectAll = document.getElementById('select-all');
  
  if (mobileSelectAll && desktopSelectAll) {
    mobileSelectAll.addEventListener('change', function() {
      desktopSelectAll.checked = this.checked;
      // 기존 cart.js의 전체 선택 로직 호출
      if (window.handleSelectAll) {
        window.handleSelectAll();
      }
    });
  }
  
  // 모바일용 아이템 렌더링 함수 (기존 cart.js와 연동)
  function syncMobileCart() {
    const currentStoreCart = document.getElementById('current-store-cart');
    const allStoreCart = document.getElementById('all-store-cart');
    const mobileCurrentStoreCart = document.getElementById('mobile-current-store-cart');
    const mobileAllStoreCart = document.getElementById('mobile-all-store-cart');
    
    if (currentStoreCart && mobileCurrentStoreCart) {
      // 데스크톱 -> 모바일 동기화 로직
      // 실제 구현은 cart.js의 기존 함수들을 활용
    }
  }
  
  // 기존 cart.js가 로드된 후 모바일 동기화 실행
  if (window.jQuery) {
    $(document).ready(function() {
      // 기존 cart.js 로직과 연동
      syncMobileCart();
    });
  }
});
</script>

</body>
</html>