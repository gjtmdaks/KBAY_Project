package com.kh.kbay.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.AsyncConfigurerSupport;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;
import java.util.concurrent.Executor;

@Configuration
@EnableAsync 
public class AsyncConfig extends AsyncConfigurerSupport {

    @Override
    public Executor getAsyncExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(5);      // 기본 쓰레드 수
        executor.setMaxPoolSize(10);     // 최대 쓰레드 수
        executor.setQueueCapacity(500);  // 대기 큐 사이즈
        executor.setThreadNamePrefix("KbayMail-");
        executor.initialize();
        return executor;
    }
}