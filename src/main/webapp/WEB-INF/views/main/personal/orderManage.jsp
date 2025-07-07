<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />

<%
  String[] status = {"신규", "발송전", "완료", "환불", "신규", "취소", "완료", "신규", "발송전", "완료"};
  String[] orderer = {"김지민", "이재혁", "차민진", "천희찬", "이재희", "안세현", "최용정", "차민건", "지민수", "천재민"};
  String[] address = {
    "서울 송파구 올림픽로 99", "경기 고양시 덕양구", "서울 서대문구", "부산 해운대구", "서울 성동구",
    "경기 안양시 동안구", "서울 강남구", "대전 유성구", "인천 미추홀구", "광주 북구"
  };
  String[] product = {"수세미", "천연수세미", "왕수세미", "수세미팩", "향기수세미", "세척수세미", "미니수세미", "고급수세미", "세트수세미", "특가수세미"};
  String[] orderDate = {"2025-06-10", "2025-06-11", "2025-06-12", "2025-06-13", "2025-06-14", "2025-06-15", "2025-06-16", "2025-06-17", "2025-06-18", "2025-06-19"};
  int[] quantity = {1, 2, 3, 1, 1, 4, 2, 1, 3, 1};
  int[] price = {10000, 20000, 30000, 40000, 10000, 50000, 20000, 10000, 30000, 15000};
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>개인판매 물품 주문관리</title>
  <link rel="stylesheet" href="${cpath}/resources/css/main/personal/orderManage.css">
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
  <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
</head>
<body>

<!-- ✅ Include Header & Nav -->
<jsp:include page="/common/header.jsp" />
<jsp:include page="/common/main_nav.jsp" />

<main class="order-container">
<jsp:include page="/common/main_personal_subnav.jsp" />

<div class="swiper-button-next"></div>
<div class="swiper-button-prev"></div>

<div class="swiper-container-wrapper">
  <div class="swiper mySwiper">
    <div class="swiper-wrapper">

      <!-- ✅ 슬라이드 1 -->
      <div class="swiper-slide">
        <div class="slide-content-vertical">

          <!-- 상품 정보 -->
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

          <div class="order-bottom-wrapper">

<!-- ✅ 주문 필터 버튼 -->
<div class="order-filter-bar">
  <button class="order-filter-btn active" data-status="신규">
  신규 주문 <span class="count" data-type="신규">3</span>건
</button>
<button class="order-filter-btn" data-status="환불">
  환불 요청 <span class="count" data-type="환불">1</span>건
</button>
<button class="order-filter-btn" data-status="취소">
  취소 요청 <span class="count" data-type="취소">1</span>건
</button>
</div>

<!-- ✅ 필터링되는 테이블 -->
<div class="order-section">
  <h3 id="filter-title">신규 주문</h3>
  <table class="order-table">
    <thead>
      <tr>
        <th>처리상태</th><th>주문일</th><th>주문번호</th><th>주문자명</th>
        <th>배송지</th><th>상품 수량</th><th>금액</th><th>관리</th>
      </tr>
    </thead>
    <tbody id="filter-order-body">
      <% for (int i = 0; i < 10; i++) { %>
        <tr data-status="<%= status[i] %>" data-index="<%= i %>">
          <td class="status-label <%= status[i] %>"><%= status[i] %></td>
          <td><%= orderDate[i] %></td>
          <td><%= String.format("%08d", i + 1) %></td>
          <td><%= orderer[i] %></td>
          <td class="ellipsis">
            <%= address[i].length() > 25 ? address[i].substring(0, 25) + "..." : address[i] %>
            <% if(address[i].length() > 25) { %>
              <button class="address-toggle-btn" data-index="f<%= i %>">\u25BC</button>
            <% } %>
          </td>
      
          <td><%= quantity[i] %></td>
          <td><%= String.format("%,d", price[i]) %></td>
          <td>
            <% if ("신규".equals(status[i])) { %>
              <button class="confirm-btn">확인</button>
            <% } else if ("환불".equals(status[i])) { %>
              <button class="refund-btn">환불하기</button>
            <% } else if ("취소".equals(status[i])) { %>
              <button class="cancel-btn">취소하기</button>
            <% } %>
          </td>
        </tr>
        <tr class="detail-row address-detail-f<%= i %>" style="display:none;" data-status="<%= status[i] %>">
          <td colspan="9" class="detail-content">
            <strong>전체 배송지:</strong> <%= address[i] %><br>
            <strong>상품 상세:</strong> <%= product[i] %> - 수량 <%= quantity[i] %>개, 가격 <%= String.format("%,d", price[i]) %>원
          </td>
        </tr>
      <% } %>
    </tbody>
  </table>
</div>

<!-- ✅ 주문 내역 테이블 -->
<div class="order-section">
  <h3>주문 내역</h3>
  <table class="order-table">
    <thead>
      <tr>
        <th>처리상태</th><th>주문일</th><th>주문번호</th><th>주문자명</th>
        <th>배송지</th><th>상품 수량</th><th>금액</th><th>관리</th>
      </tr>
    </thead>
    <tbody id="order-history-body">
      <!-- JavaScript로 동적으로 이동 및 상태 업데이트 -->
    </tbody>
  </table>
</div>

          </div> <!-- order-bottom-wrapper -->

        </div>
      </div>

      <!-- ✅ 슬라이드 2 -->
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
document.addEventListener("DOMContentLoaded", function () {
   
     // ✅ 초기 필터링: 신규 주문만 보여줌
     const initialStatus = "신규";
     document.getElementById("filter-title").textContent = initialStatus + " 주문";
     document.querySelectorAll(".order-filter-btn").forEach(btn => {
       if (btn.getAttribute("data-status") === initialStatus) {
         btn.classList.add("active");
       } else {
         btn.classList.remove("active");
       }
     });
     document.querySelectorAll("#filter-order-body tr").forEach(row => {
       if (row.dataset.status === initialStatus || (row.classList.contains("detail-row") && row.previousElementSibling.dataset.status === initialStatus)) {
         row.style.display = "";
       } else {
         row.style.display = "none";
       }
     });
     // 필터 버튼 클릭
     document.querySelectorAll(".order-filter-btn").forEach(btn => {
       btn.addEventListener("click", function () {
         const selectedStatus = this.getAttribute("data-status");
         document.getElementById("filter-title").textContent = selectedStatus + " 주문";
         document.querySelectorAll(".order-filter-btn").forEach(b => b.classList.remove("active"));
         this.classList.add("active");

         document.querySelectorAll("#filter-order-body tr").forEach(row => {
           if (row.dataset.status === selectedStatus || row.classList.contains("detail-row") && row.previousElementSibling.dataset.status === selectedStatus) {
             row.style.display = "";
           } else {
             row.style.display = "none";
           }
         });
       });
     });

     function updateOrderCount() {
    	  const counts = { 신규: 0, 환불: 0, 취소: 0 };
    	  document.querySelectorAll('#filter-order-body tr').forEach(row => {
    	    if (!row.classList.contains('detail-row') && counts.hasOwnProperty(row.dataset.status)) {
    	      counts[row.dataset.status]++;
    	    }
    	  });

    	  document.querySelectorAll('.count').forEach(span => {
    	    const type = span.dataset.type;
    	    span.textContent = counts[type] || 0;
    	  });
    	}
     
     // 상태별 버튼 클릭 이벤트 처리
     document.querySelector("#filter-order-body").addEventListener("click", function (e) {
       const btn = e.target;
       if (btn.classList.contains("confirm-btn") || btn.classList.contains("refund-btn") || btn.classList.contains("cancel-btn")) {
         const row = btn.closest("tr");
         const clone = row.cloneNode(true);
         const statusCell = clone.querySelector(".status-label");
         const btnCell = clone.querySelector("td:last-child");
         const status = row.dataset.status;

         // 상태에 따라 변경
         if (btn.classList.contains("confirm-btn")) {
           statusCell.textContent = "발송전";
           statusCell.className = "status-label 발송전";
           btnCell.innerHTML = '<button class="ship-btn">발송하기</button>';
         } else if (btn.classList.contains("refund-btn")) {
           statusCell.textContent = "환불";
           statusCell.className = "status-label 환불";
           btnCell.innerHTML = ''; // 처리 완료
         } else if (btn.classList.contains("cancel-btn")) {
           statusCell.textContent = "취소";
           statusCell.className = "status-label 취소";
           btnCell.innerHTML = ''; // 처리 완료
         }

         // 주문 내역에 추가
         document.querySelector("#order-history-body").appendChild(clone);

         // 해당 행 제거 (상세 행도 같이)
         const detailRow = row.nextElementSibling;
         row.remove();
         if (detailRow.classList.contains("detail-row")) detailRow.remove();
         updateOrderCount();
       }
     });

     // 발송하기 클릭 시 완료 처리
     document.querySelector("#order-history-body").addEventListener("click", function (e) {
       if (e.target.classList.contains("ship-btn")) {
         const row = e.target.closest("tr");
         const statusCell = row.querySelector(".status-label");
         statusCell.textContent = "완료";
         statusCell.className = "status-label 완료";
         e.target.remove();
       }
     });
   });
   
/* --------------스와이프 JS------------- */
const swiper = new Swiper('.mySwiper', {
  slidesPerView: 1,
  spaceBetween: 30,
  loop: true,
  navigation: {
    nextEl: '.swiper-button-next',
    prevEl: '.swiper-button-prev',
  },
});

$(document).ready(function () {
  $('.address-toggle-btn').on('click', function () {
    const index = $(this).data('index');
    $('.address-detail-' + index).slideToggle();
  });
});
</script>
</body>
</html>
