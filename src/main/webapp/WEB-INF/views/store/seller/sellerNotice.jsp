<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<title>뜨락상회 판매자 신고 목록 페이지</title>

<%@ include file="/common/header.jsp" %>
<link rel="stylesheet" type="text/css" href="${cpath}/resources/css/admin/declarationManage.css">
<jsp:include page="/common/storeMain_nav.jsp" />
<link rel="stylesheet" href="${cpath}/resources/css/store/seller/sellerNotice.css" />
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="${cpath}/resources/js/store/store_seller_Notice.js"></script>
</head>
<body>
  <input type="hidden" id="cpath" value="${cpath}">
  <input type="hidden" id="storeUrl" value="${storeUrl}">

<div class="wrapper">
<div class="main-area">
	<div class="content-wrapper">
    <%@ include file="/common/store_seller_sidenav.jsp" %>
    <main class="content">
					<div class="content-inner">
						<div class="suggestion-box">
							<div class="search-box">
								<input type="text" id="notice-search-input"
									placeholder="조회할 제목을 입력하세요" />
								<button class="search-btn">검색</button>
							</div>

							<div class="write-area">
								<button id="write-btn">+</button>
								<div id="write-form" style="display: none;">
									<input type="text" id="new-title" placeholder="제목 입력" />
									<textarea id="new-content" placeholder="내용 입력"></textarea>
									<label class="check-label"> <input type="checkbox"
										class="notice_checkbox" /> 중요 공지사항 여부
									</label>
									<button id="submit-post">공지사항 등록</button>
								</div>
							</div>

							<h2>공지 사항</h2>

							<div class="suggestion-table">
								<table>
									<thead>
										<tr>
											<th>번호</th>
											<th>제목</th>
											<th>작성일</th>
										</tr>
									</thead>
									<tbody id="notice-body">
										<!-- JS가 동적으로 삽입 -->
									</tbody>
								</table>
							</div>

							<div id="pagination" class="pagination"></div>
						</div>
					</div>
</main></div></div>
					<footer>
    &copy; 2025 뜨락상회
</footer>
</div>
</body>
</html>