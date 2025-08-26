<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/header.jsp"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>건의사항</title>
  <link rel="stylesheet" href="${cpath}/resources/css/main/mainNotice.css" />
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>

  <!-- ✅ Include Header & Nav -->
<jsp:include page="/common/main_nav.jsp" />

<main class="notice-container">
  <h2>건의사항</h2>

  <div class="search-box">
    <input type="text" id="search-keyword" placeholder="검색어를 입력하세요">
    <button class="search-btn">검색</button>
  </div>

  <div class="write-area">
    <button id="write-btn">+</button>
    <div id="write-form" style="display: none;">
      <input type="text" id="new-title" placeholder="제목 입력">
      <textarea id="new-content" placeholder="내용 입력"></textarea>
      <button id="submit-post">건의 등록</button>
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

  <!-- ✅ 푸터 -->
  <footer>
    &copy; 2025 HandCraft Mall. All Rights Reserved.
  </footer>

<script>
  const pageSize = 5;
  let allData = [];

//검색 버튼 클릭 시 제목 필터링
  $(".search-btn").on("click", function () {
    const keyword = $(".search-box input").val().toLowerCase().trim();

    const filteredData = allData.filter(item =>
      item.questionTitle.toLowerCase().includes(keyword)
    );

    if (filteredData.length === 0) {
      $("#notice-body").html(`<tr><td colspan="2">검색 결과가 없습니다.</td></tr>`);
      $("#pagination").empty();
    } else {
      renderFilteredTable(filteredData, 1);
      renderFilteredPagination(filteredData);
    }
  });

  // 필터된 테이블 렌더링
  function renderFilteredTable(data, pageIndex = 1) {
    const start = (pageIndex - 1) * pageSize;
    const end = start + pageSize;
    const pageData = data.slice(start, end);

    const tbody = $("#notice-body");
    tbody.empty();

    pageData.forEach(item => {
      tbody.append(`
        <tr class="accordion">
          <td>\${item.questionId}</td>
          <td class="question">\${item.questionTitle}</td>
        </tr>
        <tr class="answer-row">
          <td colspan="2" class="answer">\${item.questionText}</td>
        </tr>
      `);
    });

    $(".answer-row").hide();
    $(".accordion").off("click").on("click", function () {
      $(this).next(".answer-row").slideToggle();
    });
  }

  // 필터된 페이지네이션
  function renderFilteredPagination(filteredData) {
    const totalPage = Math.ceil(filteredData.length / pageSize);
    const pg = $("#pagination");
    pg.empty();

    for (let i = 1; i <= totalPage; i++) {
      pg.append('<a data-page="' + i + '" class="' + (i === 1 ? 'active' : '') + '">' + i + '</a>');
    }

    $(".pagination a").off("click").on("click", function () {
      $(".pagination a").removeClass("active");
      $(this).addClass("active");
      const pageIndex = parseInt($(this).data("page"));
      renderFilteredTable(filteredData, pageIndex);
    });
  }
  $(function () {
    // 건의사항 데이터 요청
    $.ajax({
      url: "${cpath}/legacy/main/question",
      method: "GET",
      contentType: 'application/json',
      success: function (res) {
        if (res.status === 200 && res.data) {
          allData = res.data;
          renderFilteredTable(item = allData);
          renderPagination();
          renderTable(1);
        } else {
          alert("데이터를 불러오지 못했습니다.");
        }
      },
      error: function () {
        alert("서버 요청 실패");
      }
    });

    // 글쓰기 폼 toggle
    $("#write-btn").click(() => $("#write-form").slideToggle());

    // 작성 버튼 클릭 시 처리
    $("#submit-post").click(() => {
		if(${loginMember == null}){
			alert("로그인이 필요합니다!");
			return;
		}
		 const title = $("#new-title").val().trim();
		 const content = $("#new-content").val().trim();
		
		 if (title === "") {
		   alert("제목을 입력해주세요");
		   $("#new-title").focus();
		   return;
		 }
		
		 if (content === "") {
		   alert("내용을 입력해주세요");
		   $("#new-content").focus();
		   return;
		 }
	
	   	  $.ajax({
	   	    url: "${cpath}/legacy/main/question",
	   	    method: "POST",
	   	    contentType: 'application/json',
	   	    data: JSON.stringify({
	   	      questionTitle: title,
	   	      questionText: content
	   	    }),
	   	    success: function (res) {
	   	      if (res.status === 201 && res.data) {
	   	        alert("작성 완료");
	   	        location.reload(); // 또는 새로 렌더링
	   	      } else {
	   	        alert("데이터 등록 실패");
	   	      }
	   	    },
	   	    error: function (xhr) {
	   	      alert("서버 요청 실패: " + xhr.responseText);
	   	    }
	   	  });
  });
});
</script>


</body>
</html>