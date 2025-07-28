<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%> 
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />
<c:set var="uri" value="${pageContext.request.requestURI}" />

<!-- ✅ Google Fonts 적용 -->
<link href="https://fonts.googleapis.com/css2?family=Jua&display=swap" rel="stylesheet" />

<div class="personal-nav">
  <a href="${cpath}/main/store/stores"
     class="${fn:contains(uri, '/main/personalsell') && fn:length(uri) == fn:length(cpath) + 17 ? 'active' : ''}">
     스토어 목록
  </a>
  <a href="${cpath}/main/store/description"
     class="${fn:contains(uri, '/personalsell/register') ? 'active' : ''}">
     스토어 개설 설명
  </a>
</div>

<style>
.container-1440 {
  max-width: 1440px;
  margin: 0 auto;
  padding: 0 20px;
}

.personal-nav {
  font-family: 'Jua', sans-serif;
  display: flex;
  gap: 30px;
  padding: 20px 0 10px;
  border-bottom: 1px solid #ccc;
  background-color: #fff;
}

.personal-nav a {
  text-decoration: none;
  color: #333;
  font-size: 16px;
  position: relative;
  padding-bottom: 5px;
  transition: all 0.2s;
}

.personal-nav a:hover {
  color: #2D4739;
}

.personal-nav a:hover::after {
  content: "";
  position: absolute;
  bottom: 0;
  left: 0;
  width: 100%;
  height: 2px;
  background-color: #2D4739;
}

.personal-nav a.active {
  font-weight: bold;
  color: #2D4739;
}

.personal-nav a.active::after {
  content: "";
  position: absolute;
  bottom: 0;
  left: 0;
  height: 2px;
  width: 100%;
  background-color: #2D4739;
}
</style>
