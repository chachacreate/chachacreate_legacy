<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />
<c:set var="uri" value="${pageContext.request.requestURI}" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>장바구니</title>
  <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">

<%--   <!-- 기존 CSS (프로젝트 전용 스타일) -->
  <link rel="stylesheet" href="${cpath}/resources/css/store/buyer/mypage/cart.css" /> --%>

  <!-- Tailwind CDN 사용시: config를 CDN보다 먼저 선언해야 커스텀 토큰이 적용됩니다 -->
  <script>
    try {
      window.tailwind = window.tailwind || {};
      tailwind.config = {
        theme: {
          extend: {
            fontFamily: { 'jua': ['Jua','ui-sans-serif','system-ui','sans-serif'] },
            colors: { 'brand-900':'#2D4739','brand-800':'#1b2e23','brand-100':'#E6F1E5' }
          }
        }
      };
    } catch (e) {}
  </script>
  <script src="https://cdn.tailwindcss.com"></script>

  <!-- Google Fonts - Jua -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Jua&display=swap" rel="stylesheet">

  <!-- 유틸 보강: line-clamp 대체 -->
  <style>
    .line-clamp-2{
      display:-webkit-box; -webkit-line-clamp:2; -webkit-box-orient:vertical; overflow:hidden;
    }
  </style>
</head>

<body class="bg-gray-50 font-jua">
  <!-- =========================
       📱 모바일 전용 단독 페이지 뷰
       - 마이페이지 그리드에서 장바구니 클릭 시 독립 페이지
       - 헤더/사이드 없이 상단 뒤로가기 + 제목만
       ========================= -->
  <div class="lg:hidden">
    <!-- 상단: 뒤로가기 + 제목 바 -->
    <div class="sticky top-0 z-50 bg-white border-b border-gray-200">
      <div class="px-4 py-3 flex items-center gap-3">
        <button type="button"
                class="inline-flex items-center justify-center w-10 h-10 rounded-full bg-white border border-gray-200 shadow-sm hover:bg-gray-50 active:scale-95 transition-all"
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
        <!-- 현재 스토어 -->
        <div class="mb-6">
          <h2 class="text-lg font-bold text-gray-900 mb-3">현재 스토어 장바구니</h2>
          <div class="bg-gray-200 h-px mb-4"></div>

          <div class="cart-item bg-white rounded-xl border border-gray-200 p-4 shadow-sm">
            <div class="flex gap-3">
              <input type="checkbox" class="item-checkbox mt-1" />
              <img class="item-image w-20 h-20 rounded-lg object-cover bg-gray-100"
                   src="${cpath}/resources/img/home.jpg" alt="상품 이미지" />
              <div class="item-details flex-1 min-w-0">
                <div class="store-name text-sm text-gray-600 mb-1">000 스토어</div>
                <div class="product-name font-semibold text-gray-900 mb-1 truncate">상품명 1</div>
                <div class="product-description text-sm text-gray-600 line-clamp-2 mb-2">상품설명 블라블라 예시어쩌구...</div>
                <div class="product-price font-bold text-brand-900 mb-3">10,000원</div>
                <div class="quantity-controls flex items-center gap-3">
                  <button class="btn-decrease w-8 h-8 rounded-full border border-gray-300 flex items-center justify-center bg-white hover:bg-gray-50 active:scale-95">-</button>
                  <span class="quantity font-medium min-w-[2rem] text-center">1</span>
                  <button class="btn-increase w-8 h-8 rounded-full border border-gray-300 flex items-center justify-center bg-white hover:bg-gray-50 active:scale-95">+</button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 전체 스토어 -->
        <div class="mb-6">
          <h2 class="text-lg font-bold text-gray-900 mb-3">전체 스토어 장바구니</h2>
          <div class="bg-gray-200 h-px mb-4"></div>

          <div class="space-y-4">
            <div class="cart-item bg-white rounded-xl border border-gray-200 p-4 shadow-sm">
              <div class="flex gap-3">
                <input type="checkbox" class="item-checkbox mt-1" />
                <img class="item-image w-20 h-20 rounded-lg object-cover bg-gray-100"
                     src="${cpath}/resources/img/home.jpg" alt="상품 이미지" />
                <div class="item-details flex-1 min-w-0">
                  <div class="store-name text-sm text-gray-600 mb-1">000 스토어</div>
                  <div class="product-name font-semibold text-gray-900 mb-1 truncate">상품명 2</div>
                  <div class="product-description text-sm text-gray-600 line-clamp-2 mb-2">상품설명 블라블라 예시어쩌구...</div>
                  <div class="product-price font-bold text-brand-900 mb-3">20,000원</div>
                  <div class="quantity-controls flex items-center gap-3">
                    <button class="btn-decrease w-8 h-8 rounded-full border border-gray-300 flex items-center justify-center bg-white hover:bg-gray-50 active:scale-95">-</button>
                    <span class="quantity font-medium min-w-[2rem] text-center">2</span>
                    <button class="btn-increase w-8 h-8 rounded-full border border-gray-300 flex items-center justify-center bg-white hover:bg-gray-50 active:scale-95">+</button>
                  </div>
                </div>
              </div>
            </div>

            <div class="cart-item bg-white rounded-xl border border-gray-200 p-4 shadow-sm">
              <div class="flex gap-3">
                <input type="checkbox" class="item-checkbox mt-1" />
                <img class="item-image w-20 h-20 rounded-lg object-cover bg-gray-100"
                     src="${cpath}/resources/img/home.jpg" alt="상품 이미지" />
                <div class="item-details flex-1 min-w-0">
                  <div class="store-name text-sm text-gray-600 mb-1">000 스토어</div>
                  <div class="product-name font-semibold text-gray-900 mb-1 truncate">상품명 3</div>
                  <div class="product-description text-sm text-gray-600 line-clamp-2 mb-2">상품설명 블라블라 예시어쩌구...</div>
                  <div class="product-price font-bold text-brand-900 mb-3">9,000원</div>
                  <div class="quantity-controls flex items-center gap-3">
                    <button class="btn-decrease w-8 h-8 rounded-full border border-gray-300 flex items-center justify-center bg-white hover:bg-gray-50 active:scale-95">-</button>
                    <span class="quantity font-medium min-w-[2rem] text-center">2</span>
                    <button class="btn-increase w-8 h-8 rounded-full border border-gray-300 flex items-center justify-center bg-white hover:bg-gray-50 active:scale-95">+</button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- 모바일 하단 고정 주문 요약 -->
      <div class="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 p-4 shadow-lg">
        <div class="flex items-center justify-between mb-3">
          <span class="text-sm text-gray-600">선택 상품 (2)</span>
          <button class="text-sm text-brand-900 font-medium">상세보기</button>
        </div>
        <div class="flex items-center justify-between mb-4">
          <span class="text-lg font-bold text-gray-900">총 금액</span>
          <span class="text-xl font-bold text-brand-900">41,500원</span>
        </div>
        <button class="checkout-btn w-full bg-brand-900 text-white font-bold py-3 rounded-xl hover:bg-brand-800 active:scale-95 transition-all"
                onclick="location.href='<c:url value="/main/order"/>'">
          결제하기
        </button>
      </div>

      <!-- 하단 고정 버튼 공간 확보 -->
      <div class="pb-32"></div>
    </div>
  </div>

  <!-- =========================
       🖥️ 데스크톱 전용 레이아웃
       - 헤더/네비/사이드바 포함된 기존 구조 유지
       ========================= -->
  <div class="hidden lg:block">
    <!-- 데스크톱 헤더 & 네비게이션 -->
    <jsp:include page="/common/header.jsp" />
    <jsp:include page="/common/main_nav.jsp" />

    <!-- 메인 콘텐츠 영역 -->
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
          <div class="p-6 md:p-8">
            <div class="cart-page">
              <div class="cart-layout">
                <!-- 장바구니 목록 영역 -->
                <section class="cart-section">
                  <!-- 현재 스토어 -->
                  <div class="cart-block">
                    <div class="block-header">
                      <h3 class="text-lg font-semibold text-gray-800 mb-4">현재 스토어 장바구니</h3>
                      <div class="bg-gray-200 h-px mb-6"></div>
                    </div>

                    <div class="cart-item bg-gray-50 rounded-xl border border-gray-100 p-6 mb-4">
                      <div class="flex gap-4">
                        <input type="checkbox" class="item-checkbox mt-1" />
                        <img class="item-image w-24 h-24 rounded-lg object-cover bg-gray-100"
                             src="${cpath}/resources/img/home.jpg" alt="상품 이미지" />
                        <div class="item-details flex-1">
                          <div class="store-name text-sm text-gray-600 mb-1">000 스토어</div>
                          <div class="product-name text-lg font-semibold text-gray-900 mb-2">상품명 1</div>
                          <div class="product-description text-gray-600 mb-3">상품설명 블라블라 예시어쩌구...</div>
                          <div class="product-price text-xl font-bold text-brand-900 mb-4">10,000원</div>
                          <div class="quantity-controls flex items-center gap-3">
                            <button class="btn-decrease w-10 h-10 rounded-lg border border-gray-300 flex items-center justify-center bg-white hover:bg-gray-50">-</button>
                            <span class="quantity font-medium text-lg min-w-[3rem] text-center">1</span>
                            <button class="btn-increase w-10 h-10 rounded-lg border border-gray-300 flex items-center justify-center bg-white hover:bg-gray-50">+</button>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>

                  <!-- 전체 스토어 -->
                  <div class="cart-block">
                    <div class="block-header">
                      <h3 class="text-lg font-semibold text-gray-800 mb-4">전체 스토어 장바구니</h3>
                      <div class="bg-gray-200 h-px mb-6"></div>
                    </div>

                    <div class="space-y-4">
                      <div class="cart-item bg-gray-50 rounded-xl border border-gray-100 p-6">
                        <div class="flex gap-4">
                          <input type="checkbox" class="item-checkbox mt-1" />
                          <img class="item-image w-24 h-24 rounded-lg object-cover bg-gray-100"
                               src="${cpath}/resources/img/home.jpg" alt="상품 이미지" />
                          <div class="item-details flex-1">
                            <div class="store-name text-sm text-gray-600 mb-1">000 스토어</div>
                            <div class="product-name text-lg font-semibold text-gray-900 mb-2">상품명 2</div>
                            <div class="product-description text-gray-600 mb-3">상품설명 블라블라 예시어쩌구...</div>
                            <div class="product-price text-xl font-bold text-brand-900 mb-4">20,000원</div>
                            <div class="quantity-controls flex items-center gap-3">
                              <button class="btn-decrease w-10 h-10 rounded-lg border border-gray-300 flex items-center justify-center bg-white hover:bg-gray-50">-</button>
                              <span class="quantity font-medium text-lg min-w-[3rem] text-center">2</span>
                              <button class="btn-increase w-10 h-10 rounded-lg border border-gray-300 flex items-center justify-center bg-white hover:bg-gray-50">+</button>
                            </div>
                          </div>
                        </div>
                      </div>

                      <div class="cart-item bg-gray-50 rounded-xl border border-gray-100 p-6">
                        <div class="flex gap-4">
                          <input type="checkbox" class="item-checkbox mt-1" />
                          <img class="item-image w-24 h-24 rounded-lg object-cover bg-gray-100"
                               src="${cpath}/resources/img/home.jpg" alt="상품 이미지" />
                          <div class="item-details flex-1">
                            <div class="store-name text-sm text-gray-600 mb-1">000 스토어</div>
                            <div class="product-name text-lg font-semibold text-gray-900 mb-2">상품명 3</div>
                            <div class="product-description text-gray-600 mb-3">상품설명 블라블라 예시어쩌구...</div>
                            <div class="product-price text-xl font-bold text-brand-900 mb-4">9,000원</div>
                            <div class="quantity-controls flex items-center gap-3">
                              <button class="btn-decrease w-10 h-10 rounded-lg border border-gray-300 flex items-center justify-center bg-white hover:bg-gray-50">-</button>
                              <span class="quantity font-medium text-lg min-w-[3rem] text-center">2</span>
                              <button class="btn-increase w-10 h-10 rounded-lg border border-gray-300 flex items-center justify-center bg-white hover:bg-gray-50">+</button>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </section>

                <!-- 데스크톱 주문 요약 -->
                <aside class="bg-blue-50 rounded-xl border border-blue-100 p-6 mt-8">
                  <h3 class="text-lg font-bold text-gray-900 mb-4">주문 예상 금액</h3>
                  <div class="text-sm text-gray-600 mb-4">선택 상품 (2)</div>

                  <div class="space-y-3 mb-4">
                    <div class="flex justify-between text-sm">
                      <span>상품 1</span>
                      <span>10,000원</span>
                    </div>
                    <div class="flex justify-between text-sm">
                      <span>상품 2 (x2)</span>
                      <span>40,000원</span>
                    </div>
                    <div class="flex justify-between text-sm">
                      <span>상품 3 (x2)</span>
                      <span>18,000원</span>
                    </div>
                    <div class="flex justify-between text-sm">
                      <span>배송비</span>
                      <span>2,500원</span>
                    </div>
                  </div>

                  <div class="border-t border-gray-200 pt-4 mb-6">
                    <div class="flex justify-between items-center">
                      <span class="text-lg font-bold text-gray-900">총 금액</span>
                      <span class="text-xl font-bold text-brand-900">70,500원</span>
                    </div>
                  </div>

                  <button class="checkout-btn w-full bg-brand-900 text-white font-bold py-3 rounded-xl hover:bg-brand-800 transition-colors"
                          onclick="location.href='<c:url value="/main/order"/>'">
                    결제하기
                  </button>
                </aside>
              </div>
            </div>
          </div>
        </section>
      </div>
    </main>

    <!-- Footer -->
    <footer class="bg-white border-t border-gray-200 py-8 mt-16">
      <div class="max-w-1200 mx-auto px-6 text-center">
        <p class="text-gray-600">&copy; 2025 HandCraft Mall. All Rights Reserved.</p>
      </div>
    </footer>
  </div>
</body>
</html>