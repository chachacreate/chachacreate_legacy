<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>회원가입_약관동의</title>
  <link rel="stylesheet" type="text/css" href="${cpath}/resources/css/auth/join/joinAgree.css">
  <%-- <link rel="stylesheet" type="text/css" href="${cpath}/resources/css/agree_vars.css"> --%>
   <script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>
<body>
  <div class="container">

    <!-- 상단 배너 -->
    <div class="header-banner">
      <div class="header-content">
        <div class="logo-title-wrapper">
          <img class="logo" src="${cpath}/resources/images/logo.png" />
          <div class="page-title">회원가입하기</div>
        </div>
        <img class="header-illustration" src="${cpath}/resources/images/illustration.png" />
      </div>
    </div>

    <!-- 메인 컨텐츠 -->
    <div class="main-wrapper">
      <!-- 가입 단계 -->
      <div class="step-indicator">
  <div class="step current">
    <div class="step-circle">01</div>
    <div class="step-label">약관동의</div>
  </div>
  <img class="arrow" src="${cpath}/resources/images/arrow-right.svg" />
  <div class="step">
    <div class="step-circle">02</div>
    <div class="step-label">회원정보입력</div>
  </div>
  <img class="arrow" src="${cpath}/resources/images/arrow-right.svg" />
  <div class="step">
    <div class="step-circle">03</div>
    <div class="step-label">완료</div>
  </div>
  <img class="arrow" src="${cpath}/resources/images/arrow-right.svg" />
  <div class="step">
    <div class="step-circle">04</div>
    <div class="step-label">판매자정보입력</div>
  </div>
</div>

      <div class="terms-section">
        <div class="section-title">이용약관 및 개인정보 처리방침</div>

        <!-- 전체 동의 -->
        <div class="all-agree">
          <div class="checkbox-wrapper">
            <input type="checkbox" id="agreeAll" class="checkbox-item" />
          </div>
          <div class="checkbox-text">
            <div class="checkbox-title">모두 동의합니다.</div>
            <div class="checkbox-description">
              이용약관, 개인정보 수집 및 이용, 개인정보 제 3자 제공 동의에 모두 동의합니다.<br />
              각 사항에 대한 동의 여부를 개별적으로 선택하실 수 있으며, 선택 동의 사항에 대한 동의를 하여야 서비스를 이용하실 수 있습니다.
            </div>
          </div>
        </div>

        <!-- 이용약관 동의 -->
        <!-- ✅ 통합 카드 구조 -->
<div class="terms-card">
  <div class="terms-header">
    <div class="terms-label">이용약관을 읽고 동의합니다. <span class="label-required">(필수)</span></div>
    <div class="radio-group">
      <label class="radio-button">
        <input type="radio" name="terms1" value="no" hidden />
        <div class="radio-circle"></div>
        <div class="radio-text">동의안함</div>
      </label>
      <label class="radio-button">
        <input type="radio" name="terms1" value="yes" hidden />
        <div class="radio-circle"></div>
        <div class="radio-text">동의함</div>
      </label>
    </div>
  </div>
  <div class="terms-box">
    ■ 이용약관 <br />
    제1조(목적) 이 약관은 회사가 제공하는 서비스의 이용조건 및 절차에 관한 사항을 규정합니다.<br />
    제2조(정의) "회원"이라 함은 사이트에 개인정보를 제공하여 가입한 자를 말합니다.<br />
    제3조(약관의 효력 및 변경) 이 약관은 사이트에 게시함으로써 효력을 발생하며, 변경 시 별도 고지 후 적용됩니다.
  </div>
</div>

       <!-- 개인정보 수집 동의 카드형 구조 -->
<div class="terms-card">
  <div class="terms-header">
    <div class="terms-label">개인정보 수집 및 이용에 대한 안내 사항을 읽고 동의합니다. <span class="label-required">(필수)</span></div>
    <div class="radio-group">
      <label class="radio-button">
        <input type="radio" name="terms2" value="no" hidden />
        <div class="radio-circle"></div>
        <div class="radio-text">동의안함</div>
      </label>
      <label class="radio-button">
        <input type="radio" name="terms2" value="yes" hidden />
        <div class="radio-circle"></div>
        <div class="radio-text">동의함</div>
      </label>
    </div>
  </div>
  <div class="terms-box">
    ■ 개인정보 수집 및 이용<br />
    수집 항목: 이름, 이메일, 휴대폰번호(필수), 생년월일, 주소 (선택)<br />
    이용 목적: 회원관리, 민원처리, 고지사항 전달 등<br />
    보유 기간: 회원 탈퇴 시까지 또는 관련 법령 기준에 따름
  </div>
</div>

<!-- 개인정보 제3자 제공 동의 카드형 구조 -->
<div class="terms-card">
  <div class="terms-header">
    <div class="terms-label">개인정보 제 3자 제공 동의에 대한 안내 사항을 읽고 동의합니다. <span class="label-required">(필수)</span></div>
    <div class="radio-group">
      <label class="radio-button">
        <input type="radio" name="terms3" value="no" hidden />
        <div class="radio-circle"></div>
        <div class="radio-text">동의안함</div>
      </label>
      <label class="radio-button">
        <input type="radio" name="terms3" value="yes" hidden />
        <div class="radio-circle"></div>
        <div class="radio-text">동의함</div>
      </label>
    </div>
  </div>
  <div class="terms-box">
    ■ 개인정보 제3자 제공 동의<br />
    제공받는 자: 배송업체, 결제대행사<br />
    제공 목적: 상품 배송, 결제 처리<br />
    제공 항목: 이름, 연락처, 주소, 결제정보<br />
    보유 및 이용 기간: 제공 목적 달성 후 즉시 파기
  </div>
</div>

        <!-- 버튼 영역 -->
        <div class="button-group">
          <a href="${cpath}/main" class="btn cancel">취소</a>
          <a href="${cpath}/auth/join/userinfo" id="nextBtn" class="btn next">다음</a>
        </div>
      </div>
    </div>
  </div>

 <script>
  $(document).ready(function () {
    // kakaoEmail 확인 및 알림
    var kakaoEmail = "${sessionScope.kakaoemail}";
    if (kakaoEmail) {
      alert(kakaoEmail + "으로 가입된 정보가 없습니다. 회원가입 페이지로 이동합니다.");
    }
 	// naverEmail 확인 및 알림
    var naverEmail = "${sessionScope.naverInfo.email}";
    if (naverEmail) {
      alert(naverEmail + "으로 가입된 정보가 없습니다. 회원가입 페이지로 이동합니다.");
    }

    // 전체 동의 체크 시 하위 항목 모두 체크/해제
    $("#agreeAll").on("change", function () {
      const checked = $(this).is(":checked");
      $('input[name="terms1"][value="yes"]').prop("checked", checked);
      $('input[name="terms2"][value="yes"]').prop("checked", checked);
      $('input[name="terms3"][value="yes"]').prop("checked", checked);
    });

    // 다음 버튼 클릭 시 필수 약관 동의 확인
    $("#nextBtn").on("click", function (event) {
      const terms1 = $('input[name="terms1"][value="yes"]').is(":checked");
      const terms2 = $('input[name="terms2"][value="yes"]').is(":checked");
      const terms3 = $('input[name="terms3"][value="yes"]').is(":checked");

      if (!(terms1 && terms2 && terms3)) {
        event.preventDefault();
        alert("모든 약관에 동의하셔야 다음 단계로 진행할 수 있습니다.");
      }
    });
  });
</script>


</body>
</html>
