<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>주문/발송관리</title>
  <link rel="stylesheet" type="text/css" href="${cpath}/resources/css/admin/authMain.css">
  <link rel="stylesheet" type="text/css" href="${cpath}/resources/css/store/seller/sellerOrderManage.css">
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<div class="wrapper">
  <header>
    <div class="header-inner">
      <div class="login-bar">
        <span>관리자님 반갑습니다.</span>
        <button class="logout-btn">로그아웃</button>
      </div>
    </div>
  </header>

  <div class="main-area">
    <div class="content-wrapper">
      <nav class="sidebar">
        <ul>
          <li class="has-submenu">
            <a href="javascript:void(0);">판매자 정산 관리 ▼</a>
            <ul class="submenu">
              <li><a href="#">스토어 정산 관리</a></li>
              <li><a href="#">개인 판매자 정산 관리</a></li>
            </ul>
          </li>
          <li class="has-submenu">
            <a href="javascript:void(0);">건의/신고 관리 ▼</a>
            <ul class="submenu">
              <li><a href="#">건의사항</a></li>
              <li><a href="#">신고</a></li>
            </ul>
          </li>
          <li><a href="#">스토어 관리</a></li>
          <li><a href="#">회원 관리</a></li>
        </ul>
      </nav>

      <main class="content">
        <div class="content-inner">
          <div class="member-box">
            <div class="member-header">
              <h2>주문/발송관리</h2>
              <div class="search-box">
                <label><input type="radio" name="status" value="전체" checked> 전체</label>
                <label><input type="radio" name="status" value="신규"> 신규</label>
                <label><input type="radio" name="status" value="발송전"> 발송전</label>
                <label><input type="radio" name="status" value="환불"> 환불</label>
                <label><input type="radio" name="status" value="취소"> 취소</label>
                <label><input type="radio" name="status" value="완료"> 완료</label>
              </div>
            </div>

            <div class="table-wrapper">
              <table class="member-table">
                <thead>
                  <tr>
                    <th>처리상태</th>
                    <th>주문번호</th>
                    <th>주문자명</th>
                    <th>배송지</th>
                    <th>주문일</th>
                    <th>주문상품</th>
                    <th>상품수량</th>
                    <th>금액</th>
                  </tr>
                </thead>
                <tbody>
                  <% for (int i = 0; i < 20; i++) {
                       String[] status = {"신규","발송전","신규","환불","환불","신규","취소","취소","신규","완료","완료","신규","-","-","-","-","-","-","-","-"};
                       String[] orderer = {"김지민","김지민","이재희","안세현","안세현","차민건","차민건","최용정","최용정","천희찬","천희찬","천희찬","-","-","-","-","-","-","-","-"};
                       String[] address = {
                         "서울시 송파구 올림픽로 99 잠실엘스 아파트 128동",
                         "서울시 송파구 올림픽로 99 잠실엘스 아파트 128동",
                         "경기도 고양시 덕양구 행신동 258",
                         "서울특별시 서대문구",
                         "서울특별시 서대문구",
                         "서울특별시 중구 금호4가동 8",
                         "서울특별시 중구 금호4가동 8",
                         "경기도 청석시 동원탑빌",
                         "경기도 청석시 동원탑빌",
                         "서울특별시 노원구 동일로245길 162",
                         "서울특별시 노원구 동일로245길 162",
                         "서울특별시 노원구 동일로245길 162",
                         "-","-","-","-","-","-","-","-"
                       };
                       String[] product = {
                         "딜감귤","수제김","차선털브러쉬","최첨단칫","재혁수취락","세현떡케익","온로드자키","지민카블럭지","평가주먹간","에어작케이스","나인틴오목보드게임","맞춤개방","-","-","-","-","-","-","-","-"
                       };
                       int[] quantity = {5,1,1,3,1,2,5,1,1,1,6,1,0,0,0,0,0,0,0,0};
                       int[] price = {50000,30000,20000,5000000,99999999,50000,99999999,99999999,30000,10000,30000,2000000,0,0,0,0,0,0,0,0};
                  %>
                  <tr class="<%= i >= 10 ? "extra-row" : "" %>" <%= i >= 10 ? "style='display:none;'" : "" %> data-status="<%=status[i] %>">
                    <td class="status-label <%= status[i].equals("-") ? "대시" : status[i] %>"><%= status[i] %></td>
                    <td><%= String.format("%08d", i) %></td>
                    <td><%= orderer[i] %></td>
                   <td class="ellipsis">
					  <%= address[i].length() > 25 ? address[i].substring(0, 25) + "..." : address[i] %>
					  <% if(address[i].length() > 25) { %>
					    <button class="address-toggle-btn" data-index="<%= i %>">▼</button>
					  <% } %></td>
                    <td><%= "2025-06-" + String.format("%02d", 5 + i) %></td>
                    <td><%= product[i] %></td>
                    <td><%= quantity[i] %></td>
                    <td><%= String.format("%,d", price[i]) %></td>
                  </tr>
                  <tr class="detail-row address-detail-<%= i %>" style="display:none;">
					  <td colspan="8" class="detail-content">
					    <strong>전체 배송지:</strong> <%= address[i] %><br>
					    <strong>상품 상세:</strong> <%= product[i] %> - 수량 <%= quantity[i] %>개, 가격 <%= String.format("%,d", price[i]) %>원
					  </td>
					</tr>
                  <% } %>
                </tbody>
              </table>
            </div>
            <div class="more-button-box">
              <button id="showMoreBtn">▼ 전체 보기</button>
            </div>
          </div>
        </div>
      </main>
    </div>
  </div>

  <footer>&copy; 2025 뜨락상회</footer>
</div>

<script>
$(document).ready(function () {
  // 서브메뉴 토글
  $('.has-submenu > a').click(function () {
    $(this).next('.submenu').slideToggle(200);
  });

  // 전체보기 버튼
  $('#showMoreBtn').click(function () {
    const $this = $(this);
    if ($this.data('expanded')) {
      $('.extra-row').fadeOut();
      $this.text('▼ 전체 보기');
      $this.data('expanded', false);
    } else {
      $('.extra-row').fadeIn();
      $this.text('▲ 접기');
      $this.data('expanded', true);
    }
  });

  // 주소 토글
  $('.address-toggle-btn').click(function (e) {
    e.stopPropagation();
    const index = $(this).data('index');
    $('.address-detail-' + index).slideToggle();
  });

//상태별 필터
  $('input[name="status"]').change(function () {
    const selected = $(this).val(); // 선택된 라디오 값

    // 먼저 모든 행 숨김
    $('table.member-table tbody tr').hide();

    // 선택된 상태에 해당하는 행만 표시
    $('table.member-table tbody tr').each(function () {
      const $row = $(this);

      if ($row.hasClass('detail-row')) return;

      const status = $row.data('status');

      if (selected === "전체" || selected === status) {
        $row.show();

        // 연결된 detail-row도 보여줄 수 있도록 초기화
        const index = $row.find('.address-toggle-btn').data('index');
        $('.address-detail-' + index).hide();
      }
    });

    // extra-row도 다시 접은 상태로 초기화
    $('.extra-row').hide();
    $('#showMoreBtn').text('▼ 전체 보기').data('expanded', false);

    // 전체보기 버튼은 '전체'일 때만 보이도록
    if (selected === '전체') {
      $('#showMoreBtn').show();
    } else {
      $('#showMoreBtn').hide();
    }
  });

});
</script>

</body>
</html>