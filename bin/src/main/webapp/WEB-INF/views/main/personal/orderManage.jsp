<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%> 
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>개인판매 물품 주문관리</title>
<link rel="stylesheet" href="${cpath}/resources/css/main/personal/orderManage.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- Swiper CSS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
<!-- Swiper JS -->
<script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
</head>
<body>
<!-- ✅ Include Header & Nav -->
<jsp:include page="/common/header.jsp" />
<jsp:include page="/common/main_nav.jsp" />


<!-- --------sub menu ----- -->
<main class="order-container">
<jsp:include page="/common/main_personal_subnav.jsp" />
  
<!-- Swiper 슬라이더 -->
<!-- 버튼 -->
    <div class="swiper-button-next"></div>
    <div class="swiper-button-prev"></div>
    
<div class="swiper-container-wrapper">
  <div class="swiper mySwiper">
    <div class="swiper-wrapper">
    

<div class="swiper-slide">
  <div class="slide-content-vertical">
    
    <!-- ✅ 상품 정보 (상단) -->
    <div class="product-info-box">
      <h3>상품 정보</h3>
      <div class="product-detail">
        <img src="resources/images/product_sample.png" alt="상품 이미지" class="product-img">
        <div class="product-desc">
          <p>상품명: 혼합 수세미</p>
          <p>설명: 안녕, 나는 개인인척하는 혼합 수세미</p>
        </div>
      </div>
    </div>

    <!-- ✅ 주문 내역 + 주문자 정보 (하단 나란히) -->
    <div class="order-bottom-wrapper">
      <!-- 주문 내역 -->
      <div class="order-section">
        <h3>주문 내역</h3>
        <table class="order-table">
          <thead>
            <tr>
              <th>주문일</th>
              <th>주문자명</th>
              <th>수량</th>
              <th>가격</th>
              <th>주문 상세</th>
            </tr>
          </thead>
          <tbody>
		  <tr>
		    <td>2025-06-12</td>
		    <td class="order-name">차민진</td>
		    <td>2</td>
		    <td>4,000</td>
		    <td><button class="confirm-btn">확인</button></td>
		  </tr>
		  <tr>
		    <td>2025-06-12</td>
		    <td class="order-name">이재혁</td>
		    <td>1</td>
		    <td>4,000</td>
		    <td><button class="confirm-btn">확인</button></td>
		  </tr>
		</tbody>
        </table>
      </div>

      <!-- 주문자 정보 -->
      <div class="order-detail-box">
        <h3>주문자 정보</h3>
        <table>
          <thead>
            <tr>
              <th>주문자명</th>
              <th>수량</th>
              <th>발송확인</th>
            </tr>
          </thead>
          <tbody id="detail-content">
            <!-- 확인 버튼 클릭 시 내용 삽입 -->
          </tbody>
        </table>
      </div>
    </div>

  </div> <!-- .slide-content-vertical -->
</div>





      <div class="swiper-slide">
        <div class="slide-content">
          <h3>개인판매 물품 B</h3>
          <p>설명: 이곳에 다른 상품 설명 작성</p>
        </div>
      </div>
    </div>
    
    
  </div>
</div>
</main>


<script>
const swiper = new Swiper('.mySwiper', {
    slidesPerView: 1,
    spaceBetween: 30,
    loop: true,
    navigation: {
      nextEl: '.swiper-button-next',
      prevEl: '.swiper-button-prev',
    },
  });

  document.addEventListener("DOMContentLoaded", function () {
    const detailBox = document.getElementById("detail-content");

    document.querySelectorAll(".confirm-btn").forEach(button => {
      button.addEventListener("click", function () {
        // 중복 방지
        if (this.classList.contains("confirmed")) return;

        this.classList.add("confirmed");
        this.classList.add("confirmed-green");
        this.textContent = "확인됨";

        const row = this.closest("tr");
        const orderer = row.querySelector(".order-name")?.textContent || '';
        const quantity = row.children[2]?.textContent || '';

        if (!orderer || !quantity) return;

        const newRow = document.createElement("tr");
        newRow.innerHTML = `
          <td>${orderer}</td>
          <td>${quantity}</td>
          <td><button class="ship-btn">발송</button></td>
        `;
        detailBox.appendChild(newRow);

	      // 발송 버튼 이벤트 추가
	      const shipButton = newRow.querySelector(".ship-btn");
	      shipButton.addEventListener("click", function () {
	        this.style.backgroundColor = '#444';
	        this.style.color = 'white';
	        this.textContent = '발송완료';
	      });
	    });
	  });
	});

</script>
</body>
</html>