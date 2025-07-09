<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>주문/결제</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/store/buyer/order.css" />
  <script type="text/javascript"	src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>
</head>
<body>
<%@include file="/common/header.jsp" %>
<%@include file="/common/main_nav.jsp" %>
  <div class="order-page">
    <div class="order-layout">

      <!-- 좌측: 배송지 + 주문상품 -->
      <section class="order-left">


        <!-- 배송지 -->
        <div class="block-header">
          <h2 class="block-title">배송지</h2>
          <div class="block-divider"></div>
          </div>
		<div class="order-block delivery-block">
		  <div class="delivery-info">
		    <div class="delivery-row">
		      <label for="receiverName">이름</label>
		      <input type="text" id="receiverName" name="receiverName" value="${sessionScope.loginMember.memberName}" />
		    </div>
		    <div class="delivery-row">
		      <label for="receiverPhone">연락처</label>
		      <input type="text" id="receiverPhone" name="receiverPhone" value="${sessionScope.loginMember.memberPhone}" />
		    </div>
		    <div class="delivery-row postcode-row">
		      <label for="sample6_postcode">우편번호</label>
		      <input type="text" id="sample6_postcode" name="postcode" placeholder="우편번호" readonly />
		      <input type="button" onclick="sample6_execDaumPostcode()" value="우편번호 찾기" />
		      <input type="checkbox" id="addrCheck" onclick="updateValue()"><label>기본배송지 체크</label><input type="hidden" name="checkAddrVal" id="checkAddrVal" value="0">
		    <input type="hidden" id="addrId" value="">
		    </div>
		    <div class="delivery-row">
		      <label for="sample6_address">주소</label>
		      <input type="text" id="sample6_address" name="address" placeholder="주소" readonly />
		    </div>
		    <div class="delivery-row">
		      <label for="sample6_detailAddress">상세주소</label>
		      <input type="text" id="sample6_detailAddress" name="detailAddress" placeholder="상세주소" />
		    </div>
		    <div class="delivery-row">
		      <label for="sample6_extraAddress">참고항목</label>
		      <input type="text" id="sample6_extraAddress" name="extraAddress" placeholder="참고항목" readonly />
		    </div>
		  </div>
		</div>

        <!-- 주문 상품 -->
		<div class="block-header">
		  <h2 class="block-title">주문 상품</h2>
		  <div class="block-divider"></div>
		</div>
		<div class="order-block product-block" id="productContainer">		
		</div>

      </section>

      <!-- 우측: 결제 요약 -->
      <aside class="order-summary">
        <div class="summary-title">결제 예상 금액</div>
        <div class="summary-list">
          <!-- 상품 금액 -->
			<div class="summary-item">
			  <span>상품 금액</span><span id="productTotal">0 원</span>
			</div>
			
			<!-- 배송비 -->
			<div class="summary-item">
			  <span>배송비</span><span id="deliveryFee">0 원</span>
			</div>
        </div>
			<!-- 총 결제 금액 -->
			<div class="summary-total">
			  <span>총 결제 금액</span><span class="total-price" id="finalTotal">0 원</span>
			</div>
        <button class="pay-button" id="pay-btn">결제하기</button>
      </aside>

    </div>
  </div>
  
  <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>

	//--------------기본 배송지 설정----------------
	$(document).ready(function () {
  // 기본배송지 체크박스 클릭 이벤트
  $('#addrCheck').on('click', function () {
    if ($(this).is(':checked')) {
      // 체크된 경우: 배송지 불러오기
      $.ajax({
        url: '${cpath}/api/main/mypage/order/addr',
        type: 'GET',
        success: function (data) {
          if (data.status === 200) {
            const addr = data.data;

            // 주소 입력 필드 채우기
            $('#sample6_postcode').val(addr.postNum);
            $('#sample6_address').val(addr.addressRoad);
            $('#sample6_detailAddress').val(addr.addressDetail);
            $('#sample6_extraAddress').val(addr.addressExtra);
            $('#addrId').val(addr.addressId); 

            $('#checkAddrVal').val("1");
         // 우편번호 찾기 버튼 비활성화
            $('input[type=button][onclick="sample6_execDaumPostcode()"]').prop('disabled', true);
          } else {
            alert("기본 배송지를 불러오지 못했습니다.");
          }
        },
        error: function () {
          alert("기본 배송지 불러오기 실패");
        }
      });
    } else {
      // 해제된 경우: 입력 필드 초기화
      $('#sample6_postcode').val('');
      $('#sample6_address').val('');
      $('#sample6_detailAddress').val('');
      $('#sample6_extraAddress').val('');
      $('#addrId').val('');

      $('#checkAddrVal').val("0");
   // 우편번호 찾기 버튼 활성화
      $('input[type=button][onclick="sample6_execDaumPostcode()"]').prop('disabled', false);
    }
  });
});


	//--------------------------기본배송지 체크-------------------
	function updateValue() {
	    const check = document.getElementById("addrCheck").checked;
	    document.getElementById("checkAddrVal").value = check ? "1" : "0";
	}
	
	//----------------------주소 api--------------------------
    function sample6_execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                var addr = ''; 
                var extraAddr = ''; 

                if (data.userSelectedType === 'R') {
                    addr = data.roadAddress;
                } else {
                    addr = data.jibunAddress;
                }

                if(data.userSelectedType === 'R'){
                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                        extraAddr += data.bname;
                    }
                    if(data.buildingName !== '' && data.apartment === 'Y'){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    if(extraAddr !== ''){
                        extraAddr = ' (' + extraAddr + ')';
                    }
                    document.getElementById("sample6_extraAddress").value = extraAddr;
                } else {
                    document.getElementById("sample6_extraAddress").value = '';
                }

                document.getElementById('sample6_postcode').value = data.zonecode;
                document.getElementById("sample6_address").value = addr;
                document.getElementById("sample6_detailAddress").focus();
            }
        }).open();
    }
/*     totalPrice = 0;
    finalTotal = 0;
    productName = "";
    productCount = 1;
    let products = []; */
    newAddr = false; 
    
    //--------------------------상품 등록--------------------------

  const cpath = "${pageContext.request.contextPath}";

  let products = [];
  let totalPrice = 0;
  let finalTotal = 0;
  let productName = "";
  let storeName = "";
  let productCount = 0;
  

  $(document).ready(function () {
	  const itemsJson = sessionStorage.getItem("orderItems");

	  if (!itemsJson) {
	    alert("주문할 상품이 없습니다.");
	    location.href = cpath + "/main/mypage/cart";
	    return;
	  }

	  products = JSON.parse(itemsJson);
	  console.log("parsed products:", products);

	  const $container = $('#productContainer');

	  products.forEach((item, index) => {
	    const itemTotal = item.price * item.productCnt;
	    totalPrice += itemTotal;

	    if (productName === "") {
	      productName = item.productName;
	    } else {
	      productCount++;
	    }

	    const productHtml =
	      '<div class="product-item">' +
	        '<div class="product-box">' +
	          '<img class="product-image" src="' + item.pimgUrl + '" alt="상품 이미지" />' +
	          '<div class="product-info">' +
	            '<div class="store-name">' + item.storeName + '</div>' +
	            '<div class="product-name"><strong>' + item.productName + '</strong></div>' +
	            '<div class="quantity">수량: ' + item.productCnt + '개</div>' +
	          '</div>' +
	          '<div class="price-quantity-wrapper">' +
	            '<div class="price">' + itemTotal.toLocaleString() + ' 원</div>' +
	          '</div>' +
	        '</div>' +
	      '</div>';
	    $container.append(productHtml);
	  });

	  if (productCount > 0) {
	    productName += " 외 " + productCount + "개의 상품";
	  }

	  const deliveryFee = 0;
	  finalTotal = totalPrice + deliveryFee;

	  $('#productTotal').text(`\${totalPrice.toLocaleString()} 원`);
	  $('#deliveryFee').text(`\${deliveryFee.toLocaleString()} 원`);
	  $('#finalTotal').text(`\${finalTotal.toLocaleString()} 원`);

	  console.log("배송비:", deliveryFee, "총 합계:", finalTotal);
	});


    
    //---------결제 api------------
    var IMP = window.IMP;
    IMP.init("imp85735807");
    
    if(productCount > 1){
    	productName += " 외 " + productCount + "개의 상품";
    }
    $('#pay-btn').click(function() {
        // [1] 상세주소가 입력되었는지 검사
        const detailAddress = $('#sample6_detailAddress').val().trim();
        if (detailAddress === "" || $('#sample6_postcode').val().trim() == "") {
            alert("주소를 입력해주세요.");
            $('#sample6_detailAddress').focus();
            return; // 결제 중단
        }

        // [2] 결제 진행
    	IMP.request_pay({
    		pg: 'html5_inicis',
    		pay_method: 'card',
    		merchant_uid: 'merchant_' + new Date().getTime(),

    		name: productName,
    		amount: parseInt(finalTotal),
    		buyer_email: '${sessionScope.loginMember.memberEmail}',
    		buyer_name: '${sessionScope.loginMember.memberName}',
    	}, function(rsp) {
    		console.log(rsp);
    		
    		 //결제 성공 시
    		if (rsp.success) {
    			var msg = '결제가 완료되었습니다.';
    			console.log("결제성공 ");
    			const orderInfo = {
    			        memberId: ${sessionScope.loginMember.memberId},
    			        orderDate: new Date().toISOString().slice(0, 10), // yyyy-MM-dd
    			        orderName: $('#receiverName').val(),
    			        orderPhone: $('#receiverPhone').val(),
    			        addressId: $('#addrId').val() === ""? null: $('#addrId').val(), // 새 주소 등록인 경우 null
    			        cardId: null,    // 카드 ID 관리한다면 여기 넣기
    			        orderStatus: "ORDER_OK" // or 적절한 enum 값
    			      };

    			      const addr = {
    			    	addressId: $('#addrId').val() === ""? null: $('#addrId').val(),
    			    	postNum: $('#sample6_postcode').val(),
    			        addressRoad: $('#sample6_address').val(),
    			        addressDetail: $('#sample6_detailAddress').val(),
    			        addressExtra: $('#sample6_extraAddress').val(),
    			        addressCheck: $('#checkAddrVal').val()
    			      };

    			      const detailList = [];

    			      // 상품 정보는 이전에 불러온 products 배열을 활용
    			      products.forEach(item => {
    			        detailList.push({
    			          orderId: null,
    			          productId: item.productId,
    			          orderCnt: item.productCnt,
    			          orderPrice: item.price * item.productCnt
    			        });
    			      });
					if($('#checkAddrVal').val() === 1){
					    	newAddr = true;	
					    }
    			      const orderRequestDTO = {
    			        orderInfo: orderInfo,
    			        addr: addr,
    			        detailList: detailList,
    			        newAddr: newAddr // 새 배송지 여부 선택 기준으로 변경 가능
    			      };
					  console.log(orderRequestDTO);
    			      $.ajax({
    			        type: "POST",
    			        url: '${cpath}/api/main/order',
    			        contentType: "application/json",
    			        data: JSON.stringify(orderRequestDTO),
    			        success: function(response) {
   			        	if (response?.status === 201) {
   			        	const orderid = parseInt(response.data);
    			          alert("주문이 완료되었습니다. 주문번호 : " + orderid);
    			          location.href = `${pageContext.request.contextPath}/main/order/complete/\${orderid}`; // 성공 페이지로 이동
   			        	}
    			        },
    			        error: function(xhr) {
    			          alert("서버 오류로 주문에 실패했습니다.");
    			          console.error(xhr.responseText);
    			        }
    			      });
    		} else {
    			var msg = '결제에 실패하였습니다.';
    			msg += '에러내용 : ' + rsp.error_msg;
    		}
    		alert(msg);
    	});
    	sessionStorage.removeItem("orderItems");
    });
</script>
  
</body>
</html>
