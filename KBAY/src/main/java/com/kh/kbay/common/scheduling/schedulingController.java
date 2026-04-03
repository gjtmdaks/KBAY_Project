package com.kh.kbay.common.scheduling;

import java.io.File;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.kh.kbay.admin.service.AdminService;
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
    private final AdminService adminService;
	
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
	
	@Scheduled(cron = "0 0 * * * *") // 1시간마다 (추천)
	public void cleanUnusedImages() {

	    String uploadPath = "C:/upload/board"; // ← 이건 반드시 설정파일로 빼는게 베스트

	    File folder = new File(uploadPath);

	    if (!folder.exists() || !folder.isDirectory()) {
	        log.warn("이미지 폴더 없음: {}", uploadPath);
	        return;
	    }

	    // 1️. DB에 있는 파일명
	    List<String> dbImages = boards.getAllImageNames();

	    // 빠른 탐색용
	    Set<String> dbSet = new HashSet<>(dbImages);

	    // 2️. 서버 파일 목록
	    File[] files = folder.listFiles();

	    if (files == null) return;

	    int deleteCount = 0;

	    for (File file : files) {

	        String fileName = file.getName();

	        // 3️. DB에 없는 파일이면 삭제
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
	
	@Scheduled(fixedDelay = 10000) // 10초마다
    public void assignPaymentDeadline() {
        int updatedCount = is.updateMissingPaymentDeadlines();
        
        if (updatedCount > 0) {
            log.info("결제 마감일 자동 세팅 완료: {}건", updatedCount);
        }
    }
	
	@Scheduled(fixedDelay = 60000) 
    public void processExpiredPayments() {
        
        // 1. 결제 마감일이 지난 아이템 번호들을 싹 다 가져옵니다.
        List<Integer> expiredItems = is.selectExpiredPaymentItems();
        
        if(expiredItems != null && !expiredItems.isEmpty()) {
            for (Integer itemNo : expiredItems) {
                try {
                    // 2. 아까 우리가 완벽하게 짜둔 차순위 승계/유찰 로직을 재활용합니다!
                    // 알아서 1등 날리고, 7일 연장하거나, 사람이 없으면 유찰('O')시켜 줍니다.
                    int result = adminService.updateForceSuccession(itemNo);
                    
                    if (result == 1) log.info("자동 승계 완료 (+7일 연장) : {}번 아이템", itemNo);
                    if (result == 2) log.info("자동 유찰 완료 (차순위 없음) : {}번 아이템", itemNo);
                    if (result == 3) log.info("자동 유찰 완료 (즉시낙찰 미결제) : {}번 아이템", itemNo);
                    
                } catch (Exception e) {
                    log.error("{}번 아이템 미결제 자동 처리 중 오류 발생", itemNo, e);
                }
            }
        }
	}
}
