<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%> 
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
 <link rel="icon" href="data:;base64,=">
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>HandCraft Mall</title>
  
  <%@ include file="/common/header.jsp" %>
  
  <!-- Swiper CSS -->
  <link rel="stylesheet" href="https://unpkg.com/swiper@9/swiper-bundle.min.css" />
  
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

  <script src="${cpath}/resources/js/main/mainHome.js"></script>  
  
  <style>
  /* ✅ 공통: 가로세로 1:1(정사각)로 통일 + 가운데 크롭 */
.product-image-box {           /* bestProduct()의 래퍼 */
  aspect-ratio: 1 / 1;
  overflow: hidden;
  border-radius: 12px;
  background: #f8fafc;
}
.product-image-box > .product-img {
  width: 100%;
  height: 100%;
  display: block;
  object-fit: cover;           /* 꽉 채우고 넘치는 부분 크롭 */
  object-position: center;
}

/* ✅ mainProduct() 카드 이미지도 정사각 통일 */
.card .store-img {
  width: 100%;
  aspect-ratio: 1 / 1;         /* 높이 자동 계산 */
  display: block;
  object-fit: cover;
  object-position: center;
  border-radius: 12px;
  background: #f8fafc;
}

/* ================================
   Preview 카드 통일 스타일
   (JS/마크업 변경 없이 작동)
   ================================ */

/* 카드 박스: 동일한 패딩/테두리/라운드/그림자/호버 */
#preview-grid .preview-card {
  display: flex;
  flex-direction: column;
  gap: 8px;
  height: 100%;
  padding: 12px;
/*   border: 1px solid #e5e7eb;          /* gray-200 */ */
  border-radius: 12px;
  background: #ffffff;
/*   box-shadow: 0 1px 2px rgba(0,0,0,.04); */
  transition: transform .15s ease, box-shadow .15s ease, border-color .15s ease;
  cursor: pointer;
}
#preview-grid .preview-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 16px rgba(0,0,0,.08);
  border-color: #d1d5db;               /* gray-300 */
}

/* 이미지: 비율(정사각) 고정 + 가운데 크롭 + 동일 라운드 */
#preview-grid .preview-card .new-product-img {
  width: 100%;
  aspect-ratio: 1 / 1;                 /* 세로/가로 통일 */
  object-fit: cover;                    /* 꽉 채우고 넘친 부분 크롭 */
  object-position: center;
  border-radius: 10px;
  background: #f8fafc;                 /* 로딩 전 배경 */
  display: block;
}

/* 상품명: 두 줄 클램프(길어도 높이 일정) */
#preview-grid .preview-card .product-name {
  margin-top: 6px;
  font-size: 14px;
  line-height: 1.35;
  color: #111827;                       /* gray-900 */
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;                /* 2줄 */
  overflow: hidden;
  min-height: calc(1.35em * 2);         /* 줄수 고정으로 카드 높이 안정화 */
}

/* 가격: 굵게 + 간격 통일 */
#preview-grid .preview-card .product-price {
  margin-top: 2px;
  font-size: 15px;
  font-weight: 700;
  color: #111827;
}

/* Grid 아이템 높이 통일 (기본 stretch이나 안전하게 보강) */
#preview-grid { align-items: stretch; }
  
  </style>

</head>
<body class="bg-white font-jua">
  <input type="hidden" id="cpath" value="${cpath}">
  <jsp:include page="/common/main_nav.jsp" />
  
  <!-- MAIN CONTENT -->
  <main class="max-w-1440 mx-auto px-4 md:px-8 lg:px-12 xl:px-16">

    <!-- 1. 광고 배너 -->
    <section class="py-6 md:py-8 lg:py-12">
      <div class="grid grid-cols-1 lg:grid-cols-3 gap-4 md:gap-6">
        <!-- 왼쪽: 큰 광고 슬라이드 -->
        <div class="lg:col-span-2">
          <div class="swiper banner-swiper relative rounded-xl md:rounded-2xl overflow-hidden h-64 sm:h-72 md:h-80 lg:h-96">
            <div class="swiper-wrapper">
              <div class="swiper-slide banner-slide relative">
                <div class="absolute inset-0 bg-black bg-opacity-40 z-10"></div>
                <div class="absolute inset-0 z-20 flex items-center justify-start p-4 sm:p-6 md:p-8 lg:p-12">
                  <div class="text-white max-w-sm md:max-w-md">
                    <p class="text-xs sm:text-sm md:text-base font-medium mb-2 text-yellow-300">지금이 기회!</p>
                    <h2 class="text-xl sm:text-2xl md:text-3xl lg:text-4xl font-bold mb-3 md:mb-4 leading-tight">
                      개인 판매, <br> 지금 시작하세요!
                    </h2>
                    <p class="text-xs sm:text-sm md:text-base mb-4 md:mb-6 text-gray-200">수수료 0원부터 시작하는 수공예 셀러</p>
                    <a href="${cpath}/main/sell/sellguide" class="inline-block bg-blue-600 hover:bg-blue-700 text-white px-4 sm:px-5 md:px-6 py-2 sm:py-2.5 md:py-3 rounded-lg font-medium transition-colors duration-300 text-sm md:text-base">판매하기</a>
                  </div>
                </div>
                <img class="w-full h-full object-cover" src="${cpath}/resources/images/main/main_banner1.png" alt="광고1">
              </div>

              <div class="swiper-slide banner-slide relative">
                <div class="absolute inset-0 bg-black bg-opacity-40 z-10"></div>
                <div class="absolute inset-0 z-20 flex items-center justify-start p-4 sm:p-6 md:p-8 lg:p-12">
                  <div class="text-white max-w-sm md:max-w-md">
                    <p class="text-xs sm:text-sm md:text-base font-medium mb-2 text-yellow-300">놓치지 마세요</p>
                    <h2 class="text-xl sm:text-2xl md:text-3xl lg:text-4xl font-bold mb-3 md:mb-4 leading-tight">
                      나만의 스토어를 <br> 오픈해보세요
                    </h2>
                    <p class="text-xs sm:text-sm md:text-base mb-4 md:mb-6 text-gray-200">3개 이상 판매 시 전용 스토어 개설 가능</p>
                    <a href="${cpath}/main/store/description" class="inline-block bg-green-600 hover:bg-green-700 text-white px-4 sm:px-5 md:px-6 py-2 sm:py-2.5 md:py-3 rounded-lg font-medium transition-colors duration-300 text-sm md:text-base">런칭하기</a>
                  </div>
                </div>
                <img class="w-full h-full object-cover" src="${cpath}/resources/images/main/main_banner2.png" alt="광고2">
              </div>
            </div>
            <div class="swiper-pagination banner-pagination"></div>
          </div>
        </div>

        <!-- 오른쪽: 작은 고정 광고 2개 (모바일에서는 가로 배치) -->
        <div class="grid grid-cols-2 lg:grid-cols-1 gap-4 md:gap-6 lg:space-y-0">
          <div class="bg-gradient-to-br from-orange-400 to-orange-600 rounded-xl md:rounded-2xl p-4 md:p-6 h-32 sm:h-36 md:h-40 lg:h-44 relative overflow-hidden">
            <div class="absolute inset-0 opacity-10">
              <!-- 파티클 효과를 위한 div -->
              <div class="w-2 h-2 bg-white rounded-full absolute top-4 right-6 animate-pulse"></div>
              <div class="w-1 h-1 bg-white rounded-full absolute top-8 right-12 animate-pulse delay-100"></div>
              <div class="w-1.5 h-1.5 bg-white rounded-full absolute top-12 right-8 animate-pulse delay-200"></div>
            </div>
            <div class="relative z-10">
              <div class="text-white text-xs sm:text-sm font-medium">금주의 인기 스토어 ✨</div>
              <div id="topStore" class="text-white text-xs sm:text-sm"></div>
            </div>
          </div>

          <div class="bg-white border border-gray-200 rounded-xl md:rounded-2xl p-4 md:p-6 h-32 sm:h-36 md:h-40 lg:h-44 shadow-sm">
            <div class="flex flex-col lg:flex-row lg:items-center justify-between h-full">
              <div class="flex-1">
                <h4 class="text-sm sm:text-base lg:text-lg font-bold text-gray-800 mb-1 md:mb-2">핸드메이드 클래스 🧵</h4>
                <p class="text-xs sm:text-sm text-red-500 font-medium mb-2 md:mb-4">키트 무료!</p>
                <a href="/main/classes" class="inline-block bg-gray-800 hover:bg-gray-900 text-white px-3 md:px-4 py-1.5 md:py-2 rounded-lg text-xs md:text-sm font-medium transition-colors duration-300">신청하기</a>
              </div>
              <div class="hidden lg:block flex-shrink-0 ml-4">
                <img class="w-16 h-16 object-cover rounded-lg" src="${cpath}/resources/images/main/main_small_banner2.png" alt="클래스 배너">
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 2. 인기 스토어 -->
    <section class="py-6 md:py-8 lg:py-12">
      <div class="flex items-center mb-4 md:mb-6 lg:mb-8">
        <span class="text-xl md:text-2xl mr-2 md:mr-3">⭐</span>
        <h2 class="text-xl md:text-2xl lg:text-3xl font-bold text-gray-800">인기 스토어</h2>
      </div>
      <div class="swiper store-swiper relative">
        <div class="swiper-wrapper" id="store-swiper-wrapper">
          <!-- 동적으로 인기 스토어 정보가 들어갈 공간 -->
        </div>
        <div class="swiper-pagination store-pagination"></div>
        <div class="swiper-button-prev store-prev !hidden md:!flex"></div>
        <div class="swiper-button-next store-next !hidden md:!flex"></div>
      </div>
    </section>

    <!-- 3. 인기 상품 -->
    <section class="py-6 md:py-8 lg:py-12">
      <div class="flex items-center mb-4 md:mb-6 lg:mb-8">
        <span class="text-xl md:text-2xl mr-2 md:mr-3">⭐</span>
        <h2 class="text-xl md:text-2xl lg:text-3xl font-bold text-gray-800">인기 상품</h2>
      </div>
      <div class="swiper product-swiper relative">
        <div class="swiper-wrapper" id="swiper-wrapper">
          <!-- 인기 상품 정보가 들어갈 공간 -->
        </div>
        <div class="swiper-pagination product-pagination"></div>
        <div class="swiper-button-prev product-prev !hidden md:!flex"></div>
        <div class="swiper-button-next product-next !hidden md:!flex"></div>
      </div>
    </section>

    <!-- 4. 금주 신상품 -->
    <section class="py-6 md:py-8 lg:py-12">
      <div class="flex items-center justify-between mb-4 md:mb-6 lg:mb-8">
        <h2 class="text-xl md:text-2xl lg:text-3xl font-bold text-gray-800">금주 신상품</h2>
        <a href="${cpath}/main/products" class="text-blue-600 hover:text-blue-700 font-medium transition-colors duration-300 text-sm md:text-base">전체보기</a>
      </div>
      <div class="grid grid-cols-2 sm:grid-cols-5 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-3 md:gap-4 lg:gap-6" id="preview-grid">
        <!-- 신상품 정보가 들어갈 공간 -->
      </div>
    </section>

  </main>

  <!-- FOOTER -->
  <footer class="bg-gray-800 text-white text-center py-6 md:py-8 mt-12 md:mt-16">
    <p class="text-sm md:text-base">&copy; 2025 HandCraft Mall. All Rights Reserved.</p>
  </footer>

  <!-- JS -->
  <script src="https://unpkg.com/swiper@9/swiper-bundle.min.js"></script>
  <script src="${pageContext.request.contextPath}/resources/js/main_store.js"></script>
  
</body>
<script>
// 자동 로그인 토큰 설정
<c:if test="${autoLogin}">
    const accessToken = "${accessToken}";
    if (accessToken && accessToken !== "null") {
        localStorage.setItem('accessToken', accessToken);
        console.log('소셜 로그인 토큰 설정 완료');
    }
</c:if>
</script>
</html>