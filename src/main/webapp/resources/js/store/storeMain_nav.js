$(() => {
  loadStoreInfo();
});

function loadStoreInfo() {
  var storeUrl = document.getElementById("storeUrl").value;
  var cpath = document.getElementById("cpath").value;

  function getImageUrl(imgPath) {
    if (!imgPath) return "";
    if (imgPath.startsWith("http://") || imgPath.startsWith("https://")) {
      return imgPath;
    }
    return `${imgPath}`;
  }

  $.ajax({
    url: `${cpath}/legacy/${storeUrl}/info`,
    dataType: "json",
    success: function (result) {
      
      var logoImg = getImageUrl(result.data.storeInfoList[0].logoImg);
      var logoTag = `<img src="${logoImg}" alt="${result.storeName} 로고" style="height: 80px;">`;
	  var storeName = result.data.storeInfoList[0].storeName;
	  var nameTag = `<a id="storename" class="nav-item" href="${cpath}/${storeUrl}">${storeName}</a>`
     
      document.getElementById("nameArear").innerHTML = nameTag;
      document.getElementById("logoArear").innerHTML = logoTag;
    },
    error: function (err) {
      console.error("스토어 정보 요청 실패", err);
    }
  });
}
