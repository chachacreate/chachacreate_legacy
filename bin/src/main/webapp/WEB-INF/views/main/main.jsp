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
  

</head>
<body>

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
            <h2 class="banner-title">개인 판매, <br> 지금 시작하세요!</h2>
            <p class="banner-desc">수수료 0원부터 시작하는 수공예 셀러</p>
            <a href="${cpath}/main/sell/sellregister"  class="banner-btn">판매하기</a>
          </div>
        </div>
        <img class="banner-background" src="${cpath}/resources/images/main/main_banner1.png" alt="광고1">
      </div>

      <div class="swiper-slide banner-slide">
        <div class="banner-overlay">
          <div class="banner-text">
            <p class="banner-tag">놓치지 마세요</p>
            <h2 class="banner-title">나만의 스토어를 <br> 오픈해보세요</h2>
            <p class="banner-desc2">3개 이상 판매 시 전용 스토어 개설 가능</p>
            <a href=""class="banner-btn">런칭하기</a>
          </div>
        </div>
        <img class="banner-background" src="${cpath}/resources/images/main/main_banner2.png" alt="광고2">
      </div>
    </div>
    <div class="swiper-pagination banner-pagination"></div>
  </div>

  <!-- 오른쪽: 작은 고정 광고 2개 -->
  <div class="banner-right">
  
<div class="small-banner orange">
 <div class="particles"></div>
  <div class="store-label">금주의 인기 스토어 ✨</div>
  <div class="banner-inner">
    <div class="text-area">
      <h4>소이캔들 공방 '해비문'</h4>
      <p class="discount">최대 20% 할인 중!</p>
      <a href="#" class="side-banner-btn">바로가기</a>
    </div>
    <div class="image-area">
      <img src="${cpath}/resources/images/main/main_small_banner1.png" alt="소광고1">
    </div>
  </div>
</div>

   <div class="small-banner white">
   
   <div class="banner-inner">
    <div class="text-area">
      <h4>핸드메이드 클래스 오픈 🧵</h4>
      <p class="discount">지금 신청 시 키트 무료!</p>
      <a href="#" class="side-banner-btn">클래스 신청하기</a>
    </div>
    <div class="image-area">
      <img src="${cpath}/resources/images/main/main_small_banner2.png" alt="클래스 배너">
    </div>
  </div>
  </div>
    
    
  </div>
</section>



    <!-- 2. 인기 스토어 -->
<%
  String[] storeImages = {
    "logo1.png", "logo2.png", "logo3.png", "logo4.png", "logo5.png",
    "logo6.png", "logo7.png", "logo8.png", "logo9.png", "logo10.png"
  };

  String[] storeNames = {
    "해비문", "리틀블룸", "도자기집", "가죽공방 루트", "니팅룸",
    "나무조각소", "글라스아트", "빈티지숍", "수제비누공방", "마크라메카페"
  };

  String[][] storeCategories = {
    {"소이캔들", "디퓨저", "무드등"},
    {"드라이플라워", "꽃다발", "가랜드"},
    {"도자기", "머그컵", "접시"},
    {"지갑", "키링", "핸드폰케이스"},
    {"뜨개질", "목도리", "수세미"},
    {"나무액자", "책상소품", "조각도구"},
    {"유리컵", "조명", "오브제"},
    {"레트로", "악세사리", "포스터"},
    {"천연비누", "입욕제", "스킨케어"},
    {"인테리어", "마크라메", "월행잉"}
  };

  String[] storeDescriptions = {
    "은은한 향기와 함께하는 힐링 소이캔들 공방",
    "감성 가득한 플라워 디자인 전문 스토어",
    "수작업으로 빚어낸 따뜻한 도자기 제품",
    "가죽을 직접 다듬는 공예 브랜드 루트",
    "손뜨개로 만든 포근한 일상 아이템",
    "정성을 담은 나무 소품을 만드는 공방",
    "유리의 투명함으로 공간을 채우는 작품",
    "추억을 담은 빈티지 감성 아이템 모음",
    "자연에서 온 재료로 만든 순한 비누",
    "감각적인 마크라메 인테리어 소품 전문"
  };
%>

<section>
  <div class="section-title">
  <span class="icon">⭐</span>
  <h2>인기 스토어</h2>
</div>
  <div class="swiper store-swiper">
    <div class="swiper-wrapper" id="store-swiper-wrapper">
      <% for(int i = 0; i < 10; i++) { %>
      <div class="swiper-slide">
        <div class="card">
          <img src="<%= request.getContextPath() %>/resources/images/logo/stores/<%= storeImages[i] %>" alt="<%= storeNames[i] %>">
          <h3><%= storeNames[i] %></h3>
          <div class="category-list">
            <% for(int j = 0; j < 3; j++) { %>
              <span class="category-tag"><%= storeCategories[i][j] %></span>
            <% } %>
          </div>
          <p class="store-desc"><%= storeDescriptions[i] %></p>
        </div>
      </div>
      <% } %>
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
    <div class="swiper-wrapper">
      <% for (int i = 1; i <= 10; i++) { %>
        <div class="swiper-slide">
          <div class="product-card">   
            <div class="product-image-box">
              <img src="<%= request.getContextPath() %>/resources/images/main/products/product<%=i%>.png" alt="인기상품<%=i%>">
              <div class="product-icon">
                <a href="#"><span class="material-symbols-outlined">arrow_outward</span></a>
              </div>
            </div>
            <div class="product-content">
              <h3>상품명 <%=i%></h3>
              <div class="category-badges">
                <span class="badge">천연</span>
                <span class="badge">핸드메이드</span>
              </div>
              <p>10,000원</p>
              
            </div>
          </div>
        </div>
      <% } %>
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
  <div class="preview-grid">
    <% for(int i=1; i<=8; i++) { %>
    <div class="preview-card">
      <img src="<%= request.getContextPath() %>/resources/productImages/newproduct<%=i%>.jpg" alt="신상품<%=i%>">
      <p class="product-name">신상품 <%=i%></p>
      <p class="product-price"><fmt:formatNumber value="<%= i * 5000 %>" type="currency" currencySymbol="₩" /></p>
    </div>
    <% } %>
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
