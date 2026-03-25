package com.kh.kbay.config;

import java.util.Collections;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.listener.PatternTopic;
import org.springframework.data.redis.listener.RedisMessageListenerContainer;

import com.kh.kbay.common.RedisSubscriber;

import lombok.RequiredArgsConstructor;

@Configuration
@RequiredArgsConstructor
public class RedisListenerConfig {

    private final RedisSubscriber subscriber;

    @Bean
    public RedisMessageListenerContainer container(RedisConnectionFactory factory) {
        RedisMessageListenerContainer container = new RedisMessageListenerContainer();
        container.setConnectionFactory(factory);
        container.addMessageListener(
        	    subscriber,
        	    Collections.singletonList(new PatternTopic("bid-channel"))
        	);
        return container;
    }
}
