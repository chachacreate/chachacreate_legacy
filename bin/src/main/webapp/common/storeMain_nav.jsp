<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%> 
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />
<c:set var="uri" value="${pageContext.request.requestURI}" />


<script src="${cpath}/resources/js/store/storeMain_nav.js"></script>
<!-- ✅ Google Fonts: Jua 불러오기 -->
<link href="https://fonts.googleapis.com/css2?family=Jua&display=swap" rel="stylesheet" />

<nav>
	<div class="nav-inner container-1440">
		<div class="logo-wrapper">
			<div class="logo">
				<!-- ✅ 로고 클릭 시 메인으로 이동 -->
				<a href="${cpath}/${storeUrl}" id="logoArear"> <!-- 동적으로 스토어 로고 삽입 -->
				</a>
			</div>
			<div id="nameArear">
				<!-- 동적으로 스토어명 삽입 -->
			</div>
		</div>
		<div class="menu">
			<a href="${cpath}/${storeUrl}/products" class="nav-item">전체상품</a> 
			<a href="${cpath}/${storeUrl}/info" class="nav-item">스토어 정보</a> 
			<a href="#" class="nav-item">클래스</a> 
			<a href="${cpath}/${storeUrl}/mypage" class="nav-item">마이페이지</a> 
			<a href="${cpath}/main/mypage/cart" class="nav-item">장바구니</a>
			<a href="${cpath}/${storeUrl}/notices"
				class="nav-item ${fn:contains(uri, '/main/notice') ? 'active' : ''}">
				공지/소식 </a> <a href="${cpath}/main" class="nav-item">메인 홈 가기</a> 
		</div>
	</div>
</nav>

<style>

nav {
  font-family: 'Jua', sans-serif;
  background-color: #ffffff;
  border-bottom: 1px solid #ccc;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.08);
  position: sticky;
  top: 0;
  z-index: 999;
}

.nav-inner {
  display: flex;
  justify-content: space-between;
  align-items: center;
  height: 80px;
  padding: 0 240px;
}

.menu .nav-item {
  margin: 0 10px;
  text-decoration: none;
  color: #2D4739;
  font-size: 18px;
  padding: 10px 8px;
  position: relative;
  transition: all 0.3s ease;
  font-family: 'Jua', sans-serif;
}

.logo-wrapper {
  display: flex;
  align-items: center;
  gap: 30px; 
}

#logoArear img {
  height: 100%;
  max-height: 60px;
  object-fit: contain;
  display: block;
}

#storename {
  font-size: 24px;            
  font-weight: 700;              
  color: #1b2e23;                 
  font-family: 'Jua', sans-serif; 
  letter-spacing: 0.5px;        
  display: inline-block;
  vertical-align: middle;
  text-decoration: none;
}

#storename:hover::after{
  width: 100%;
}

.menu .nav-item:hover {
  color: #1b2e23;
}

.menu .nav-item.active {
  font-weight: bold;
  color: #2D4739;
}

.menu .nav-item.active::after {
  content: "";
  position: absolute;
  bottom: 5px;
  left: 0;
  width: 100%;
  height: 2px;
  background-color: #2D4739;
  border-radius: 1px;
}

.menu .nav-item::after {
  content: "";
  position: absolute;
  bottom: 5px;
  left: 0;
  width: 0%;
  height: 2px;
  background-color: #2D4739;
  border-radius: 1px;
  transition: width 0.3s ease;
}

.menu .nav-item:hover::after {
  width: 100%; /* 마우스 오버 시 밑줄 나타남 */
}

.menu .nav-item.active::after {
  width: 100%; /* 활성화된 메뉴 밑줄 유지 */
}

</style>


