<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%> 
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />

<!-- Google Fonts - Jua -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Jua&display=swap" rel="stylesheet">

<!-- jQuery -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<!-- 1) Tailwind CDN 로드 전에 config 선언 -->
<script>
  // 이미 window.tailwind가 있든 없든, 먼저 config를 박아둡니다.
  window.tailwind = window.tailwind || {};
  window.tailwind.config = {
    theme: {
      extend: {
        fontFamily: {
          jua: ['Jua', 'ui-sans-serif', 'system-ui', 'sans-serif'],
        },
        colors: {
          'brand-900': '#2D4739',
        },
        maxWidth: {
          '1440': '1440px',
          '1920': '1920px',
        }
      }
    }
  };
</script>

<!-- 2) 그 다음에 Tailwind 로드 -->
<script src="https://cdn.tailwindcss.com"></script>

<!-- 헤더 스타일 강제 적용 -->
<style>
  /* 브랜드 색상 강제 적용 */
  .bg-brand-900 {
    background-color: #2D4739 !important;
  }
  
  /* 텍스트 색상 확실히 적용 */
  .text-white {
    color: white !important;
  }
  
  /* 호버 효과 */
  .hover\:underline:hover {
    text-decoration: underline;
  }
  
  .hover\:underline-offset-2:hover {
    text-underline-offset: 2px;
  }
  
  /* 검색바 스타일 */
  .bg-white\/10 {
    background-color: rgba(255, 255, 255, 0.1) !important;
  }
  
  .border-white\/20 {
    border-color: rgba(255, 255, 255, 0.2) !important;
  }
  
  .placeholder-white\/60::placeholder {
    color: rgba(255, 255, 255, 0.6) !important;
  }
  
  .focus\:bg-white\/20:focus {
    background-color: rgba(255, 255, 255, 0.2) !important;
  }
  
  .focus\:border-white\/40:focus {
    border-color: rgba(255, 255, 255, 0.4) !important;
  }
</style>

<!-- 헤더 HTML -->
<header class="w-full border-b border-gray-100 font-jua">
  <!-- 데스크톱 상단 바 -->
  <div class="hidden md:block w-full bg-brand-900 text-white">
    <div class="mx-auto w-full max-w-[1920px] px-4 lg:px-16 xl:px-60 h-[50px] flex items-center justify-end">
      <nav class="flex items-center gap-4 text-[15px]">
        <!-- 로그인 전 -->
        <c:if test="${empty sessionScope.loginMember}">
          <a href="${cpath}/auth/login" class="hover:underline hover:underline-offset-2 text-white">로그인</a>
          <span aria-hidden="true" class="text-white">|</span>
          <a href="${cpath}/auth/join/agree" class="hover:underline hover:underline-offset-2 text-white">회원가입</a>
        </c:if>

        <!-- 로그인 후 -->
        <c:if test="${not empty sessionScope.loginMember}">
          <span class="whitespace-nowrap text-white">
            <strong>${sessionScope.loginMember.memberName}</strong>님 반갑습니다!
          </span>
          <c:if test="${empty storeUrl}">
            <script>
              sessionStorage.removeItem("chatCreated");
            </script>
            <a href="${cpath}/main/mypage/message" class="hover:underline hover:underline-offset-2 whitespace-nowrap text-white">메시지</a>
          </c:if>
          <c:if test="${not empty storeUrl}">
            <c:if test="${loginMember.memberId == storeOwnerId}">
              <script>
                sessionStorage.removeItem("chatCreated");
              </script>
              <a href="${cpath}/${storeUrl}/mypage/message" class="hover:underline hover:underline-offset-2 whitespace-nowrap text-white">메시지</a>
            </c:if>
            <c:if test="${loginMember.memberId != storeOwnerId}">
              <!-- 기존 링크를 버튼으로 변경하고 채팅방 생성 함수 호출 -->
              <button onclick="createStoreChatAndRedirect('${storeUrl}', '${storeName}')" class="hover:underline hover:underline-offset-2 whitespace-nowrap text-white bg-transparent border-0 cursor-pointer">
                ${storeName}에 메시지 보내기
              </button>
            </c:if>
          </c:if>
          <a href="javascript:void(0);" class="hover:underline hover:underline-offset-2 whitespace-nowrap text-white" id="btn-logout">로그아웃</a>
        </c:if>
      </nav>
    </div>
  </div>

  <!-- 모바일 상단 바: 로고 | 검색바 | 메시지 | 햄버거 -->
  <div class="md:hidden w-full bg-brand-900 text-white">
    <div class="mx-auto w-full max-w-[1920px] px-4 min-[1920px]:px-60 h-[50px] flex items-center gap-3">
      <!-- 로고 (왼쪽) -->
      <a href="${cpath}/main" class="flex items-center gap-2 flex-shrink-0">
        <img
          src="${cpath}/resources/images/logo/mainlogo_mob.png"
          alt="뜨락상회 로고"
          class="h-8 w-auto"
        />
      </a>

      <!-- 검색바 (중앙, flex-1로 공간 차지) -->
      <div class="flex-1 min-w-0">
        <form action="${cpath}/main/search" method="get" class="w-full">
          <input 
            type="search" 
            name="q" 
            placeholder="검색어를 입력하세요"
            class="w-full px-3 py-1.5 text-sm bg-white bg-opacity-10 border border-white border-opacity-20 rounded-full text-white placeholder-white placeholder-opacity-60 focus:outline-none focus:bg-white focus:bg-opacity-20 focus:border-white focus:border-opacity-40"
            style="background-color: rgba(255, 255, 255, 0.1); border-color: rgba(255, 255, 255, 0.2);"
          />
        </form>
      </div>

      <!-- 메시지 아이콘 (우측) -->
      <div class="flex-shrink-0">
        <c:if test="${not empty sessionScope.loginMember}">
          <c:if test="${empty storeUrl}">
            <a href="${cpath}/main/mypage/message" aria-label="메시지" class="p-2 -mr-1 text-white">
              <svg viewBox="0 0 24 24" class="h-6 w-6" fill="currentColor" aria-hidden="true">
                <path d="M20 4H4c-1.1 0-2 .9-2 2v12a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V6c0-1.1-.9-2-2-2Zm0 4-8 5L4 8V6l8 5 8-5v2Z" />
              </svg>
            </a>
          </c:if>
          <c:if test="${not empty storeUrl}">
            <c:if test="${loginMember.memberId == storeOwnerId}">
              <a href="${cpath}/${storeUrl}/mypage/message" aria-label="메시지" class="p-2 -mr-1 text-white">
                <svg viewBox="0 0 24 24" class="h-6 w-6" fill="currentColor" aria-hidden="true">
                  <path d="M20 4H4c-1.1 0-2 .9-2 2v12a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V6c0-1.1-.9-2-2-2Zm0 4-8 5L4 8V6l8 5 8-5v2Z" />
                </svg>
              </a>
            </c:if>
            <c:if test="${loginMember.memberId != storeOwnerId}">
              <!-- 모바일에서도 채팅방 생성 함수 호출 -->
              <button onclick="createStoreChatAndRedirect('${storeUrl}', '${storeName}')" aria-label="메시지" class="p-2 -mr-1 bg-transparent border-0 text-white">
                <svg viewBox="0 0 24 24" class="h-6 w-6" fill="currentColor" aria-hidden="true">
                  <path d="M20 4H4c-1.1 0-2 .9-2 2v12a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V6c0-1.1-.9-2-2-2Zm0 4-8 5L4 8V6l8 5 8-5v2Z" />
                </svg>
              </button>
            </c:if>
          </c:if>
        </c:if>
        <c:if test="${empty sessionScope.loginMember}">
          <button onclick="alert('로그인이 필요합니다.'); window.location.href='${cpath}/auth/login';" aria-label="메시지" class="p-2 -mr-1 text-white">
            <svg viewBox="0 0 24 24" class="h-6 w-6" fill="currentColor" aria-hidden="true">
              <path d="M20 4H4c-1.1 0-2 .9-2 2v12a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V6c0-1.1-.9-2-2-2Zm0 4-8 5L4 8V6l8 5 8-5v2Z" />
            </svg>
          </button>
        </c:if>
      </div>

      <!-- 햄버거 메뉴 (우측 끝) -->
      <div class="flex-shrink-0">
        <button
          onclick="toggleMobileMenu()"
          class="p-2 text-white"
          aria-label="메뉴 열기"
          id="mobile-menu-button"
        >
          <svg class="h-6 w-6" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
            <path id="menu-icon" d="M3 6h18v2H3V6zm0 5h18v2H3v-2zm0 5h18v2H3v-2z" />
            <path id="close-icon" class="hidden" fill-rule="evenodd" d="M6.225 4.811a1 1 0 0 1 1.414 0L12 9.172l4.361-4.361a1 1 0 0 1 1.414 1.414L13.414 10.586l4.361 4.361a1 1 0 0 1-1.414 1.414L12 12l-4.361 4.361a1 1 0 0 1-1.414-1.414l4.361-4.361-4.361-4.361a1 1 0 0 1 0-1.414Z" clip-rule="evenodd" />
          </svg>
        </button>
      </div>
    </div>

    <!-- 모바일 드롭다운 메뉴 -->
    <div id="mobile-menu" class="hidden md:hidden border-t border-white border-opacity-20 bg-brand-900 text-white">
      <div class="mx-auto w-full max-w-[1920px] px-4 min-[1920px]:px-60 py-3 text-[15px] space-y-2">
        <!-- 로그인 전 -->
        <c:if test="${empty sessionScope.loginMember}">
          <button onclick="window.location.href='${cpath}/auth/login'" class="block w-full text-left hover:underline hover:underline-offset-2 text-white">
            로그인
          </button>
          <button onclick="window.location.href='${cpath}/auth/join/agree'" class="block w-full text-left hover:underline hover:underline-offset-2 text-white">
            회원가입
          </button>
        </c:if>

        <!-- 로그인 후 -->
        <c:if test="${not empty sessionScope.loginMember}">
          <div class="opacity-90 text-white">
            <strong>${sessionScope.loginMember.memberName}</strong>님 반갑습니다!
          </div>
          <button onclick="handleMobileLogout()" class="block w-full text-left hover:underline hover:underline-offset-2 text-white">
            로그아웃
          </button>
        </c:if>
      </div>
    </div>
  </div>
</header>

<!-- 헤더 JavaScript -->
<script>
// 전역 함수로 선언
window.toggleMobileMenu = function() {
  const menu = document.getElementById('mobile-menu');
  const menuIcon = document.getElementById('menu-icon');
  const closeIcon = document.getElementById('close-icon');
  
  if (menu && menuIcon && closeIcon) {
    if (menu.classList.contains('hidden')) {
      menu.classList.remove('hidden');
      menuIcon.style.display = 'none';
      closeIcon.style.display = 'block';
    } else {
      menu.classList.add('hidden');
      menuIcon.style.display = 'block';
      closeIcon.style.display = 'none';
    }
  }
}

window.closeMobileMenu = function() {
  const menu = document.getElementById('mobile-menu');
  const menuIcon = document.getElementById('menu-icon');
  const closeIcon = document.getElementById('close-icon');
  
  if (menu && menuIcon && closeIcon) {
    menu.classList.add('hidden');
    menuIcon.style.display = 'block';
    closeIcon.style.display = 'none';
  }
}

window.handleMobileLogout = function() {
  if (document.getElementById('btn-logout')) {
    document.getElementById('btn-logout').click();
  }
  closeMobileMenu();
}

// 스토어 채팅방 생성 및 리다이렉트 함수
window.createStoreChatAndRedirect = function(storeUrl, storeName) {
  const buyerId = ${sessionScope.loginMember.memberId};
  
  if (!buyerId) {
    alert('로그인이 필요합니다.');
    window.location.href = '${cpath}/auth/login';
    return;
  }

  // 로딩 표시 (선택사항)
  console.log('채팅방 생성 중...');

  $.ajax({
    url: '${cpath}/api/chat/personal/' + storeUrl,
    type: 'POST',
    data: {
      buyerId: buyerId
    },
    success: function(response) {
      console.log('채팅방 생성 완료:', response);
      // 채팅방이 생성되면 메시지 페이지로 이동
      window.location.href = '${cpath}/' + storeUrl + '/mypage/message';
    },
    error: function(xhr, status, error) {
      console.error('채팅방 생성 실패:', error);
      
      // 이미 채팅방이 존재하는 경우에도 메시지 페이지로 이동
      if (xhr.status === 409 || xhr.status === 200) {
        console.log('기존 채팅방 사용');
        window.location.href = '${cpath}/' + storeUrl + '/mypage/message';
      } else {
        alert('채팅방 생성에 실패했습니다. 다시 시도해주세요.');
      }
    }
  });
}

// 문서가 준비되면 실행
$(document).ready(function() {
  // 데스크톱 로그아웃
  $('#btn-logout').on('click', function() {
    console.log("로그아웃 버튼 클릭");
    
    $.ajax({
      url: '/auth/logout',
      type: 'POST',
      data: { email:"${sessionScope.loginMember.memberEmail}" },
      xhrFields: { withCredentials: true },
      success: function(resp){
        console.log("Spring Boot 로그아웃 완료:", resp);
        if (typeof clearAccessToken === 'function') {
          clearAccessToken();
        }
      },
      error: function(xhr, status, error){
        console.warn("Spring Boot 로그아웃 실패:", error);
      },
      complete: function(){
        alert('로그아웃 되었습니다.');
        window.location.href = '${cpath}/auth/logout';
      }
    });
  });

  // 화면 밖 클릭시 모바일 메뉴 닫기
  document.addEventListener('click', function(event) {
    const mobileMenu = document.getElementById('mobile-menu');
    const menuButton = document.getElementById('mobile-menu-button');
    
    if (mobileMenu && !mobileMenu.contains(event.target) && 
        !menuButton.contains(event.target) && 
        !mobileMenu.classList.contains('hidden')) {
      closeMobileMenu();
    }
  });

  // 화면 크기 변경시 모바일 메뉴 닫기
  window.addEventListener('resize', function() {
    if (window.innerWidth >= 768) {
      closeMobileMenu();
    }
  });
});
</script>