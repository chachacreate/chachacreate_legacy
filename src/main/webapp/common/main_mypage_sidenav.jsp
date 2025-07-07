<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- ✅ contextPath, URI 설정 --%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />
<c:set var="uri" value="${pageContext.request.requestURI}" />

<%-- ✅ JSP 내부에서 안전하게 storeUrl 추출 --%>
<%
    String storeUrl = "main"; // 기본값
    String[] uriParts = request.getRequestURI().split("/");
    if (uriParts.length >= 3 && !"WEB-INF".equals(uriParts[2])) {
        storeUrl = uriParts[2];
    }
    pageContext.setAttribute("storeUrl", storeUrl);
%>

<%-- ✅ basePath 구성 --%>
<c:set var="basePath" value="${cpath}/${storeUrl}/mypage" />

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
