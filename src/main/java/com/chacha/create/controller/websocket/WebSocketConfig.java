package com.chacha.create.controller.websocket;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

import lombok.extern.slf4j.Slf4j;

/**
 * WebSocket 서버 설정 클래스입니다.
 * WebSocket 핸들러 및 인터셉터를 등록하고, 지정된 URL 경로로의 WebSocket 연결을 설정합니다.
 * 
 * <p>
 * 이 설정을 통해 `/chatserver` 경로로 들어오는 WebSocket 요청을 {@link ChatHandler}로 처리하며, 
 * 핸드셰이크 과정에서 {@link HttpHandshakeInterceptor}를 통해 로그인 정보를 확인합니다.
 * </p>
 * 
 * @author
 */
@Slf4j
//@Configuration
//@EnableWebSocket
public class WebSocketConfig implements WebSocketConfigurer {

    /** WebSocket 핸드셰이크 인터셉터 (세션에서 로그인 정보 추출) */
    private final HttpHandshakeInterceptor handshakeInterceptor;

    /** WebSocket 채팅 메시지를 처리하는 핸들러 */
    private final ChatHandler chatHandler;

    /**
     * 생성자 주입을 통해 WebSocket 설정에 필요한 핸들러와 인터셉터를 주입받습니다.
     *
     * @param handshakeInterceptor WebSocket 핸드셰이크 시 세션 검사 인터셉터
     * @param chatHandler WebSocket 채팅 처리 핸들러
     */
    public WebSocketConfig(HttpHandshakeInterceptor handshakeInterceptor, ChatHandler chatHandler) {
        this.handshakeInterceptor = handshakeInterceptor;
        this.chatHandler = chatHandler;
    }

    /**
     * WebSocket 핸들러를 등록합니다.
     * <ul>
     *     <li>경로: {@code /chatserver}</li>
     *     <li>허용 오리진: 모든 도메인</li>
     *     <li>인터셉터: {@link HttpHandshakeInterceptor}</li>
     * </ul>
     *
     * @param registry WebSocket 핸들러 등록용 레지스트리
     */
    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
    	log.info("chatserver 생성");
        registry.addHandler(chatHandler, "/chat/chatserver")
                .setAllowedOrigins("*")
                .addInterceptors(handshakeInterceptor);
    }
}
