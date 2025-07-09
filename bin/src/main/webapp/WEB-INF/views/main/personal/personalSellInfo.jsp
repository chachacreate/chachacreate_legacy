<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%> 
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>개인 판매 등록 안내</title>
  <jsp:include page="/common/header.jsp" />
  <link rel="stylesheet" href="${cpath}/resources/css/main/personal/personalSellInfo.css">
	<!-- head 내부에 추가 -->
</head>
<body>
  <!-- ✅ Include Header & Nav -->
<jsp:include page="/common/main_nav.jsp" />

  <main class="sale-container">
   <jsp:include page="/common/main_personal_subnav.jsp" />

    <!-- 설명 영역 -->
    <section class="intro-section">
      <h2>🛒 개인 판매를 시작해보세요</h2>
      <p>간단한 절차만 거치면 누구나 자신의 상품을 판매할 수 있습니다!</p>
      <div class="intro-flexbox">
	    <ul>
	      <li>수수료 0원 (한시적)</li>
	      <li>한 번 등록하면, 별도 검수 없이 1일 이내 등록 가능</li>
	      <li>정산 및 배송 시스템은 플랫폼이 책임</li>
	    </ul>
	    
	    <!-- ✅ 추가 버튼 -->
	    <c:if test="${not empty sessionScope.loginMember}">
		  <div class="start-button-wrapper">
		    <a href="${cpath}/auth/join/seller" class="start-sell-btn">개인판매 시작하기</a>
		  </div>
	  	</c:if>
		  </div>
		  
		  
      <div class="tip-box">
        ※ 판매자는 상품의 내용과 배송 정보를 성실히 기재해야 하며, 허위 정보 등록 시 제재를 받을 수 있습니다.
      </div>
      
       
    </section>

    <!-- 단계별 안내 -->
    <section class="step-section">
      <div class="step">
        <h3>STEP 1</h3>
        <p>회원가입 및 로그인 후, 개인 판매 메뉴에서 스토어 개설을 클릭하세요.</p>
        <img src="resources/images/step1.jpg" alt="step1">
      </div>
      <div class="step">
        <h3>STEP 2</h3>
        <p>스토어 이름과 설명을 입력하여 등록하세요.</p>
        <img src="resources/images/step2.jpg" alt="step2">
      </div>
      <div class="step">
        <h3>STEP 3</h3>
        <p>상품을 등록하고 상세 정보를 기입합니다.</p>
        <img src="resources/images/step3.jpg" alt="step3">
      </div>
      <div class="step">
        <h3>STEP 4</h3>
        <p>결제 수단을 설정하고 판매를 시작하세요.</p>
        <img src="resources/images/step4.jpg" alt="step4">
      </div>
      <div class="step">
        <h3>STEP 5</h3>
        <p>상품이 판매되면 정산 및 배송 처리는 자동으로 관리됩니다.</p>
        <img src="resources/images/step5.jpg" alt="step5">
      </div>
    </section>
  </main>

  <!-- 푸터 -->
  <footer>
    <div class="footer-inner">
      <div class="footer-logo">뜨락상회</div>
      <p>마음을 모은 생활 복지 플랫폼</p>
      <div class="footer-inputs">
        <input type="text" placeholder="연락처">
        <input type="text" placeholder="연락처2">
      </div>
    </div>
  </footer>
  
  	<c:if test="${not empty sessionScope.fail}">
	  <script>
	    alert("${sessionScope.fail}");
	  </script>
	  <c:remove var="fail" scope="session" />
	</c:if>

</body>
</html>
