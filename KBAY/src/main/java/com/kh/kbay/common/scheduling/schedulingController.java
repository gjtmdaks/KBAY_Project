package com.kh.kbay.common.scheduling;

import java.util.List;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.kh.kbay.bid.model.vo.Bid;
import com.kh.kbay.bid.service.BidService;
import com.kh.kbay.item.model.vo.Item;
import com.kh.kbay.item.service.ItemService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Component
@Slf4j
@RequiredArgsConstructor
public class schedulingController {
	
	private final ItemService is;
    private final BidService bs;
	
	@Scheduled(fixedDelay = 1000) // 1초마다
	public void updateItemStatus() {
		int updated = is.updateItemStatus();
		if (updated > 0) {
            log.info("경매 상태 변경: {}건", updated);
        }
	}
	
	@Scheduled(fixedDelay = 5000)
	public void closeAuction() {

	    List<Item> endedItems = is.findEndedItems();

	    for (Item item : endedItems) {

	        // 1️ ranking 먼저
	        bs.updateRanking(item.getItemNo());

	        // 2️ top1 다시 조회
	        Bid top1 = bs.findTopBid(item.getItemNo());

	        if (top1 != null) {
	            bs.updateBidStatus(top1.getBidNo(), "N");
	        }

	        // 3️ 처리 완료
	        is.updateEndItemStatus(item.getItemNo());
	    }
	}
}
