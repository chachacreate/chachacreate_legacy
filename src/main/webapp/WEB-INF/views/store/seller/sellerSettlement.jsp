<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>개인 판매 정산 관리</title>
<%@ include file="/common/header.jsp"%>
<link rel="stylesheet" href="${cpath}/resources/css/store/seller/storeSellerSettlement.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
<script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>	
</head>
<body>
<script>
function f_makeView(settlementList, settlementByDayList) {

    let totalSales = 0, deliveredSales = 0, adjustmentDate = '', accountNumber = '', bankName = '', accountHolder = '', adjustmentStatus = '';
    if (settlementList.length > 0) {
        adjustmentDate = settlementList[0].ADJUSTMENTDATE || '';
        accountNumber = settlementList[0].ACCOUNTNUMBER || '';
        bankName = settlementList[0].BANKNAME || '';
        accountHolder = settlementList[0].ACCOUNTHOLDER || '';
        adjustmentStatus = settlementList[0].ADJUSTMENTSTATUS || '';
    }
    settlementList.forEach(item => {
        totalSales += Number(item.TOTALSALES || 0);
        deliveredSales += Number(item.DELIVEREDSALES || 0);
    });

    let totalDaySales = {};
    Object.values(settlementByDayList).forEach(productArr => {
        productArr.forEach(row => {
            if (!totalDaySales[row.SALEDATE]) totalDaySales[row.SALEDATE] = 0;
            totalDaySales[row.SALEDATE] += Number(row.DAILYTOTAL || 0);
        });
    });
    let allDates = Object.keys(totalDaySales).sort();
    let allTotals = allDates.map(date => totalDaySales[date]);

    let templateFull = '';
    templateFull += `
        <div class="swiper-slide">
            <main class="settlement-container">
                <section class="product-info">
                    <h3>전체 상품 합계</h3>
                </section>
                <section class="settlement-summary">
                    <h3>전체 매출 합계 <span class="sub-title">| 일별 매출 합계</span></h3>
                    <div class="summary-grid">
                        <div class="chart-box">
                            <div style="width: 100%; max-width: 800px; margin: 0 auto;">
                                <canvas id="orderSalesChart_TOTAL"></canvas>
                            </div>
                        </div>
                        <div class="info-box info-flex">
                            <div class="info-buttons">
                                <button class="info-tab active" data-value="\${totalSales}">총수익</button>
                                <button class="info-tab" data-value="\${deliveredSales}">배송완료상품 총수익</button>
                            </div>
                            <div class="total-amount" id="amount-display">\${totalSales} 원</div>
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
                                <td>\${adjustmentDate}</td>
                                <td>\${totalSales}</td>
                                <td>\${accountNumber}</td>
                                <td>\${bankName}</td>
                                <td>\${accountHolder}</td>
                                <td>\${adjustmentStatus}</td>
                            </tr>
                        </tbody>
                    </table>
                </section>
            </main>
        </div>
    `;

    $.each(settlementList, function(index, item) {
        var PRODUCT_NAME = item.PRODUCT_NAME;
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
                            </div>
                        </div>
                    </section>
                    <section class="settlement-summary">
                        <h3>정산관리 <span class="sub-title">| 금일 일별 매출그래프</span></h3>
                        <div class="summary-grid">
                        <div class="chart-box">
                            <div style="width: 100%; max-width: 800px; margin: 0 auto;">
                                <canvas id="orderSalesChart_\${PRODUCT_NAME}"></canvas>
                            </div>
                        </div> 
                            <div class="info-box info-flex">
                                <div class="info-buttons">
                                    <button class="info-tab active" data-value="\${TOTALSALES}">총수익</button>
                                    <button class="info-tab" data-value="\${DELIVEREDSALES}">배송완료상품 총수익</button>
                                </div>
                                <div class="total-amount" id="amount-display">\${TOTALSALES} 원</div>
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
        templateFull += eval('`' + template1 + '`');
    });

    return templateFull;
}

function makeGraph(productMap, totalDates, totalSalesArr) {
    var ctxTotal = document.getElementById('orderSalesChart_TOTAL').getContext('2d');
    drawGraph(ctxTotal, totalDates, totalSalesArr);

    $.each(productMap, function(productName, sellList){
        const labels = sellList.map(item => item.SALEDATE);
        const salesData = sellList.map(item => item.DAILYTOTAL);
        var ctx = document.getElementById('orderSalesChart_' + productName);
        if (ctx) {
            drawGraph(ctx.getContext('2d'), labels, salesData);
        }
    });
}

function drawGraph(ctx, labels, salesData) {
    new Chart(ctx, {
        type: 'bar',
        data: {
          labels: labels,
          datasets: [{
            label: '최근 7일 매출',
            data: salesData,
            backgroundColor: 'rgba(42, 62, 52, 0.7)',
            borderRadius: 6,
            barThickness: 30
          }]
        },
        options: {
          responsive: true,
          plugins: {
            legend: { display: false },
            tooltip: {
              callbacks: {
                label: function(context) {
                  let value = context.raw;
                  return '₩ ' + value.toLocaleString();
                }
              },
              backgroundColor: '#333',
              titleFont: { size: 14 },
              bodyFont: { size: 13 },
              padding: 10
            }
          },
          scales: {
            x: { grid: { display: false }, ticks: { font: { size: 13 }, color: '#555' } },
            y: {
              grid: { drawBorder: false, color: 'rgba(0,0,0,0.05)' },
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
        url:"${cpath}/legacy/${storeUrl}/seller/management/settlement",
        success:function(responseData){
            var settlementList = responseData.data.settlementList;
            var settlementByDayList = responseData.data.settlementByDayList;

            let totalDaySales = {};
            Object.values(settlementByDayList).forEach(productArr => {
                productArr.forEach(row => {
                    if (!totalDaySales[row.SALEDATE]) totalDaySales[row.SALEDATE] = 0;
                    totalDaySales[row.SALEDATE] += Number(row.DAILYTOTAL || 0);
                });
            });
            let allDates = Object.keys(totalDaySales).sort();
            let allTotals = allDates.map(date => totalDaySales[date]);

            var view = f_makeView(settlementList, settlementByDayList);
            $("#here").html(view);
            makeGraph(settlementByDayList, allDates, allTotals);

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
                    slide.find('.total-amount').text(amount + ' 원');
                });
            });  
        }
    });
});
</script>

<div class="full-wrapper">
  <div class="left-padding"></div>

  <%@ include file="/common/store_seller_sidenav.jsp" %>

  <main class="main-layout">
    <div class="settlement-container">
      <div class="swiper-container-wrapper">
        <div class="swiper mySwiper">
          <div class="swiper-wrapper" id="here"></div>
          <div class="swiper-button-next"></div>
          <div class="swiper-button-prev"></div>
        </div>
      </div>
    </div>
  </main>

  <div class="right-padding"></div>
</div>
</body>
</html>
