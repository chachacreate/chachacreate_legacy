<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>채팅방</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/store/chat.css">
  <script src="https://code.iconify.design/iconify-icon/1.0.8/iconify-icon.min.js"></script>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<%@ include file="/common/header.jsp" %>
 <!-- ✅ storeUrl 기반 동적 네비게이션 -->
    <c:choose>
      <c:when test="${empty storeUrl}">
        <jsp:include page="/common/main_nav.jsp" />
      </c:when>
      <c:otherwise>
        <jsp:include page="/common/storeMain_nav.jsp" />
      </c:otherwise>
    </c:choose>
<div class="wrapper">

  <div class="main-area">
    <div class="content-wrapper">
      
     <%@ include file="/common/main_mypage_sidenav.jsp" %>

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
                <h3>채팅방을 선택하세요</h3>
              </div>
              <div class="chat-messages">
                <div class="no-chat-selected">
                  채팅방을 선택하여 대화를 시작하세요.
                </div>
              </div>
              <div class="chat-input">
                <input type="text" placeholder="메시지를 입력하세요" disabled>
                <button disabled>전송</button>
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
let currentUser = null;

$(document).ready(function() {
    // 현재 로그인한 사용자 정보 설정
    currentUser = {
        id: ${sessionScope.loginMember.memberId},
        name: '${sessionScope.loginMember.memberName}',
        email: '${sessionScope.loginMember.memberEmail}'
    };

    // 엔터키로 메시지 전송
    $(".chat-input input").on("keydown", function(e) {
        if (e.key === "Enter") {
            e.preventDefault();
            $(".chat-input button").click();
        }
    });

    // 스토어 URL 기반 자동 채팅방 생성 (기존 로직 유지)
    let storeUrl = '${storeUrl}';

    // 채팅방 목록 로드
    loadChatRooms();

    // 채팅방 검색 기능
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

    // 채팅방 클릭 시 WebSocket 연결
    $(document).on('click', '.chat-room-item', function() {
        const chatroomId = $(this).data('room-id');
        const roomName = $(this).find('.chat-room-name').text();
        connectToChatRoom(chatroomId, roomName);
        
        // 활성 채팅방 표시
        $('.chat-room-item').removeClass('active');
        $(this).addClass('active');
    });

    // 메시지 전송
    $(".chat-input button").on("click", function() {
        sendMessage();
    });
});

// MongoDB 채팅방 목록 로드
function loadChatRooms() {
    if(!currentUser || !currentUser.id) {
        console.error("사용자 정보가 없습니다.");
        return;
    }

    $.ajax({
        url: '${cpath}/api/chat/rooms/' + currentUser.id,
        method: 'GET',
        success: function(response) {
            console.log('API Response:', response); // 디버깅을 위한 로그
            
            // ApiResponse 구조에서 실제 데이터 추출
            const chatrooms = response.data || response;
            
            const $list = $("#chat-room-list");
            $list.empty();

            // chatrooms가 배열인지 확인
            if(!Array.isArray(chatrooms)) {
                console.error('Expected array but got:', typeof chatrooms, chatrooms);
                $list.append('<li class="no-chatrooms">채팅방 데이터 형식 오류</li>');
                return;
            }

            if(chatrooms.length === 0) {
                $list.append('<li class="no-chatrooms">채팅방이 없습니다.</li>');
                return;
            }

            chatrooms.forEach(room => {
                const partnerName = getPartnerName(room);
                const lastMessage = room.lastMessage || '새 채팅방';
                
                // 백슬래시 제거하고 올바른 템플릿 리터럴 사용
                const itemHtml = `
                    <li class="chat-room-item" data-room-id="\${room.chatroomId}">
                        <div class="chat-room-name">\${partnerName}</div>
                        <div class="chat-room-preview" data-room-id="\${room.chatroomId}">\${lastMessage}</div>
                    </li>
                `;
                $list.append(itemHtml);
            });
        },
        error: function(xhr, status, error) {
            console.error('AJAX Error:', {xhr, status, error});
            alert("채팅방 목록을 불러오지 못했습니다.");
        }
    });
}
// 상대방 이름 추출 (나를 제외한 다른 사용자)
function getPartnerName(room) {
    console.log('Room object:', room); // 디버깅용
    
    if(room.chatroomId && room.chatroomId.startsWith('admin_')) {
        return '관리자';
    }
    
    // memberNames 배열에서 현재 사용자가 아닌 다른 사용자 찾기
    if(room.memberNames && Array.isArray(room.memberNames)) {
        const partner = room.memberNames.find(name => name !== currentUser.name);
        return partner || '알 수 없는 사용자';
    }
    
    // 다른 구조일 경우 대비
    if(room.storeName) {
        return room.storeName;
    }
    
    if(room.roomName) {
        return room.roomName;
    }
    
    return '채팅방';
}

//Base64 인코딩/디코딩 유틸리티 함수
function encodeBase64(str) {
    return btoa(unescape(encodeURIComponent(str)));
}

function decodeBase64(str) {
    return decodeURIComponent(escape(atob(str)));
}

// WebSocket 연결
function connectToChatRoom(chatroomId, roomName) {
    currentRoomId = chatroomId;
    
    // 기존 연결 닫기
    if (socket) {
        socket.close();
    }

    // 채팅방 헤더 업데이트
    $(".chat-header h3").text(roomName);
    $(".no-chat-selected").hide();
    $(".chat-input input").prop('disabled', false);
    $(".chat-input button").prop('disabled', false);

    // 채팅방 ID URL 인코딩 (한글 이름 처리)
    const encodedChatroomId = encodeBase64(chatroomId);
    
    // WebSocket URL 생성 (포트 번호 포함)
    const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
    const host = window.location.hostname;
    const contextPath = '${pageContext.request.contextPath}' || '';
    
    const wsUrl = protocol + '//' + host + contextPath + '/ws/chat/' + encodedChatroomId;
    
    console.log('WebSocket URL:', wsUrl); // 디버깅용
    
    socket = new WebSocket(wsUrl);

    socket.onopen = function() {
        console.log('WebSocket 연결됨: ' + chatroomId);
        $(".chat-messages").empty();
        
        // 연결 성공 시 채팅 히스토리 로드
        loadChatHistory(chatroomId);
    };

    socket.onmessage = function(event) {
        try {
            const message = JSON.parse(event.data);
            displayMessage(message);
            updateChatRoomPreview(chatroomId, message.message);
        } catch (e) {
            console.error('메시지 파싱 오류:', e);
        }
    };

    socket.onclose = function(event) {
        console.log("WebSocket 닫힘:", event.code, event.reason);
        if (event.code !== 1000) { // 정상 종료가 아닌 경우
            console.warn("WebSocket 비정상 종료");
        }
    };

    socket.onerror = function(error) {
        console.error("WebSocket 오류:", error);
        alert("채팅방 연결에 실패했습니다. 다시 시도해주세요.");
        
        // 입력 필드 비활성화
        $(".chat-input input").prop('disabled', true);
        $(".chat-input button").prop('disabled', true);
    };
}

// 채팅 히스토리 로드
function loadChatHistory(chatroomId) {
    $.ajax({
        url: '${cpath}/api/chat/history/' + encodeBase64(chatroomId),
        method: 'GET',
        success: function(response) {
            const history = response.data || response;
            
            if (Array.isArray(history) && history.length > 0) {
                const $chatMessages = $(".chat-messages");
                $chatMessages.empty();
                
                history.forEach(message => {
                    displayMessage(message);
                });
                
                // 스크롤을 맨 아래로
                $chatMessages.scrollTop($chatMessages[0].scrollHeight);
            }
        },
        error: function(xhr, status, error) {
            console.error('채팅 히스토리 로드 오류:', {xhr, status, error});
            // 히스토리 로드 실패는 치명적이지 않으므로 alert 하지 않음
        }
    });
}
// 메시지 전송
function sendMessage() {
    const messageText = $(".chat-input input").val().trim();
    if (!messageText) {
        return; // 빈 메시지는 전송하지 않음
    }
    
    if (!socket || socket.readyState !== WebSocket.OPEN) {
        alert("채팅방 연결이 끊어졌습니다. 페이지를 새로고침 해주세요.");
        return;
    }

    const sendData = {
        senderId: currentUser.id,
        senderName: currentUser.name,
        message: messageText,
        type: getCurrentChatType(),
        chatroomId: currentRoomId // 채팅방 ID 추가
    };

    try {
        socket.send(JSON.stringify(sendData));
        $(".chat-input input").val('');
    } catch (error) {
        console.error('메시지 전송 오류:', error);
        alert("메시지 전송에 실패했습니다.");
    }
}

//메시지 화면에 표시
function displayMessage(message) {
    const formattedDate = formatDate(message.sendAt);
    const isMyMessage = parseInt(message.senderId) === currentUser.id;
    const isAdminMessage = message.type === 'ADMIN' && message.senderName === '관리자';
    
    let messageClass = 'message ';
    if(isAdminMessage) {
        messageClass += 'admin';
    } else if(isMyMessage) {
        messageClass += 'sent';
    } else {
        messageClass += 'received';
    }
    
    const messageHtml = `
        <div class="\${messageClass}">
            <p class="message-text">\${message.message}</p>
            <span class="message-time">\${formattedDate}</span>
        </div>
    `;
    
    const $chatMessages = $(".chat-messages");
    $chatMessages.append(messageHtml);
    $chatMessages.scrollTop($chatMessages[0].scrollHeight);
}

// 현재 채팅 타입 판별
function getCurrentChatType() {
    if(currentRoomId.startsWith('personal_')) return 'PERSONAL';
    if(currentRoomId.startsWith('admin_')) return 'ADMIN';
    return 'PERSONAL';
}

// 채팅방 미리보기 업데이트
function updateChatRoomPreview(chatroomId, text) {
    $(`.chat-room-item[data-room-id='\${chatroomId}'] .chat-room-preview`).text(text);
}

// 날짜 포맷팅 (기존 로직과 동일)
function formatDate(dateString) {
    const date = new Date(dateString);
    const pad = (n) => n.toString().padStart(2, '0');

    const year = date.getFullYear();
    const month = pad(date.getMonth() + 1);
    const day = pad(date.getDate());
    const hours = pad(date.getHours());
    const minutes = pad(date.getMinutes());
    const seconds = pad(date.getSeconds());

    return `\${year}/\${month}/\${day} \${hours}:\${minutes}:\${seconds}`;
}
</script>

</body>
</html>