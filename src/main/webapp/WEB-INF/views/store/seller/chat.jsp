<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/header.jsp" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>판매자페이지 채팅방</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/store/seller/authmain.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/store/chat.css">
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="https://code.iconify.design/iconify-icon/1.0.8/iconify-icon.min.js"></script>
</head>
<body>
<div class="wrapper">
  <div class="main-area">
    <div class="content-wrapper">
      <!-- 사이드바 -->
      <%@ include file="/common/store_seller_sidenav.jsp" %>

      <!-- 메인 콘텐츠 (chat.jsp 내용) -->
      <main class="content">
        <div class="content-inner">
          
          <div class="chat-container">

            <!-- 채팅방 목록 -->
            <div class="chat-sidebar">
              <h2>채팅방</h2>
              <div class="chat-search">
                <input type="text" id='chat-search-input' placeholder="채팅방 검색">
              </div>
              <ul id="chat-room-list" class="chat-room-list">
              </ul>
            </div>

            <!-- 채팅방 내용 -->
            <div class="chat-main">
              <div class="chat-header">
                <h3></h3>
              </div>
              <div class="chat-messages">

              </div>
              <div class="chat-input">
                <input type="text" placeholder="메시지를 입력하세요">
                <button>전송</button>
              </div>
            </div>

          </div>

        </div>
      </main>

    </div>
  </div>

  <footer>&copy; 2025 뜨락상회</footer>
</div>

<script>
let socket = null;
let currentRoomId = null;

$(document).ready(function() {
	
	//---------------엔터시 전송--------------
	$(".chat-input input").on("keydown", function(e) {
	    if (e.key === "Enter") {
	        e.preventDefault();  // 기본 엔터 동작(줄바꿈 등) 방지
	        $(".chat-input button").click();  // 전송 버튼 클릭 이벤트 실행
	    }
	});

//-------------------채팅방 목록 불러오기----------------------------------
    $.ajax({
        url: '${cpath}/api/${storeUrl}/message/chatrooms',
        method: 'GET',
        success: function(response) {
            if (response.status === 200) {
                const chatrooms = response.data;
                const $list = $("#chat-room-list");
                $list.empty();

                chatrooms.forEach(room => {
                    const itemHtml = `
                        <li class="chat-room-item" data-room-id="\${room.chatroomId}" data-store-url="\${room.storeUrl}">
                            <div class="chat-room-name">\${room.memberName}</div>
                            <div class="chat-room-preview" data-room-id="\${room.chatroomId}">\${room.chattingText}</div>
                        </li>
                    `;
                    $list.append(itemHtml);
                });
            } else {
                alert("채팅방 목록을 불러오지 못했습니다.");
            }
        },
        error: function() {
            alert("서버 오류 발생");
        }
    });

 // ---------------- 채팅방 검색 기능 ----------------
    $("#chat-search-input").on("input", function() {
        const keyword = $(this).val().toLowerCase();

        $("#chat-room-list .chat-room-item").each(function() {
            const roomName = $(this).find(".chat-room-name").text().toLowerCase();
            if (roomName.includes(keyword)) {
                $(this).show();
            } else {
                $(this).hide();
            }
        });
    });
    
//-------------------------------채팅방 preview 업데이트 함수-------------------------------
	    function updateChatRoomPreview(chatroomId, text) {
	        // 현재 방의 preview 텍스트를 최신 메시지로 변경
	        console.log(text);
	        $(`.chat-room-item[data-room-id='\${chatroomId}'] .chat-room-preview`).text(text);
	    }

//------------------------채팅방 클릭 시 WebSocket 연결-------------------
    $(document).on('click', '.chat-room-item', function() {
        console.log('${sessionScope.loginMember}');
        currentRoomId = $(this).data('room-id');
        
        // ✅ 여기에 memberName 설정
        const memberName = $(this).find('.chat-room-name').text();
        $(".chat-header h3").text(memberName);

        // 기존 연결 닫기
        if (socket) {
            socket.close();
        }

        // WebSocket 연결 생성
        socket = new WebSocket('ws://localhost:9999/create/chat/chatserver?chatroomId=' + currentRoomId);

        socket.onopen = function() {
            console.log('WebSocket 연결됨: ' + currentRoomId);
            $(".chat-messages").empty(); // 이전 메시지 초기화 (선택 사항)
        };

        socket.onmessage = function(event) {
            const msg = JSON.parse(event.data);
            console.log(msg);
            const formattedDate = formatDate(msg.chattingDate);
            let messageHtml = ``;
            if(parseInt(msg.memberCheck) === 1){
	            messageHtml = `
	                <div class="message received">
	                    <p class="message-text">\${msg.chattingText}</p>
	                    <span class="message-time">\${formattedDate}</span>
	                </div>
	            `;
            }else{
                messageHtml = `
                    <div class="message sent">
                        <p class="message-text">\${msg.chattingText}</p>
                        <span class="message-time">\${formattedDate}</span>
                    </div>
                `;
            }
            const $chatMessages = $(".chat-messages");
            $chatMessages.append(messageHtml);
            $chatMessages.scrollTop($chatMessages[0].scrollHeight);  // 자동 스크롤
            updateChatRoomPreview(currentRoomId.toString(), msg.chattingText); // preview 업데이트
        };

        socket.onclose = function() {
            console.log("WebSocket 닫힘");
        };

        socket.onerror = function(error) {
            console.error("WebSocket 오류", error);
        };
    });

// --------------------메시지 전송---------------------------------------
    $(".chat-input button").on("click", function() {
        const message = $(".chat-input input").val().trim();
        if (!message || !socket || socket.readyState !== WebSocket.OPEN) {
            alert("메시지를 보낼 수 없습니다. 채팅방을 먼저 선택하세요.");
            return;
        }

        const sendData = {
            chatroomId: currentRoomId,
            chattingText: message,
            memberCheck: 0
        };
        $(".chat-input input").val('');
        const $chatMessages = $(".chat-messages");
        socket.send(JSON.stringify(sendData));
        $chatMessages.scrollTop($chatMessages[0].scrollHeight);  // 자동 스크롤
    });
    function formatDate(dateString) {
        const date = new Date(dateString);
        const pad = (n) => n.toString().padStart(2, '0');

        const year = date.getFullYear();
        const month = pad(date.getMonth() + 1); // 월은 0부터 시작
        const day = pad(date.getDate());
        const hours = pad(date.getHours());
        const minutes = pad(date.getMinutes());
        const seconds = pad(date.getSeconds());

        return `\${year}/\${month}/\${day} \${hours}:\${minutes}:\${seconds}`;
    }

});
</script>

</body>
</html>