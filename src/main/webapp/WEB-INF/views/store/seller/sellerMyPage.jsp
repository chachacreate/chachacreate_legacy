<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>뜨락상회 판매자 메인페이지</title>
<%@ include file="/common/header.jsp"%>
<link rel="stylesheet"
	href="${cpath}/resources/css/store/seller/authmain.css">
<link rel="stylesheet"
	href="${cpath}/resources/css/store/seller/sellerMyPage.css">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script
	src="https://code.iconify.design/iconify-icon/1.0.8/iconify-icon.min.js"></script>
</head>
<body>
	<div class="wrapper">

		<div class="main-area">
			<div class="content-wrapper">
			
			<%-- ✅ 사이드바 인클루드 --%>
    		<jsp:include page="/common/store_seller_sidenav.jsp" />
    				
				<main class="content">
					<div class="content-inner">
						<!-- 주문/배송 -->
						<div class="member-box fixed-box">
							<div class="member-header">
								<div class="title-with-info">
									<h2>주문 · 배송</h2>
									<!-- <iconify-icon icon="mdi:information-outline"
											style="font-size: 18px; margin-left: 8px;">
										</iconify-icon> -->
									<div class="_1">최근 1주일 기준</div>
								</div>
							</div>
							<div class="member-body">


								<div class="frame-1034">
									<!-- 이 클래스에 flex 속성이 적용돼 있어야 합니다 -->
									<c:forEach items="${statusList}" var="statusMap">
										<a href="#" class="frame-1035 link-box">
											<div class="ellipse-1">
												<iconify-icon icon="mdi:file-document-outline"
													class="icon-inner"></iconify-icon>
											</div>
											<div class="frame-1039">
												<div class="div11">
													<c:if test="${statusMap['ORDER_STATUS']=='ORDER_OK'}">신규주문</c:if>
													<c:if test="${statusMap['ORDER_STATUS']=='CONFIRM'}">발송전</c:if>
													<c:if test="${statusMap['ORDER_STATUS']=='REFUND'}">취소요청</c:if>
													<c:if test="${statusMap['ORDER_STATUS']=='REFUND_OK'}">환불요청</c:if>
												</div>
												<div class="_1000">${statusMap["CNT"]}건</div>
											</div>
										</a>
									</c:forEach>
								</div>
							</div>
						</div>

						<!-- 정산관리 -->
						<a href="${cpath}/${storeUrl}/seller/management/settlement"
							style="text-decoration: none; color: inherit;">
							<div class="member-box scroll-box">
								<div class="member-header">
									<div class="title-with-info">
										<h2>정산관리</h2>
										<iconify-icon icon="mdi:information-outline"
											style="font-size: 18px; margin-left: 8px;"></iconify-icon>
										<div class="_1">금월 일별 매출그래프</div>
									</div>
								</div>
								<div class="member-body">
									<div class="chart-placeholder">
										<div style="width: 100%; max-width: 800px; margin: 0 auto;">
											<canvas id="orderSalesChart"></canvas>
										</div>
									</div>
								</div>
							</div>
						</a>
						<!-- 신규 리뷰관리 -->
						<a href="#" style="text-decoration: none; color: inherit;">
							<div class="member-box scroll-box">
								<div class="member-header">
									<div class="title-with-info">
										<h2>신규 리뷰관리</h2>
									</div>
								</div>
								<div class="member-body">
									<div class="review-content-row">
										<a href="${cpath}/${storeUrl}/seller/reviews"
											class="frame-1035 link-box fixed-width">
											<div class="ellipse-1">
												<iconify-icon icon="mdi:pencil-box-outline"
													class="icon-inner"></iconify-icon>
											</div>
											<div class="frame-1039">
												<div class="div11">신규리뷰</div>
												<div class="_1000">${reviewCount}건</div>
											</div>
										</a>
										<div class="reviewgraph-placeholder right-side">
											<table style="width: 80%; border-collapse: collapse;">
												<thead>
													<tr
														style="background-color: #6c734d; color: white; text-align: center;">
														<th>리뷰 작성일</th>
														<th>작성자</th>
														<th>상품명</th>														
														<th>리뷰 내용</th>
														<th>상품 등록일</th>
													</tr>
												</thead>
												<tbody>
													<c:forEach var="review" items="${reviewList}">
														<tr
															style="text-align: center; border-bottom: 1px solid #ccc;">
															<td><fmt:formatDate value="${review.REVIEW_DATE}"
																	pattern="yyyy-MM-dd" /></td>
																	
															<!-- 작성자 -->
															<td>${review.MEMBER_NAME}</td>
															
															<!-- 상품명 -->
															<td>${review.PRODUCT_NAME}</td>

															<!-- 리뷰 내용 -->
															<td style="white-space: pre-line;">${review.REVIEW_TEXT}</td>

															<!-- 상품등록일 -->
															<td><fmt:formatDate value="${review.PRODUCT_DATE}"
																	pattern="yyyy-MM-dd" /></td>

														</tr>
													</c:forEach>
												</tbody>
											</table>

										</div>
									</div>
								</div>
						</a>
					</div>
				</main>
			</div>
		</div>
	</div>
</body>
<script>
  $(document).ready(function() {
    // storeUrl은 서버에서 model로 전달되거나 hidden input으로 주입받을 수 있음
    const storeUrl = '${storeUrl}';

    $.ajax({
      url: '/create/api/' + storeUrl + '/seller/main',
      method: 'GET',
      dataType: 'json',
      success: function(response) {
        const orderSumList = response.data.orderSumList;

        const labels = orderSumList.map(item => item.saleDate);
        const salesData = orderSumList.map(item => item.total);

        const ctx = document.getElementById('orderSalesChart').getContext('2d');
        new Chart(ctx, {
          type: 'bar',
          data: {
            labels: labels,
            datasets: [{
              label: '최근 7일 매출',
              data: salesData,
              backgroundColor: 'rgba(42, 62, 52, 0.7)', // 브랜드톤 적용
              borderRadius: 6, // 막대 둥글게
              barThickness: 30
            }]
          },
          options: {
            responsive: true,
            plugins: {
              legend: {
                display: false // label 텍스트 제거 (필요 시 true)
              },
              tooltip: {
                callbacks: {
                  label: function(context) {
                    let value = context.raw;
                    return '₩ ' + value.toLocaleString(); // 통화 표시
                  }
                },
                backgroundColor: '#333',
                titleFont: { size: 14 },
                bodyFont: { size: 13 },
                padding: 10
              }
            },
            scales: {
              x: {
                grid: {
                  display: false
                },
                ticks: {
                  font: { size: 13 },
                  color: '#555'
                }
              },
              y: {
                grid: {
                  drawBorder: false,
                  color: 'rgba(0,0,0,0.05)'
                },
                ticks: {
                  beginAtZero: true,
                  callback: value => '₩' + value.toLocaleString(),
                  font: { size: 13 },
                  color: '#555'
                }
              }
            },
            animation: {
              duration: 800,
              easing: 'easeOutQuart'
            }
          }
        });

      },
      error: function(err) {
        console.error("그래프 데이터를 불러오지 못했습니다:", err);
      }
    });
  });
</script>
</html>
