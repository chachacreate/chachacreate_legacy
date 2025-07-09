  let swiper = null;

$(() => {
	  bestProduct();
	  mainProduct();
	});
	
	function mainProduct(){
	var cpath = document.getElementById("cpath").value;
	var storeUrl = document.getElementById("storeUrl").value;
	
	// 이미지 테스트
	/*function getImageUrl(imgPath) {
    if (!imgPath) return "";
    if (imgPath.startsWith("http://") || imgPath.startsWith("https://")) {
      return imgPath;
    }
    return `${cpath}/resources/productImages/${imgPath}`;
  }*/
	
		$.ajax({
			url: cpath + "/api/"+storeUrl,
			dataType: "json",
	    		success: function (result) {
	    			var mainProducts = result.data.mainProduct;
				var wrapper = document.getElementById("main-product-wrapper");
				console.log("mainProducts" ,mainProducts);
				wrapper.innerHTML = "";
				
				 mainProducts.forEach(product => {
				  var priceText = product.price ? Number(product.price).toLocaleString() + "원" : "가격 정보 없음";
			    	  var id = product.productId;  
			    	  var link = storeUrl+"/productdetail/"+id;
			    	  
			    	  // 테스트
			    	  //var imageUrl = getImageUrl(product.pimgUrl);
			    	  
				 console.log(product);
			    	  var html = 
	    		  '<div class="swiper-slide">' +
	    		    '<div class="product-card" onclick="location.href=\'' + storeUrl + '/productdetail/' + id + '\'">' +
	    		      '<div class="product-image-box">' +
	    		        '<img src="' + cpath + product.pimgUrl + '" alt="' + product.productName + '">' +
	    		        //테스트 '<img src="' + imageUrl + '" alt="' + product.productName + '">' +
	    		      '</div>' +
	    		      '<div class="product-content">' +
	    		        '<h3>' + product.productName + '</h3>' +
	    		        '<p>' + priceText + '</p>' +
	    		        '<div class="category-badges">' +
	    		          '<span class="badge">' + (product.typeCategoryName || '') + '</span>' +
	    		          '<span class="badge">' + (product.dcategoryName || '') + '</span>' +
	    		          '<span class="badge">' + (product.ucategoryName || '') + '</span>' +
	    		        '</div>' +
	    		      '</div>' +
	    		    '</div>' +
	    		  '</div>';


	    	  wrapper.insertAdjacentHTML("beforeend", html);
	    	});


	   // Swiper 다시 초기화
	      if (swiper) swiper.destroy(true, true);

	      swiper = new Swiper(".product-swiper", {
	        slidesPerView: 3,
	        spaceBetween: 30,
	        loop: false,
	        navigation: {
	          nextEl: ".product-next",
	          prevEl: ".product-prev",
	        },
	        pagination: {
	          el: ".product-pagination",
	          clickable: true,
	        },
	        allowTouchMove: false, // 터치/드래그 비활성화
	      });
	    },
	    error: function (err) {
	      console.log("AJAX 에러:", err);
	    }
	  });
	};

	function bestProduct() {
	let cpath = document.getElementById("cpath").value;
	let storeUrl = document.getElementById("storeUrl").value;
	  $.ajax({
	    url: cpath + "/api/" + storeUrl,
	    dataType: "json",
	    success: function (result) {
	    	
	      var bestProducts = result.data.bestProduct;
	      var wrapper = document.getElementById("best-product-wrapper");
	      
	      wrapper.innerHTML = ""; // 초기화

	      bestProducts.forEach(product => {
	    	  var priceText = product.price ? Number(product.price).toLocaleString() + "원" : "가격 정보 없음";
	    	  var id = product.productId;  
	    	  var link = storeUrl+"/productdetail/"+id;
		 console.log(product);
	    	  var html = 
	    		  '<div class="swiper-slide">' +
	    		    '<div class="product-card" onclick="location.href=\'' + storeUrl + '/productdetail/' + id + '\'">' +
	    		      '<div class="product-image-box">' +
	    		        '<img src="' + cpath + product.pimgUrl + '" alt="' + product.productName + '">' +
	    		      '</div>' +
	    		      '<div class="product-content">' +
	    		        '<h3>' + product.productName + '</h3>' +
	    		        '<p>' + priceText + '</p>' +
	    		        '<div class="category-badges">' +
	    		          '<span class="badge">' + (product.typeCategoryName || '') + '</span>' +
	    		          '<span class="badge">' + (product.dcategoryName || '') + '</span>' +
	    		          '<span class="badge">' + (product.ucategoryName || '') + '</span>' +
	    		        '</div>' +
	    		      '</div>' +
	    		    '</div>' +
	    		  '</div>';


	    	  wrapper.insertAdjacentHTML("beforeend", html);
	    	});


	   // Swiper 다시 초기화
	      if (swiper) swiper.destroy(true, true);

	      swiper = new Swiper(".product-swiper", {
	        slidesPerView: 3,
	        spaceBetween: 30,
	        loop: false,
	        navigation: {
	          nextEl: ".product-next",
	          prevEl: ".product-prev",
	        },
	        pagination: {
	          el: ".product-pagination",
	          clickable: true,
	        },
	        allowTouchMove: false, // 터치/드래그 비활성화
	      });
	    },
	    error: function (err) {
	      console.log("AJAX 에러:", err);
	    }
	  });
	};