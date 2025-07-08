<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>개인 판매 정산 관리</title>
<link rel="stylesheet" href="${cpath}/resources/css/main/personal/personalSettlement.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
<script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>

<body>
	<!-- ✅ Include Header & Nav -->
	<jsp:include page="/common/header.jsp" />
	<jsp:include page="/common/main_nav.jsp" />

	<script>
     function f_makeView(dataList){
    	   //console.log(dataList);  
    	   var templateFull = "";
    	   $.each(dataList, function(index, item){
    		  
    		   var PRODUCT_NAME = item.PRODUCT_NAME;
    		   var PRODUCTDETAIL = item.PRODUCTDETAIL;
    		   var TOTALSALES = item.TOTALSALES;
    		   var ADJUSTMENTDATE = item.ADJUSTMENTDATE;
    		   var ACCOUNTNUMBER = item.ACCOUNTNUMBER;
    		   var BANKNAME = item.BANKNAME;
    		   var ACCOUNTHOLDER = item.ACCOUNTHOLDER;
    		   var ADJUSTMENTSTATUS = item.ADJUSTMENTSTATUS;
    		   var DELIVEREDSALES = item.DELIVEREDSALES;
    		   var template1 = `   
    				<div class="swiper-slide">
    					<main class="settlement-container">
    						<section class="product-info">
    							<h3>상품 정보</h3>
    							<div class="product-detail">
    	 								<div class="product-desc">
    									<p>상품명: \${PRODUCT_NAME}</p>
    									<p>설명: \${PRODUCTDETAIL}</p>
    								</div>
    							</div>
    						</section>

    						<section class="settlement-summary">
    							<h3>
    								정산관리 <span class="sub-title">| 금일 일별 매출그래프</span>
    							</h3>
    							<div class="summary-grid">
								<div class="chart-box">
									<div style="width: 100%; max-width: 800px; margin: 0 auto;">
							           <canvas id="orderSalesChart_\${PRODUCT_NAME}"></canvas>
						            </div>
                                </div> 
    								<div class="info-box info-flex">
    									<div class="info-buttons">
    										<button class="info-tab active" data-value="\${TOTALSALES}">총수익</button>
    										<button class="info-tab" data-value="\${DELIVEREDSALES}">배송완료상품
    											총수익</button>
    									</div>
    									<div class="total-amount" id="amount-display">\${TOTALSALES}
    										원</div>
    								</div>
    							</div>
    							
    						</section>
    						<section class="settlement-table">
    						<table>
    							<thead>
    								<tr>
    									<th>정산 일자</th>
    									<th>정산 금액</th>
    									<th>계좌번호</th>
    									<th>은행명</th>
    									<th>예금주명</th>
    									<th>정산상태</th>
    								</tr>
    							</thead>
    							<tbody>
    									<tr>
    										<td>\${ADJUSTMENTDATE}</td>
    										<td>\${TOTALSALES}</td>
    										<td>\${ACCOUNTNUMBER}</td>
    										<td>\${BANKNAME}</td>
    										<td>\${ACCOUNTHOLDER}</td>
    										<td>\${ADJUSTMENTSTATUS}</td>
    									</tr>
    							</tbody>
    						</table>
    					</section>
    						 
    					</main>
    				</div>
    				 
    		   `;

    		   templateFull += template1;
    	   });
		   return templateFull;
     }
     
     function makeGraph(productMap){
    	 const arr = Object.keys(productMap);
    	 
    	 $.each(arr, function(index, productName){
    		 const sellList = productMap[productName];  //[{},{}]
             const labels = sellList.map(item => item.SALEDATE);
             const salesData = sellList.map(item => item.DAILYTOTAL);
               const ctx = document.getElementById('orderSalesChart_'+productName).getContext('2d');
             
             drawGraph(ctx, labels, salesData);
    	 });
     }
     
     function drawGraph(ctx, labels, salesData){
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
     }
     
     
     
     $(function(){
    	   $.ajax({
    	      url:"${cpath}/api/main/sell/management",    // 서버에 데이터 요청   
    	      success:function(responseData){             // 서버가 반환한 responseData를 통해 콜백 함수 실행     
    	         var view = f_makeView(responseData.data.sellmanageList);  //responseData.data.sellmanageList 정산 상품 별 리스트를 받아 html 슬라이드 템플릿으로 바꿔주는 함수
    	         $("#here").html(view); //만든 html을 id가 here인 div에 넣어서 슬라이드 생성
    	         makeGraph(responseData.data.daySellmanagelistByProduct);

    	        // Swiper 슬라이드 다시 초기화
    	         new Swiper('.mySwiper', {
    	            slidesPerView : 1,
    	            spaceBetween : 30,
    	            loop : true,
    	            navigation : {
    	                nextEl : '.swiper-button-next',
    	                prevEl : '.swiper-button-prev',
    	            }
    	         });

    	        $('.swiper-slide').each(function() {
 	            const slide = $(this); 	             
 	            slide.find('.info-tab').on('click', function() {
 	                slide.find('.info-tab').removeClass('active');
 	                $(this).addClass('active');
 	                const amount = $(this).data('value');
 	                slide.find('.total-amount').text(amount + ' 원'); //(총수익, 배송완료수익 버튼 클릭 시에 data-value 값 표시)
 	            });
 	         });  
    	      }
    	   });
    	});
	</script>



	<main class="settlement-container">
		<jsp:include page="/common/main_personal_subnav.jsp" />

		<div class="swiper-container-wrapper">
			<div class="swiper mySwiper">
				<div class="swiper-wrapper" id="here">
                </div>
				<div class="swiper-button-next"></div>
				<div class="swiper-button-prev"></div>
			</div>
		</div>
	</main>

	 <footer>
    &copy; 2025 HandCraft Mall. All Rights Reserved.
  </footer>
</body>
</html>
