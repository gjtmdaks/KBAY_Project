package com.kh.kbay.common.scheduling;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.kh.kbay.item.service.ItemService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Component
@Slf4j
@RequiredArgsConstructor
public class schedulingController {
	
	private final ItemService is;
	
	@Scheduled(fixedDelay = 1000) // 1초마다
	public void updateItemStatus() {
		int updated = is.updateItemStatus();
		if (updated > 0) {
            log.info("경매 상태 변경: {}건", updated);
        }
	}
}
