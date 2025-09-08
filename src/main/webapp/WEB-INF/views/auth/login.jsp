<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인 페이지</title>
<%-- <link rel="stylesheet" type="text/css" href="${cpath}/resources/css/login_vars.css"> --%>
<link rel="stylesheet" type="text/css"
	href="${cpath}/resources/css/auth/login.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
	<div class="login-page">
		<div class="login-container">
			<form id="login-form">
				<a href="${cpath}/main"> <img class="logo_frame"
					src="${cpath}/resources/images/logo/logo_green.png" alt="Logo" />
				</a>
				<div class="form-wrapper">
					<div class="form-inner">
						<div class="input-group">
							<div class="email_password_frame">
								<input type="email" name="email" class="input-box"
									placeholder="이메일" required>
							</div>
							<div class="email_password_frame">
								<input type="password" name="password" class="input-box"
									placeholder="비밀번호" required>
							</div>
							<div class="checkbox">
								<div class="checkbox2">
									<div class="item">
										<input type="checkbox" id="rememberId" name="rememberId"
											class="checkbox-item">
									</div>
									<div class="label">
										<label for="rememberId" class="rememberId_frame">아이디
											기억하기</label>
									</div>
								</div>
							</div>
						</div>
						<div class="login-button-group">
							<button type="submit" class="component_login">로그인</button>
							<div class="login-bottom-links">
								<div class="link-text">비밀번호를 잊으셨나요?</div>
								<a href="${cpath}/auth/join/agree" class="link-text">회원가입</a>
							</div>
						</div>
					</div>
				</div>
				<div class="social-divider">
					<div class="line"></div>
					<div class="social-label">소셜로그인</div>
					<div class="line"></div>
				</div>

				<div class="social-login">
					<a href="${naverLogin}" class="naver-btn"> <img
						src="${cpath}/resources/images/login/naver_icon.png" alt="네이버"
						style="width: 24px; height: 24px; margin-right: 10px;"> 네이버
						로그인
					</a> <a href="${kakaoLogin}" class="kakao-btn"> <img
						src="${cpath}/resources/images/login/kakao_icon.png" alt="카카오"
						style="width: 24px; height: 24px; margin-right: 10px;"> 카카오
						로그인
					</a>
				</div>
			</form>
		</div>
	</div>
	<!-- login.jsp 내부에 script 추가 -->
	<script>
$(document).ready(function() {
	const contextpath = '${cpath}';
  // 페이지 로드 시 로컬스토리지에 저장된 아이디 있으면 자동 입력
  const savedEmail = localStorage.getItem('rememberedEmail');
  if (savedEmail) {
    $('input[name="email"]').val(savedEmail);
    $('#rememberId').prop('checked', true);
  }

  // 로그인 버튼 클릭 이벤트
  $('#login-form').on('submit', function(e) {
    e.preventDefault(); // form 동작 막기

    const email = $('input[name="email"]').val();
    const password = $('input[name="password"]').val();
    const rememberId = $('#rememberId').is(':checked');

    // 아이디 기억하기 처리
    if (rememberId) {
      localStorage.setItem('rememberedEmail', email);
    } else {
      localStorage.removeItem('rememberedEmail');
    }

 // Spring Boot 로그인 요청
    $.ajax({
        url: '/api/auth/login',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({ email, password }),
        xhrFields: { withCredentials: true }, // 쿠키 포함
        success: function(loginResponse, textStatus, xhr) {
            if (xhr.status === 200 && loginResponse?.status === 200) {
                localStorage.setItem('accessToken', loginResponse.data.accessToken);

                // Legacy 서버에도 세션 저장
                $.ajax({
                    url: '/legacy/auth/loginSuccess',
                    type: "POST",
                    contentType: 'application/json',
                    data: JSON.stringify({ 
                    	memberId:loginResponse.data.login.id,
                    	memberEmail:loginResponse.data.login.email,
                    	memberName:loginResponse.data.login.name,
                    }),
                    success: function(legacyResponse, status, xhrr) {
                        if (xhrr.status === 200) {
                            console.log("Legacy 세션 저장 성공:", legacyResponse);
                            
                        } else {
                            alert(legacyResponse?.message || 'Legacy 로그인 실패');
                        }
                    },
                    error: function(xhrr, status, error) {
                        alert('Legacy 서버 오류: ' + (xhrr.responseText || error));
                    }
                });

                alert('로그인 성공');
                let redirectUrl = loginResponse.data?.redirect || contextpath + '/main';
                if (!redirectUrl.startsWith(contextpath)) {
                    redirectUrl = contextpath + redirectUrl;
                }
                window.location.href = redirectUrl;
            } else {
                alert(loginResponse?.message || '로그인 실패');
            }
        },
        error: function(xhr, status, error) {
            alert('서버 오류: ' + (xhr.responseText || error));
        }
    });

});

});
</script>

</body>
</html>
