<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>뜨락상회 판매자 상품조회</title>
<%@ include file="/common/header.jsp" %>
  <link rel="stylesheet" href="${cpath}/resources/css/store/seller/authmain.css">
  <link rel="stylesheet" href="${cpath}/resources/css/store/seller/productSelect.css">
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="https://code.iconify.design/iconify-icon/1.0.8/iconify-icon.min.js"></script>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script src="${cpath}/resources/js/seller/productList.js"></script>
<script>
  const cpath = "${cpath}";
</script>
</head>
<body>
<div class="content-wrapper">
   <%@ include file="/common/store_seller_sidenav.jsp" %>

  <div class="main-area">
    <div class="content-wrapper">

      <main class="content">
        <div class="content-inner">
		  <h2>상품조회</h2>
		
		    <div class="button-wrapper">
		      <button class="edit-button">수정</button>
		      <button class="save-button">삭제하기</button>
		    </div>
			
			<div class="flagship-count-box">
			  <span id="selectedFlagshipCount">선택된 대표 상품: 0개</span>
			</div>
		    <!-- 👇 표를 감싸는 스크롤 영역 -->
		    <div class="table-frame">
		      <table class="product-table">
		        <thead>
		          <tr>
		            <th>대표이미지</th>
		            <th>상품이름</th>
		            <th>상품가격</th>
		            <th>재고수량</th>
		            <th>대분류<br>카테고리</th>
		            <th>중분류<br>카테고리</th>
		            <th>소분류<br>카테고리</th>
		            <th>등록일</th>
		            <th>수정일</th>
		            <th>대표상품<br>(3개)</th>
		            <th>삭제하기</th>
		          </tr>
		        </thead>
		        <tbody>
		          <tbody>
					  <c:forEach var="item" items="${productList}">
					    <tr class="product-row" data-product-id="${item.productId}">
						  <td><img src="<%= request.getContextPath() %>/resources/productImages/${item.pimgUrl}" alt="대표이미지" /></td>
						  <td>${item.productName}</td>
						  <td><fmt:formatNumber value="${item.price}" type="number" />원</td>
						  <td>${item.stock}</td>
						  <td>${item.typeCategoryName}</td>
						  <td>${item.ucategoryName}</td>
						  <td>${item.dcategoryName}</td>
						  <td><fmt:formatDate value="${item.productDate}" pattern="yyyy-MM-dd" /></td>
						  <td><fmt:formatDate value="${item.lastModifiedDate}" pattern="yyyy-MM-dd" /></td>
						  <td><input type="checkbox" name="flagship" data-id="${item.productId}" <c:if test="${item.flagshipCheck == 1}">checked</c:if>/></td>
						  <td><input type="checkbox" name="delete" data-id="${item.productId}" /></td>
						</tr>
					  </c:forEach>
					</tbody>
		        </tbody>
		      </table>
		    </div>
		  </div>
      </main>
          <!-- 푸터 -->
    <footer class="site-footer">
      <div class="footer-inner">
        <p>© 2025 뜨락상회. All rights reserved.</p>
      </div>
    </footer>
    </div>
  </div>
</div>

</body>
</html>