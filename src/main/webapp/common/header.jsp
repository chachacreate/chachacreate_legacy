<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%> 
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />

<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<div class="header-wrapper">
  <div class="header-inner">
    <!-- 로그인 전 -->
	<c:if test="${empty sessionScope.loginMember}">
	    <div class="header-content" id="header-guest">
		  <a href="${cpath}/auth/login" class="header-btn">로그인</a>
		  <span class="divider">|</span>
		  <a href="${cpath}/auth/join/agree" class="header-btn">회원가입</a>
		</div>
	</c:if>

    <!-- 로그인 후 -->
    <c:if test="${not empty sessionScope.loginMember}">
	    <div class="header-content" id="header-user">
	      <span class="welcome-text"><span id="member-name">${sessionScope.loginMember.memberName}</span>님 반갑습니다!</span>
	      <c:if test="${empty storeUrl}">
	      	<a href="${cpath}/main/mypage/message" class="header-btn">메시지</a>
	      </c:if>
	      <c:if test="${not empty storeUrl}">
	      	<a href="${cpath}/${storeUrl}/mypage/message" class="header-btn">메시지</a>
	      </c:if>
	      <a href="${cpath}/auth/logout" class="header-btn" onclick="alert('로그아웃');">로그아웃</a>
	    </div>
    </c:if>
  </div>
</div>

<style>

html, body {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }
.header-wrapper {
  width: 100%;
  height: 50px;
  background: #2D4739;
  display: flex;
  justify-content: center;
  align-items: center;
}

.header-inner {
  width: 1920px;
  padding: 0 240px;
  display: flex;
  justify-content: flex-end;
  align-items: center;
}

.header-content {
  display: flex;
  align-items: center;
  gap: 20px;
}

.header-btn, .welcome-text, .divider {
  color: #ffffff;
  font-size: 16px;
  text-decoration: none;
  cursor: pointer;
  font-family: 'Jua', sans-serif;
}
</style>
