<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/header.jsp"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>공지 / 소식</title>
  <link rel="stylesheet" href="${cpath}/resources/css/main/mainNotice.css" />
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>

  <!-- ✅ Include Header & Nav -->
<jsp:include page="/common/main_nav.jsp" />

<main class="notice-container">
  <h2>공지사항</h2>

  <div class="search-box">
    <input type="text" placeholder="검색어를 입력하세요">
    <button class="search-btn">검색</button>
  </div>

  <div class="write-area">
    <button id="write-btn">+</button>
    <div id="write-form" style="display: none;">
      <input type="text" id="new-title" placeholder="제목 입력">
      <textarea id="new-content" placeholder="내용 입력"></textarea>
      <button id="submit-post">공지 등록</button>
    </div>
  </div>

  <table class="notice-table">
    <thead>
      <tr><th>No.</th><th>제목</th></tr>
    </thead>
    <tbody id="notice-body">
      <!-- JS로 내용 동적으로 삽입 -->
    </tbody>
  </table>

  <div class="pagination" id="pagination">
    <!-- JS로 페이지 번호 자동 생성 -->
  </div>
</main>

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

<script>
  const noticeData = {
    page_1: [
      {no: 1, title: "공지 제목 1", content: "1번 공지의 내용입니다."},
      {no: 2, title: "공지 제목 2", content: "2번 공지의 내용입니다."},
      {no: 3, title: "공지 제목 3", content: "3번 공지의 내용입니다."},
      {no: 4, title: "공지 제목 4", content: "4번 공지의 내용입니다."},
      {no: 5, title: "공지 제목 5", content: "5번 공지의 내용입니다."},
      {no: 6, title: "공지 제목 6", content: "6번 공지의 내용입니다."},
      {no: 7, title: "공지 제목 7", content: "7번 공지의 내용입니다."},
      {no: 8, title: "공지 제목 8", content: "8번 공지의 내용입니다."},
      {no: 9, title: "공지 제목 9", content: "9번 공지의 내용입니다."},
      {no: 10, title: "공지 제목 10", content: "10번 공지의 내용입니다."}
    ],
    page_2: [
      {no: 11, title: "공지 제목 11", content: "11번 공지의 내용입니다."},
      {no: 12, title: "공지 제목 12", content: "12번 공지의 내용입니다."}
    ]
  };

  function renderTable(page = "page_1") {
    const tbody = $("#notice-body");
    tbody.empty();
    noticeData[page].forEach(item => {
      tbody.append(`
        <tr class="accordion">
          <td>${item.no}</td>
          <td class="question">${item.title}</td>
        </tr>
        <tr class="answer-row">
          <td colspan="2" class="answer">${item.content}</td>
        </tr>
      `);
    });

    $(".answer-row").hide();
    $(".accordion").click(function () {
      $(this).next(".answer-row").slideToggle();
    });
  }

  function renderPagination(total = 2) {
    const pg = $("#pagination");
    pg.empty();
    for (let i = 1; i <= total; i++) {
      pg.append(`<a data-page="page_${i}" class="${i == 1 ? 'active' : ''}">${i}</a>`);
    }
    $(".pagination a").click(function () {
      $(".pagination a").removeClass("active");
      $(this).addClass("active");
      renderTable($(this).data("page"));
    });
  }

  $(function () {
    renderTable();
    renderPagination();
    $("#write-btn").click(() => $("#write-form").slideToggle());
    $("#submit-post").click(() => {
      alert("작성 완료 (Ajax 연동 필요)");
      $("#new-title").val('');
      $("#new-content").val('');
      $("#write-form").slideUp();
    });
  });
</script>

</body>
</html>
