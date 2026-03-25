package com.kh.kbay.common;

import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class RedisPublisher {

    private final StringRedisTemplate redisTemplate;
    private final ObjectMapper objectMapper;

    public void publish(String channel, Object message) {
        try {
            redisTemplate.convertAndSend(channel,
                    objectMapper.writeValueAsString(message));
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
