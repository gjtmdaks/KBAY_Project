package com.kh.kbay.common.scheduling;

import java.io.File;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.kh.kbay.bid.model.vo.Bid;
import com.kh.kbay.bid.service.BidService;
import com.kh.kbay.board.service.BoardService;
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
    private final BoardService boards;
	
	@Scheduled(fixedDelay = 1000000) // 1초마다
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
	
	@Scheduled(cron = "0 0 * * * *") // 1시간마다 (추천)
	public void cleanUnusedImages() {

	    String uploadPath = "C:/upload/board"; // ← 이건 반드시 설정파일로 빼는게 베스트

	    File folder = new File(uploadPath);

	    if (!folder.exists() || !folder.isDirectory()) {
	        log.warn("이미지 폴더 없음: {}", uploadPath);
	        return;
	    }

	    // 1️⃣ DB에 있는 파일명
	    List<String> dbImages = boards.getAllImageNames();

	    // 빠른 탐색용
	    Set<String> dbSet = new HashSet<>(dbImages);

	    // 2️⃣ 서버 파일 목록
	    File[] files = folder.listFiles();

	    if (files == null) return;

	    int deleteCount = 0;

	    for (File file : files) {

	        String fileName = file.getName();

	        // 3️⃣ DB에 없는 파일이면 삭제
	        if (!dbSet.contains(fileName)) {

	            boolean deleted = file.delete();

	            if (deleted) {
	                deleteCount++;
	                log.info("삭제된 이미지: {}", fileName);
	            } else {
	                log.warn("삭제 실패: {}", fileName);
	            }
	        }
	    }

	    log.info("이미지 정리 완료: {}개 삭제", deleteCount);
	}
}
