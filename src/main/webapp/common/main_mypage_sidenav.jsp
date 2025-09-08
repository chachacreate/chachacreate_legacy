<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />
<c:set var="uri" value="${pageContext.request.requestURI}" />

<!--
  반응형 사이드 내비:
  - lg 이상: 기존 세로 리스트
  - lg 미만: 아이콘 그리드 (마이정보수정은 같은 페이지라 #myinfo 로, 그 외는 각 페이지로 이동)
-->

<aside class="font-jua w-full lg:w-60">
<!-- 📱 Mobile: 아이콘 그리드 (높이/라벨 통일 버전) -->
<nav class="lg:hidden bg-white rounded-2xl shadow-lg border border-gray-100 overflow-hidden mb-4">
  <div class="bg-white border-b px-5 py-4">
  <h2 class="text-lg font-bold text-brand-900">마이페이지</h2>
</div>

  <ul class="grid grid-cols-3 sm:grid-cols-5 gap-2 p-4">
    <!-- 마이정보수정 -->
    <li>
      <a
        href="${fn:contains(uri, '/main/mypage') ? '#myinfo' : cpath.concat('/main/mypage#myinfo')}"
        class="group flex flex-col items-center justify-center gap-2 rounded-xl border h-24
               ${fn:contains(uri, '/main/mypage') ? 'border-brand-900 text-brand-900' : 'border-gray-200 text-gray-700 hover:border-brand-300 hover:bg-brand-100/50'}
               px-3 py-4 transition"
        aria-current="${fn:contains(uri, '/main/mypage') ? 'page' : 'false'}"
      >
        <svg class="w-6 h-6" viewBox="0 0 24 24" fill="none"><circle cx="12" cy="8" r="3.25" stroke="currentColor" stroke-width="1.6"/><path d="M5 20a7 7 0 0 1 14 0" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"/></svg>
        <span class="text-xs w-full text-center whitespace-nowrap truncate">마이정보</span>
      </a>
    </li>

    <!-- 장바구니 -->
    <li>
      <a href="${cpath}/main/mypage/cart"
         class="group flex flex-col items-center justify-center gap-2 rounded-xl border h-24
                ${fn:contains(uri, '/main/mypage/cart') ? 'border-brand-900 text-brand-900' : 'border-gray-200 text-gray-700 hover:border-brand-300 hover:bg-brand-100/50'}
                px-3 py-4 transition"
         aria-current="${fn:contains(uri, '/main/mypage/cart') ? 'page' : 'false'}">
        <svg class="w-6 h-6" viewBox="0 0 24 24" fill="none"><path d="M3 3h2l2 12h10l2-8H7" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/><circle cx="9" cy="20" r="1.5" stroke="currentColor" stroke-width="1.6"/><circle cx="17" cy="20" r="1.5" stroke="currentColor" stroke-width="1.6"/></svg>
        <span class="text-xs w-full text-center whitespace-nowrap truncate">장바구니</span>
      </a>
    </li>

    <!-- 주문내역 -->
    <li>
      <a href="${cpath}/main/mypage/orders"
         class="group flex flex-col items-center justify-center gap-2 rounded-xl border h-24
                ${fn:contains(uri, '/main/mypage/orders') ? 'border-brand-900 text-brand-900' : 'border-gray-200 text-gray-700 hover:border-brand-300 hover:bg-brand-100/50'}
                px-3 py-4 transition">
        <svg class="w-6 h-6" viewBox="0 0 24 24" fill="none"><path d="M6 2h9l3 3v15a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2z" stroke="currentColor" stroke-width="1.6"/><path d="M8 7h8M8 11h8M8 15h6" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"/></svg>
        <span class="text-xs w-full text-center whitespace-nowrap truncate">주문내역</span>
      </a>
    </li>

    <!-- 클래스 예약 조회 -->
    <li>
      <a href="${cpath}/main/mypage/classes"
         class="group flex flex-col items-center justify-center gap-2 rounded-xl border h-24
                ${fn:contains(uri, '/main/mypage/classes') ? 'border-brand-900 text-brand-900' : 'border-gray-200 text-gray-700 hover:border-brand-300 hover:bg-brand-100/50'}
                px-3 py-4 transition"
         aria-current="${fn:contains(uri, '/main/mypage/classes') ? 'page' : 'false'}">
        <svg class="w-6 h-6" viewBox="0 0 24 24" fill="none">
          <path d="M7 3v3M17 3v3M3 9h18" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"/>
          <rect x="3" y="6" width="18" height="15" rx="2" stroke="currentColor" stroke-width="1.6"/>
          <path d="M9 15l2 2 4-4" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
        <span class="text-xs w-full text-center whitespace-nowrap truncate">클래스 예약 조회</span>
      </a>
    </li>

    <!-- 문의 메시지 -->
    <li>
      <a href="${cpath}/main/mypage/message"
         class="group flex flex-col items-center justify-center gap-2 rounded-xl border h-24
                ${fn:contains(uri, '/main/mypage/message') ? 'border-brand-900 text-brand-900' : 'border-gray-200 text-gray-700 hover:border-brand-300 hover:bg-brand-100/50'}
                px-3 py-4 transition">
        <svg class="w-6 h-6" viewBox="0 0 24 24" fill="none"><path d="M3 6a3 3 0 0 1 3-3h12a3 3 0 0 1 3 3v8a3 3 0 0 1-3 3H10l-5 4v-4H6a3 3 0 0 1-3-3V6z" stroke="currentColor" stroke-width="1.6" stroke-linejoin="round"/></svg>
        <span class="text-xs w-full text-center whitespace-nowrap truncate">문의</span>
      </a>
    </li>

    <!-- 작성 리뷰 확인 -->
    <li>
      <a href="${cpath}/main/mypage/myreview"
         class="group flex flex-col items-center justify-center gap-2 rounded-xl border h-24
                ${fn:contains(uri, '/main/mypage/myreview') ? 'border-brand-900 text-brand-900' : 'border-gray-200 text-gray-700 hover:border-brand-300 hover:bg-brand-100/50'}
                px-3 py-4 transition">
        <svg class="w-6 h-6" viewBox="0 0 24 24" fill="none"><path d="m12 17 5.196 3.09-1.382-5.9L20 9.91l-6-.51L12 4l-2 5.4-6 .51 4.186 4.28-1.382 5.9z" stroke="currentColor" stroke-width="1.6" stroke-linejoin="round"/></svg>
        <span class="text-xs w-full text-center whitespace-nowrap truncate">내 리뷰</span>
      </a>
    </li>
  </ul>
</nav>


  <!-- 🖥️ Desktop: 세로 리스트 -->
  <nav class="hidden lg:block bg-white rounded-2xl shadow-lg border border-gray-100 overflow-hidden">
    <div class="bg-white border-b px-6 py-4">
	  <h2 class="text-lg font-bold text-brand-900">마이페이지</h2>
	</div>
    <ul class="p-4 space-y-2">
      <li>
        <a href="${cpath}/main/mypage"
           class="group flex items-center justify-between w-full px-4 py-3 rounded-xl transition
                  ${fn:contains(uri, '/main/mypage') and not fn:contains(uri, '/main/mypage/cart') and not fn:contains(uri,'/main/mypage/orders') and not fn:contains(uri,'/main/mypage/classes') and not fn:contains(uri,'/main/mypage/message') and not fn:contains(uri,'/main/mypage/myreview')
                    ? 'bg-brand-900 text-white' : 'text-gray-700 hover:bg-gray-50 hover:text-brand-900'}">
          <span>마이정보수정</span>
          <svg class="w-4 h-4 ${fn:contains(uri, '/main/mypage') and not fn:contains(uri, '/main/mypage/cart') and not fn:contains(uri,'/main/mypage/orders') and not fn:contains(uri,'/main/mypage/classes') and not fn:contains(uri,'/main/mypage/message') and not fn:contains(uri,'/main/mypage/myreview') ? 'text-white' : 'text-gray-400 group-hover:text-brand-900'}" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M7.293 14.707a1 1 0 0 1 0-1.414L10.586 10 7.293 6.707a1 1 0 0 1 1.414-1.414l4 4a1 1 0 0 1 0 1.414l-4 4a1 1 0 0 1-1.414 0z" clip-rule="evenodd"/></svg>
        </a>
      </li>

      <li>
        <a href="${cpath}/main/mypage/cart"
           class="group flex items-center justify-between w-full px-4 py-3 rounded-xl transition
                  ${fn:contains(uri, '/main/mypage/cart') ? 'bg-brand-900 text-white' : 'text-gray-700 hover:bg-gray-50 hover:text-brand-900'}">
          <span>장바구니</span>
          <svg class="w-4 h-4 ${fn:contains(uri, '/main/mypage/cart') ? 'text-white' : 'text-gray-400 group-hover:text-brand-900'}" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M7.293 14.707a1 1 0 0 1 0-1.414L10.586 10 7.293 6.707a1 1 0 0 1 1.414-1.414l4 4a1 1 0 0 1 0 1.414l-4 4a1 1 0 0 1-1.414 0z" clip-rule="evenodd"/></svg>
        </a>
      </li>

      <li>
        <a href="${cpath}/main/mypage/orders"
           class="group flex items-center justify-between w-full px-4 py-3 rounded-xl transition
                  ${fn:contains(uri, '/main/mypage/orders') ? 'bg-brand-900 text-white' : 'text-gray-700 hover:bg-gray-50 hover:text-brand-900'}">
          <span>주문내역</span>
          <svg class="w-4 h-4 ${fn:contains(uri, '/main/mypage/orders') ? 'text-white' : 'text-gray-400 group-hover:text-brand-900'}" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M7.293 14.707a1 1 0 0 1 0-1.414L10.586 10 7.293 6.707a1 1 0 0 1 1.414-1.414l4 4a1 1 0 0 1 0 1.414l-4 4a1 1 0 0 1-1.414 0z" clip-rule="evenodd"/></svg>
        </a>
      </li>

      <!-- ✅ 클래스 예약 조회 (신규) -->
      <li>
  <a href="${cpath}/main/mypage/classes"
     class="group flex items-center justify-between w-full px-4 py-3 rounded-xl transition
            ${fn:contains(uri, '/main/mypage/classes') ? 'bg-brand-900 text-white' : 'text-gray-700 hover:bg-gray-50 hover:text-brand-900'}">
    <span>클래스 예약 조회</span>
    <!-- ⬇️ 달력 아이콘 대신 공통 화살표 아이콘으로 교체 -->
    <svg class="w-4 h-4 ${fn:contains(uri, '/main/mypage/classes') ? 'text-white' : 'text-gray-400 group-hover:text-brand-900'}"
         viewBox="0 0 20 20" fill="currentColor">
      <path fill-rule="evenodd"
            d="M7.293 14.707a1 1 0 0 1 0-1.414L10.586 10 7.293 6.707a1 1 0 0 1 1.414-1.414l4 4a1 1 0 0 1 0 1.414l-4 4a1 1 0 0 1-1.414 0z"
            clip-rule="evenodd"/>
    </svg>
  </a>
</li>


      <li>
        <a href="${cpath}/main/mypage/message"
           class="group flex items-center justify-between w-full px-4 py-3 rounded-xl transition
                  ${fn:contains(uri, '/main/mypage/message') ? 'bg-brand-900 text-white' : 'text-gray-700 hover:bg-gray-50 hover:text-brand-900'}">
          <span>문의 메시지</span>
          <svg class="w-4 h-4 ${fn:contains(uri, '/main/mypage/message') ? 'text-white' : 'text-gray-400 group-hover:text-brand-900'}" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M7.293 14.707a1 1 0 0 1 0-1.414L10.586 10 7.293 6.707a1 1 0 0 1 1.414-1.414l4 4a1 1 0 0 1 0 1.414l-4 4a1 1 0 0 1-1.414 0z" clip-rule="evenodd"/></svg>
        </a>
      </li>

      <li>
        <a href="${cpath}/main/mypage/myreview"
           class="group flex items-center justify-between w-full px-4 py-3 rounded-xl transition
                  ${fn:contains(uri, '/main/mypage/myreview') ? 'bg-brand-900 text-white' : 'text-gray-700 hover:bg-gray-50 hover:text-brand-900'}">
          <span>작성 리뷰 확인</span>
          <svg class="w-4 h-4 ${fn:contains(uri, '/main/mypage/myreview') ? 'text-white' : 'text-gray-400 group-hover:text-brand-900'}" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M7.293 14.707a1 1 0 0 1 0-1.414L10.586 10 7.293 6.707a1 1 0 0 1 1.414-1.414l4 4a1 1 0 0 1 0 1.414l-4 4a1 1 0 0 1-1.414 0z" clip-rule="evenodd"/></svg>
        </a>
      </li>
    </ul>
  </nav>
</aside>
