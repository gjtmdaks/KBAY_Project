package com.kh.kbay.config;

import org.redisson.Redisson;
import org.redisson.api.RedissonClient;
import org.redisson.config.Config;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.connection.lettuce.LettuceConnectionFactory;
import org.springframework.data.redis.core.StringRedisTemplate;

@Configuration
public class RedisConfig {

	@Bean
	public RedissonClient redissonClient() {
	    try {
	        Config config = new Config();
	        config.useSingleServer()
	              .setAddress("redis://127.0.0.1:6379");

	        return Redisson.create(config);

	    } catch (Exception e) {
	        System.out.println("🔥 Redis 없음 → 무시하고 진행");
	        return null; // 핵심
	    }
	}

    @Bean
    public RedisConnectionFactory redisConnectionFactory() {
        return new LettuceConnectionFactory("127.0.0.1", 6379);
    }

    @Bean
    public StringRedisTemplate stringRedisTemplate(RedisConnectionFactory factory) {
        return new StringRedisTemplate(factory);
    }
}
