<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />
<c:set var="uri" value="${pageContext.request.requestURI}" />

<%-- ✅ basePath 동적 설정 --%>
<c:set var="storeUrl" value="${fn:split(pageContext.request.requestURI, '/')[2]}" />

<c:choose>
  <c:when test="${storeUrl ne 'main'}">
    <c:set var="basePath" value='${cpath}/${storeUrl}/mypage' />
  </c:when>
  <c:otherwise>
    <c:set var="basePath" value='${cpath}/main/mypage' />
  </c:otherwise>
</c:choose>

<aside class="sidebar">
  <ul>
    <li>
      <a href="${basePath}"
         class="${fn:contains(uri, '/mypage') and not fn:contains(uri, '/mypage/') ? 'active' : ''}">
         마이정보수정</a>
    </li>
    <li>
      <a href="${basePath}/cart"
         class="${fn:contains(uri, '/mypage/cart') ? 'active' : ''}">
         장바구니</a>
    </li>
    <li>
      <a href="${basePath}/orders"
         class="${fn:contains(uri, '/mypage/orders') ? 'active' : ''}">
         주문내역</a>
    </li>
    <li>
      <a href="${basePath}/message"
         class="${fn:contains(uri, '/mypage/message') ? 'active' : ''}">
         문의 메시지</a>
    </li>
    <li>
      <a href="${basePath}/myreview"
         class="${fn:contains(uri, '/mypage/myreview') ? 'active' : ''}">
         작성 리뷰 확인</a>
    </li>
  </ul>
</aside>
