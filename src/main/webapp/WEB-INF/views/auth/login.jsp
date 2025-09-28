<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>로그인 페이지</title>

  <!-- TailwindCSS CDN -->
  <script src="https://cdn.tailwindcss.com"></script>
  <script>
    // 브랜드 컬러(프로젝트 공통 팔레트) 주입
    tailwind.config = {
      theme: {
        extend: {
          colors: {
            primary: '#2D4739',
            accent: '#6BAA75',
            beige: '#F8F3E5',
            ivory: '#FDFAF2'
          },
          boxShadow: {
            soft: '0 8px 24px rgba(0,0,0,0.08)'
          }
        }
      }
    }
  </script>

  <!-- jQuery -->
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

  <!-- 모바일 뷰포트 -->
  <meta name="viewport" content="width=device-width, initial-scale=1" />
</head>
<body class="min-h-screen bg-gradient-to-br from-ivory to-beige">
  <div class="flex items-center justify-center min-h-screen px-4">
    <div class="w-full max-w-md sm:max-w-lg">
      <!-- 카드 -->
      <div class="bg-white/90 backdrop-blur rounded-2xl shadow-soft p-6 sm:p-8">
        <!-- 로고 -->
        <div class="flex justify-center mb-6">
          <a href="${cpath}/main" class="inline-flex">
            <img
              class="h-10 sm:h-12 object-contain"
              src="${cpath}/resources/images/logo/logo_green.png"
              alt="Logo"
            />
          </a>
        </div>

        <!-- 제목 -->
        <h1 class="text-center text-2xl sm:text-3xl font-bold text-gray-900">로그인</h1>
        <p class="mt-2 text-center text-sm text-gray-500">핸드메이드 커뮤니티와 함께하세요</p>

        <!-- 폼 -->
        <form id="login-form" class="mt-6 space-y-5">
          <!-- 이메일 -->
          <div>
            <label for="email" class="block text-sm font-medium text-gray-700 mb-1">이메일</label>
            <input
              id="email"
              type="email"
              name="email"
              placeholder="name@example.com"
              required
              class="w-full rounded-xl border border-gray-300 px-4 py-3 text-gray-900 placeholder:text-gray-400 focus:outline-none focus:ring-4 focus:ring-accent/20 focus:border-accent transition"
            />
          </div>

          <!-- 비밀번호 -->
          <div>
            <div class="flex items-center justify-between mb-1">
              <label for="password" class="block text-sm font-medium text-gray-700">비밀번호</label>
             
            </div>
            <input
              id="password"
              type="password"
              name="password"
              placeholder="••••••••"
              required
              class="w-full rounded-xl border border-gray-300 px-4 py-3 text-gray-900 placeholder:text-gray-400 focus:outline-none focus:ring-4 focus:ring-accent/20 focus:border-accent transition"
            />
          </div>

          <!-- 아이디 기억하기 -->
          <div class="flex items-center">
            <input
              id="rememberId"
              name="rememberId"
              type="checkbox"
              class="h-4 w-4 rounded border-gray-300 text-primary focus:ring-accent"
            />
            <label for="rememberId" class="ml-2 select-none text-sm text-gray-700">아이디 기억하기</label>
          </div>

          <!-- 로그인 버튼 -->
          <button
            type="submit"
            class="w-full inline-flex items-center justify-center rounded-xl bg-primary px-4 py-3 text-white font-semibold hover:opacity-95 active:opacity-90 focus:outline-none focus:ring-4 focus:ring-primary/30 transition"
          >
            로그인
          </button>

          <!-- 회원가입 링크 -->
          <p class="text-center text-sm text-gray-600">
            아직 회원이 아니신가요?
            <button
              type="button"
              onclick="location.href='${cpath}/auth/join/agree';"
              class="text-accent font-semibold hover:underline"
            >
              회원가입
            </button>
          </p>
        </form>

        <!-- 구분선 -->
        <div class="relative my-6">
          <div class="absolute inset-0 flex items-center" aria-hidden="true">
            <div class="w-full border-t border-gray-200"></div>
          </div>
          <div class="relative flex justify-center">
            <span class="bg-white px-3 text-xs sm:text-sm text-gray-500">소셜 로그인</span>
          </div>
        </div>

        <!-- 소셜 로그인 -->
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
          <a
            href="${naverLogin}"
            class="inline-flex items-center justify-center gap-2 rounded-xl border border-gray-200 bg-white px-4 py-3 text-gray-900 hover:bg-gray-50 focus:outline-none focus:ring-4 focus:ring-accent/10 transition"
          >
            <img src="${cpath}/resources/images/login/naver_icon.png" alt="네이버" class="h-6 w-6" />
            <span class="text-sm font-medium">네이버 로그인</span>
          </a>
          <a
            href="${kakaoLogin}"
            class="inline-flex items-center justify-center gap-2 rounded-xl border border-gray-200 bg-white px-4 py-3 text-gray-900 hover:bg-gray-50 focus:outline-none focus:ring-4 focus:ring-accent/10 transition"
          >
            <img src="${cpath}/resources/images/login/kakao_icon.png" alt="카카오" class="h-6 w-6" />
            <span class="text-sm font-medium">카카오 로그인</span>
          </a>
        </div>
      </div>

      <!-- 하단 문구 -->
      <p class="mt-6 text-center text-xs text-gray-500">
        © <span class="font-medium">HandCraft Mall</span>. All rights reserved.
      </p>
    </div>
  </div>

  <!-- 로그인 스크립트 (기존 로직 유지) -->
  <script>
    $(document).ready(function() {
      const contextpath = '${cpath}';

      // 저장된 이메일 복원
      const savedEmail = localStorage.getItem('rememberedEmail');
      if (savedEmail) {
        $('input[name="email"]').val(savedEmail);
        $('#rememberId').prop('checked', true);
      }

      // 로그인 처리
      $('#login-form').on('submit', function(e) {
        e.preventDefault();

        const email = $('input[name="email"]').val();
        const password = $('input[name="password"]').val();
        const rememberId = $('#rememberId').is(':checked');

        // 아이디 기억하기
        if (rememberId) {
          localStorage.setItem('rememberedEmail', email);
        } else {
          localStorage.removeItem('rememberedEmail');
        }

        // Spring Boot 로그인
        $.ajax({
          url: '/api/auth/login',
          type: 'POST',
          contentType: 'application/json',
          data: JSON.stringify({ email, password }),
          xhrFields: { withCredentials: true },
          success: function(loginResponse, textStatus, xhr) {
            if (xhr.status === 200 && loginResponse?.status === 200) {
              localStorage.setItem('accessToken', loginResponse.data.accessToken);

              // Legacy 세션 저장
              $.ajax({
                url: '/legacy/auth/loginSuccess',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({
                  memberId: loginResponse.data.login.id,
                  memberEmail: loginResponse.data.login.email,
                  memberName: loginResponse.data.login.name
                }),
                success: function(legacyResponse, status, xhrr) {
                  if (xhrr.status === 200) {
                    console.log('Legacy 세션 저장 성공:', legacyResponse);
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
