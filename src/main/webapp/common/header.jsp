<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%> 
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />

<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
	<script src="${cpath}/resources/js/boot.js"></script>
	

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
	      	<script>
		      	sessionStorage.removeItem("chatCreated");
		      </script>
	      	<a href="${cpath}/main/mypage/message" class="header-btn">메시지</a>
	      </c:if>
	      <c:if test="${not empty storeUrl}">
		      <c:if test="${loginMember.memberId == storeOwnerId}">
		      <script>
		      	sessionStorage.removeItem("chatCreated");
		      </script>
		      	<a href="${cpath}/${storeUrl}/mypage/message" class="header-btn">메시지</a>
		      </c:if>
		      <c:if test="${loginMember.memberId != storeOwnerId}">
	      			<a href="${cpath}/${storeUrl}/mypage/message?makeChat=true" class="header-btn">${storeName}에 메시지 보내기</a>
	      	  </c:if>
	      </c:if>
	      <a href="javascript:void(0);" class="header-btn" id="btn-logout">로그아웃</a>
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

<script>
$('#btn-logout').on('click', function() {
	const BOOT_API = '${springBootApiUrl}';
	console.log("로그아웃 버튼 클릭");
    // 1) Spring Boot 로그아웃 호출 (accessToken 자동 포함)
    $.ajax({
        url: BOOT_API + '/auth/logout',
        type: 'POST',
        data: { email:"${sessionScope.loginMember.memberEmail}" },
        xhrFields: { withCredentials: true },
        success: function(resp){
            console.log("Spring Boot 로그아웃 완료:", resp);
            clearAccessToken(); // 토큰 제거
        },
        error: function(xhr, status, error){
            console.warn("Spring Boot 로그아웃 실패:", error);
        },
        complete: function(){
            // 2) 기존 JSP/Legacy 로그아웃 이동
            alert('로그아웃 되었습니다.');
            window.location.href = '${cpath}/auth/logout';
        }
    });
});
</script>


