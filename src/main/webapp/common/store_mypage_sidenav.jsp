<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%>

<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />
<c:set var="uri" value="${pageContext.request.requestURI}" />

<aside class="sidebar">
  <ul>
    <li>
      <a href="${cpath}/${storeUrl}/mypage"
         class="${fn:contains(uri, '/main/mypage') and not fn:contains(uri, '/main/mypage/') ? 'active' : ''}">
         마이정보수정</a>
    </li>
    <li>
      <a href="${cpath}/${storeUrl}/mypage/cart"
         class="${fn:contains(uri, '/mypage/cart') ? 'active' : ''}">
         장바구니</a>
    </li>
    <li>
      <a href="${cpath}/${storeUrl}/mypage/orders"
         class="${fn:contains(uri, '/mypage/orders') ? 'active' : ''}">
         주문내역</a>
    </li>
    <li>
      <a href="${cpath}/${storeUrl}/mypage/message"
         class="${fn:contains(uri, '/mypage/message') ? 'active' : ''}">
         현재 스토어에 문의 메시지 보내기</a>
    </li>
    <li>
      <a href="${cpath}/${storeUrl}/mypage/myreview"
         class="${fn:contains(uri, '/mypage/myreview') ? 'active' : ''}">
         작성 리뷰 확인</a>
    </li>
  </ul>
</aside>


<style>
.sidebar {
  width: 240px;
  background-color: #E6F1E5;
  padding-top: 20px;
  border-radius: 12px;
  box-shadow: 2px 2px 8px rgba(0, 64, 0, 0.05);
}

.sidebar ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.sidebar ul li a {
  display: block;
  padding: 15px 20px;
  text-decoration: none;
  color: #2D4739;
  font-weight: 600;
  font-size: 15px;
  border-radius: 4px;
  transition: background-color 0.2s, color 0.2s;
}

.sidebar ul li a:hover {
  background-color: #cde4d2;
  color: #1b2e23;
}

.sidebar ul li a.active {
  background-color: #B0CBB0;
  color: #fff;
}

.sidebar ul li a.active::after {
  content: '\25B6'; /* ▶ */
  float: right;
  margin-left: 10px;
}

</style>
