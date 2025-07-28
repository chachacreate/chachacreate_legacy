<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%> 
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>
    <link rel="stylesheet" type="text/css" href="${cpath}/resources/css/auth/signUp.css">
    <link rel="stylesheet" type="text/css" href="${cpath}/resources/css/auth/signUpVars.css">
</head>
<body>

<div class="div">
  <!-- 상단 헤더 -->
  <div class="frame-765">
    <div class="frame-767">
      <div class="frame-766">
        <img class="div10" src="${cpath}/resources/images/logo/logo_green.png" alt="로고"/>
        <div class="div11">회원가입하기</div>
      </div>
      <img class="_1" src="${cpath}/resources/images/signup/banner_img.png" alt="배너이미지"/>
    </div>
  </div>

  <!-- 메인 영역 -->
  <div class="frame-763">
    <!-- 진행단계 -->
    <div class="frame-768">
      <div class="_01">
        <span class="_01-span">01<br/></span><span class="_01-span2">약관동의</span>
      </div>
      <img class="icon-arrow-right" src="${cpath}/resources/images/signup/icon-arrow-right0.svg" />
      <div class="_02">02<br/>회원정보입력</div>
      <img class="icon-arrow-right2" src="${cpath}/resources/images/signup/icon-arrow-right1.svg" />
      <div class="_03">03<br/>완료</div>
    </div>

    <!-- 약관동의 form -->
    <form action="${pageContext.request.contextPath}/signupStep2" method="post">
      <div class="div2">
        <div class="frame-769">
          <div class="div3">이용약관 및 개인정보 처리방침</div>

          <!-- 전체동의 -->
          <div class="checkbox">
            <input type="checkbox" id="agreeAll" name="agreeAll">
            <label for="agreeAll">
              <div class="div4">모두 동의합니다.</div>
              <div class="_3">
                이용약관, 개인정보 수집 및 이용, 개인정보 제 3자 제공 동의에 모두 동의합니다.
              </div>
            </label>
          </div>

          <!-- 이용약관 동의 -->
          <div class="radio">
            <div class="div5">
              이용약관을 읽고 동의합니다. <span class="div-5-span2">(필수)</span>
            </div>
            <div class="radio2">
              <label><input type="radio" name="termsAgree" value="N" required> 동의안함</label>
              <label><input type="radio" name="termsAgree" value="Y" required> 동의함</label>
            </div>
          </div>

          <!-- 개인정보 수집 동의 -->
          <div class="radio">
            <div class="div5">
              개인정보 수집 및 이용에 동의합니다. <span class="div-5-span2">(필수)</span>
            </div>
            <div class="radio2">
              <label><input type="radio" name="privacyAgree" value="N" required> 동의안함</label>
              <label><input type="radio" name="privacyAgree" value="Y" required> 동의함</label>
            </div>
          </div>

          <!-- 제3자 제공 동의 -->
          <div class="radio">
            <div class="_32">
              개인정보 제 3자 제공 동의 <span class="_32-span2">(필수)</span>
            </div>
            <div class="radio2">
              <label><input type="radio" name="thirdPartyAgree" value="N" required> 동의안함</label>
              <label><input type="radio" name="thirdPartyAgree" value="Y" required> 동의함</label>
            </div>
          </div>

          <!-- 하단 버튼 -->
          <div class="frame-773">
            <button type="button" class="button" onclick="location.href='${pageContext.request.contextPath}/login'">취소</button>
            <button type="submit" class="button2">다음</button>
          </div>
        </div>
      </div>
    </form>

  </div>
</div>

</body>
</html>
