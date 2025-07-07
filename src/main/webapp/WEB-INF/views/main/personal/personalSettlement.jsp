<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%> 
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>개인 판매 정산 관리</title>
  <link rel="stylesheet" href="${cpath}/resources/css/main/personal/personalSettlement.css">
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
  <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
</head>
<body>
<!-- ✅ Include Header & Nav -->
<jsp:include page="/common/header.jsp" />
<jsp:include page="/common/main_nav.jsp" />

<main class="settlement-container">
<jsp:include page="/common/main_personal_subnav.jsp" />



  <div class="swiper-container-wrapper">
    <div class="swiper mySwiper">
      <div class="swiper-wrapper">

        <!-- 🔹 Slide 1 -->
        <div class="swiper-slide">
          <main class="settlement-container">
              <!-- 상품정보, 정산정보 등은 그대로 유지 -->
            <section class="product-info">
              <h3>상품 정보</h3>
              <div class="product-detail">
                <img src="resources/images/product_sample.png" alt="상품 이미지" class="product-img">
                <div class="product-desc">
                  <p>상품명: 혼합 수세미</p>
                  <p>설명: 안녕, 나는 개인인척하는 혼합 수세미</p>
                </div>
              </div>
            </section>

            <section class="settlement-summary">
              <h3>정산관리 <span class="sub-title">| 금일 일별 매출그래프</span></h3>
              <div class="summary-grid">
                <div class="chart-box">
                  <img src="resources/images/sample_graph.png" alt="그래프 예시" style="width:100%; height:auto;">
                </div>
                <div class="info-box info-flex">
                  <div class="info-buttons">
                    <button class="info-tab active" data-value="5555555555">총수익</button>
                    <button class="info-tab" data-value="3333333333">배송완료상품 총수익</button>
                    <button class="info-tab" data-value="1111111111">순수익</button>
                  </div>
                  <div class="total-amount" id="amount-display">5555555555 원</div>
                </div>
              </div>
              <button id="edit-btn" class="edit-btn">정산 정보 등록 / 수정</button>

              <div id="edit-form" class="edit-form" style="display:none;">
                <h4>정산 정보 입력</h4>
                <form>
                  <label>매입일자: <input type="date" name="date"></label>
                  <label>정산금액: <input type="text" name="amount"></label>
                  <label>계좌번호: <input type="text" name="account"></label>
                  <label>은행명: <input type="text" name="bank"></label>
                  <label>예금주명: <input type="text" name="owner"></label>
                  <button type="submit">저장</button>
                </form>
              </div>
            </section>

            <section class="settlement-table">
              <table>
                <thead>
                  <tr>
                    <th>매입 일자</th>
                    <th>정산 금액</th>
                    <th>계좌번호</th>
                    <th>은행명</th>
                    <th>예금주명</th>
                    <th>정산상태</th>
                    <th>삭제</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>2025-05-01</td>
                    <td>360,000</td>
                    <td>110-111-11111</td>
                    <td>신한은행</td>
                    <td>차민진</td>
                    <td>정산완료</td>
                    <td><button class="delete-btn">삭제</button></td>
                  </tr>
                </tbody>
              </table>
            </section>
          </main>
        </div>

        <!-- 🔹 Slide 2 (복사해서 수정한 콘텐츠) -->
        <div class="swiper-slide">
          <main class="settlement-container">
            <section class="product-info">
              <h3>상품 정보</h3>
              <div class="product-detail">
                <img src="resources/images/product_sample2.png" alt="상품 이미지" class="product-img">
                <div class="product-desc">
                  <p>상품명: 대왕 수세미</p>
                  <p>설명: 나는 두 번째 상품 대왕 수세미야</p>
                </div>
              </div>
            </section>

            <section class="settlement-summary">
              <h3>정산관리 <span class="sub-title">| 금일 일별 매출그래프</span></h3>
              <div class="summary-grid">
                <div class="chart-box">
                  <img src="resources/images/sample_graph2.png" alt="그래프 예시" style="width:100%; height:auto;">
                </div>
                <div class="info-box info-flex">
                  <div class="info-buttons">
                    <button class="info-tab active" data-value="8888888888">총수익</button>
                    <button class="info-tab" data-value="4444444444">배송완료상품 총수익</button>
                    <button class="info-tab" data-value="2222222222">순수익</button>
                  </div>
                  <div class="total-amount" id="amount-display">8888888888 원</div>
                </div>
              </div>
              <button class="edit-btn">정산 정보 등록 / 수정</button>

              <div class="edit-form" style="display:none;">
                <h4>정산 정보 입력</h4>
                <form>
                  <label>매입일자: <input type="date" name="date"></label>
                  <label>정산금액: <input type="text" name="amount"></label>
                  <label>계좌번호: <input type="text" name="account"></label>
                  <label>은행명: <input type="text" name="bank"></label>
                  <label>예금주명: <input type="text" name="owner"></label>
                  <button type="submit">저장</button>
                </form>
              </div>
            </section>

            <section class="settlement-table">
              <table>
                <thead>
                  <tr>
                    <th>매입 일자</th>
                    <th>정산 금액</th>
                    <th>계좌번호</th>
                    <th>은행명</th>
                    <th>예금주명</th>
                    <th>정산상태</th>
                    <th>삭제</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>2025-06-01</td>
                    <td>420,000</td>
                    <td>333-333-33333</td>
                    <td>우리은행</td>
                    <td>이재혁</td>
                    <td>정산완료</td>
                    <td><button class="delete-btn">삭제</button></td>
                  </tr>
                </tbody>
              </table>
            </section>
          </main>
        </div>

      </div>

      <div class="swiper-button-next"></div>
      <div class="swiper-button-prev"></div>
    </div>
  </div>
  </main>

  <script>
  document.addEventListener("DOMContentLoaded", function () {
    const swiper = new Swiper('.mySwiper', {
      slidesPerView: 1,
      spaceBetween: 30,
      loop: true,
      navigation: {
        nextEl: '.swiper-button-next',
        prevEl: '.swiper-button-prev',
      },
    });

    // 슬라이드마다 독립 동작
    $('.swiper-slide').each(function () {
      const slide = $(this);

      slide.find('.edit-btn').on('click', function () {
        slide.find('.edit-form').slideToggle();
      });

      slide.find('.info-tab').on('click', function () {
        slide.find('.info-tab').removeClass('active');
        $(this).addClass('active');
        const amount = $(this).data('value');
        slide.find('.total-amount').text(amount + ' 원');
      });
    });
  });
</script>
</body>
</html>
