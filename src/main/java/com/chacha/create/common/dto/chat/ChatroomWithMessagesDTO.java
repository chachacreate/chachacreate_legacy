package com.chacha.create.common.dto.chat;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ChatroomWithMessagesDTO {
    private int chatroomId;
    private List<MessageDTO> messages;
}
