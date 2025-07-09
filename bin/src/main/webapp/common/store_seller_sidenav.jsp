<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
/* 사이드바 전체 */
.sidebar {
  width: 240px;
  background-color: #CFD3C4;
  padding: 20px;
  border-radius: 8px 0 0 8px;
  box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
  box-sizing: border-box;
  flex-shrink: 0;
}

/* 프로필 영역 */
.profile-section {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 20px;
}

.profile-img {
  width: 133px;
  height: 133px;
  border-radius: 50%;
  background-color: #556b49;
  border: 3px solid white;
}

.store-name {
  margin-top: 8px;
  font-size: 20px;
  font-weight: 700;
  color: #333;
}

/* 메뉴 리스트 */
.menu-list {
  list-style: none;
  padding: 0;
  margin: 0;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.menu-list li {
  margin: 0;
}

.menu-list a {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 16px;
  text-decoration: none;
  border-radius: 8px;
  color: #333;
  font-size: 15px;
  font-weight: 500;
  transition: background-color 0.2s ease;
}

.menu-text {
  margin-left: 4px;
  flex-grow: 1;
  text-align: left;
}

.menu-list a:hover {
  background-color: #e4e9db;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.08);
}

/* 화살표 */
.arrow {
  font-size: 16px;
  color: #777;
}

/* 서브메뉴 */
.submenu {
  display: none;
  background-color: #c4c8b8;
  margin-top: 4px;
  border-radius: 6px;
}

.submenu li a {
  padding: 10px 20px 10px 36px;
  font-weight: 600;
  font-size: 14px;
  display: block;
}

/* 하단 버튼 */
.sidebar-footer {
  margin-top: 60px;
  text-align: center;
}

.btn-go-buyer {
  background-color: #676f58;
  border: none;
  border-radius: 8px;
  color: white;
  font-size: 16px;
  padding: 14px 20px;
  cursor: pointer;
  width: 100%;
}

.btn-go-buyer:hover {
  background-color: #555d4a;
}
</style>

<div class="sidebar">
  <div class="profile-section">
    <div class="profile-img"></div>
    <div class="store-name">스토어명</div>
  </div>

  <ul class="menu-list">
    <!-- 상품 관리 -->
    <li>
      <a href="javascript:void(0);" class="toggle-btn">
        <span class="menu-text">상품 관리</span>
        <span class="arrow">▼</span>
      </a>
      <ul class="submenu">
        <li><a href="${cpath}/${storeUrl}/seller/product/regist">상품 등록</a></li>
        <li><a href="${cpath}/${storeUrl}/seller/product/list">판매 상품 관리</a></li>
        <li><a href="${cpath}/${storeUrl}/seller/product/list">리뷰 관리</a></li>
      </ul>
    </li>

    <!-- 주문/정산 관리 -->
    <li>
      <a href="javascript:void(0);" class="toggle-btn">
        <span class="menu-text">주문 · 정산</span>
        <span class="arrow">▼</span>
      </a>
      <ul class="submenu">
        <li><a href="${cpath}/${storeUrl}/seller/orders">주문/발송 확인</a></li>
        <li><a href="${cpath}/${storeUrl}/seller/refunds">환불 관리</a></li>
        <li><a href="${cpath}/${storeUrl}/seller/refunds">정산 관리</a></li>
      </ul>
    </li>

    <!-- 스토어 운영 -->
    <li>
      <a href="javascript:void(0);" class="toggle-btn">
        <span class="menu-text">스토어 운영</span>
        <span class="arrow">▼</span>
      </a>
      <ul class="submenu">
        <li><a href="${cpath}/${storeUrl}/seller/management/settlement">문의 메시지</a></li>
        <li><a href="${cpath}/${storeUrl}/seller/reviews">스토어 관리</a></li>
      </ul>
    </li>

  </ul>

  <div class="sidebar-footer">
    <button class="btn-go-buyer" onclick="location.href='${cpath}/main'">구매자 페이지로</button>
  </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
  $(document).ready(function () {
    $('.toggle-btn').click(function () {
      const $submenu = $(this).next('.submenu');
      const $arrow = $(this).find('.arrow');

      if ($submenu.is(':visible')) {
        // 이미 열려있는 경우 → 닫기
        $submenu.slideUp(200, function () {
          $arrow.text('▼');
        });
      } else {
        // 다른 메뉴 닫기
        $('.submenu').slideUp(200);
        $('.arrow').text('▼');

        // 현재 메뉴 열기
        $submenu.slideDown(200, function () {
          $arrow.text('▲');
        });
      }
    });
  });
</script>
