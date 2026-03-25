package com.kh.kbay.common;

import org.springframework.data.redis.connection.Message;
import org.springframework.data.redis.connection.MessageListener;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.kh.kbay.bid.model.vo.Bid;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class RedisSubscriber implements MessageListener {

    private final SimpMessagingTemplate messagingTemplate;
    private final ObjectMapper objectMapper;

    @Override
    public void onMessage(Message message, byte[] pattern) {
        try {
            String body = new String(message.getBody());
            Bid msg = objectMapper.readValue(body, Bid.class);

            messagingTemplate.convertAndSend(
                    "/topic/bid/" + msg.getItemNo(),
                    msg
            );
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
