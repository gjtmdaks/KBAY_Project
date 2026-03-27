package com.kh.kbay.mypage.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;

import com.kh.kbay.bid.dao.BidDao;
import com.kh.kbay.bid.model.vo.Bid;
import com.kh.kbay.board.model.vo.BoardPost;
import com.kh.kbay.item.dao.ItemDao;
import com.kh.kbay.item.model.vo.Item;
import com.kh.kbay.item.model.vo.ItemImg;
import com.kh.kbay.mypage.dao.MypageDao;
import com.kh.kbay.mypage.model.vo.BidListDto;
import com.kh.kbay.mypage.model.vo.ReplyListDto;
import com.kh.kbay.mypage.model.vo.WishListDto;
import com.kh.kbay.report.model.vo.Report;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class MypageServiceImpl implements MypageService {

	private final MypageDao md;
	private final ItemDao id;
	private final BidDao bd;
    
    @Override
    public int getAccidentCount(int userNo) {
        return md.selectAccidentCount(userNo);
    }

	@Override
	public List<BidListDto> getBidList(int userNo){

	    List<Bid> bidList = md.getBidList(userNo);
	    List<BidListDto> result = new ArrayList<>();

	    for(Bid b : bidList){

	        int itemNo = b.getItemNo();

	        // 1. 상품 정보
	        Item item = id.selectItemDetail(itemNo);

	        // 2. 이미지
	        List<ItemImg> imgList = id.selectItemImgList(itemNo);
	        String imgUrl = imgList.isEmpty() ? "/resources/no-image.png"
	                                          : imgList.get(0).getImgUrl();

	        // 3. 입찰 수
	        int bidCount = bd.selectBidCount(itemNo);

	        // 4. 최고 입찰자
	        Bid topBid = bd.findTopBid(itemNo);

	        // 5. 상태 변환
	        String statusText;

	        switch(item.getStatus()){
	            case "Y":
	                statusText = "시작 전";
	                break;
	            case "N":
	                statusText = "진행 중";
	                break;
	            case "E":
	                statusText = "종료";
	                break;
	            default:
	                statusText = "-";
	        }

	        // 6. 순위 판단
	        String rankingText = "차순위입찰자";
	        if(topBid != null && topBid.getUserNo() == userNo){
	            rankingText = "최고입찰자";
	        }

	        // 7. DTO 조립
	        BidListDto dto = new BidListDto();
	        dto.setItemNo(itemNo);
	        dto.setItemTitle(item.getItemTitle());
	        dto.setCurrentPrice(item.getCurrentPrice());
	        dto.setBidPrice(b.getBidPrice());
	        dto.setStatus(item.getStatus());
	        dto.setStatusText(statusText);
	        dto.setBidCount(bidCount);
	        dto.setViews(item.getViews());
	        dto.setEndTime(item.getEndTime());
	        dto.setSellerId(item.getUserNo()+""); // 필요시 join해서 userId로
	        dto.setImgUrl(imgUrl);
	        dto.setRankingText(rankingText);

	        result.add(dto);
	    }

	    return result;
	}

	@Override
	public List<Item> getSaleList(int userNo) {
		return md.getSaleList(userNo);
	}

	@Override
	public List<WishListDto> getWishList(int userNo) {
		return md.getWishList(userNo);
	}

	@Override
	public List<BoardPost> getBoardList(int userNo) {
		return md.getBoardList(userNo);
	}

	@Override
	public List<ReplyListDto> getReplyList(int userNo) {
		return md.getReplyList(userNo);
	}

	@Override
	public List<Report> getReportList(int userNo) {
		return md.getReportList(userNo);
	}

}
