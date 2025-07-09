<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%> 
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>장바구니</title>
  <link rel="stylesheet" href="${cpath}/resources/css/main/mypage/mainMyPageOrderList.css">
</head>
<body>
  <div class="wrapper">
     <!-- ✅ Include Header & Nav -->
<jsp:include page="/common/header.jsp" />
<jsp:include page="/common/main_nav.jsp" />

    <!-- 메인 콘텐츠 영역 -->
    <main class="main-area">
      <!-- 왼쪽 사이드바 -->
     <jsp:include page="/common/main_mypage_sidenav.jsp" />

	<section class="order-page">
  <!-- 배송중인 주문내역 -->
  <h2>배송중인 주문내역</h2>
  <table class="order-table">
    <thead>
      <tr>
        <th>주문일</th>
        <th>상품사진</th>
        <th>상품명</th>
        <th>수량</th>
        <th>가격</th>
        <th>주문 상세</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>2025-06-12</td>
        <td><img src="resources/images/pumpkin.jpg" alt="호박 수세미" class="order-img"></td>
        <td>호박 수세미</td>
        <td>2</td>
        <td>4,000</td>
        <td><button class="btn-detail" onclick="location.href='orderDetail.jsp'">주문상세</button></td>
      </tr>
      <!-- 반복 가능 -->
    </tbody>
  </table>

  <!-- 마이 주문내역 -->
  <h2>마이 주문 내역</h2>
  <table class="order-table">
    <thead>
      <tr>
        <th>주문일</th>
        <th>상품사진</th>
        <th>상품명</th>
        <th>수량</th>
        <th>가격</th>
        <th>주문 상세</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>2025-06-12</td>
        <td><img src="resources/images/pumpkin.jpg" alt="호박 수세미" class="order-img"></td>
        <td>호박 수세미</td>
        <td>2</td>
        <td>4,000</td>
        <td>배송중</td>
      </tr>
      <tr>
        <td>2025-06-12</td>
        <td><img src="resources/images/pumpkin.jpg" alt="호박 수세미" class="order-img"></td>
        <td>호박 수세미</td>
        <td>2</td>
        <td>4,000</td>
        <td>배송완료</td>
      </tr>
    </tbody>
  </table>
</section>
	
      
    </main>

    <!-- 푸터 -->
    <footer class="site-footer">
      <div class="footer-inner">
        <p>© 2025 뜨락상회. All rights reserved.</p>
      </div>
    </footer>

  </div>

  <!-- 스크립트 -->
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  
  
</body>
</html>
