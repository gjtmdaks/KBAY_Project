package com.kh.kbay.mypage.service;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.kh.kbay.bid.dao.BidDao;
import com.kh.kbay.bid.model.vo.Bid;
import com.kh.kbay.board.model.vo.BoardPost;
import com.kh.kbay.item.dao.ItemDao;
import com.kh.kbay.item.model.vo.Item;
import com.kh.kbay.item.model.vo.ItemImg;
import com.kh.kbay.member.model.vo.Member;
import com.kh.kbay.mypage.dao.MypageDao;
import com.kh.kbay.mypage.model.vo.BidListDto;
import com.kh.kbay.mypage.model.vo.Faq;
import com.kh.kbay.mypage.model.vo.FaqCategory;
import com.kh.kbay.mypage.model.vo.FaqImg;
import com.kh.kbay.mypage.model.vo.ReplyListDto;
import com.kh.kbay.mypage.model.vo.SaleListDto;
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
	        
	        if(item == null) {
	            continue; 
	        }
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
	        dto.setPayStatus(item.getPayStatus());
	        result.add(dto);
	    }
	    return result;
	}

	@Override
	public List<SaleListDto> getSaleList(int userNo) {
		List<Item> saleList = md.getSaleList(userNo);
	    List<SaleListDto> result = new ArrayList<>();

	    for(Item item : saleList){

	        int itemNo = item.getItemNo();

	        // 2. 이미지
	        List<ItemImg> imgList = id.selectItemImgList(itemNo);
	        String imgUrl = imgList.isEmpty() ? "/resources/no-image.png"
	                                          : imgList.get(0).getImgUrl();

	        // 3. 입찰 수
	        int bidCount = bd.selectBidCount(itemNo);

	        // 4. 상태 변환
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

	        // 5. DTO 조립
	        SaleListDto dto = new SaleListDto();
	        dto.setItemNo(itemNo);
	        dto.setItemTitle(item.getItemTitle());
	        dto.setCurrentPrice(item.getCurrentPrice());
	        dto.setBidCount(bidCount);
	        dto.setViews(item.getViews());
	        dto.setEndTime(item.getEndTime());
	        dto.setImgUrl(imgUrl);
	        dto.setBuyerId(item.getUserNo()+""); // 필요시 join해서 userId로
	        dto.setStatusText(statusText);

	        result.add(dto);
	    }

	    return result;
	}

	@Override
	public List<WishListDto> getWishList(int userNo) {

	    List<Item> wishItems = md.getWishList(userNo); // ← item 기준으로 가져오도록 DAO 수정 필요
	    List<WishListDto> result = new ArrayList<>();

	    for(Item item : wishItems){

	        int itemNo = item.getItemNo();

	        // 1. 이미지
	        List<ItemImg> imgList = id.selectItemImgList(itemNo);
	        String imgUrl = imgList.isEmpty() ? "/resources/no-image.png"
	                                          : imgList.get(0).getImgUrl();

	        // 2. 입찰 수
	        int bidCount = bd.selectBidCount(itemNo);

	        // 3. 상태 텍스트
	        String statusText;
	        switch(item.getStatus()){
	            case "Y": statusText = "시작 전"; break;
	            case "N": statusText = "진행 중"; break;
	            case "E": statusText = "종료"; break;
	            default: statusText = "-";
	        }

	        // 4. DTO 조립
	        WishListDto dto = new WishListDto();
	        dto.setItemNo(itemNo);
	        dto.setItemTitle(item.getItemTitle());
	        dto.setCurrentPrice(item.getCurrentPrice());
	        dto.setViews(item.getViews());
	        dto.setEndTime(item.getEndTime());
	        dto.setImgUrl(imgUrl);
	        dto.setBidCount(bidCount);
	        dto.setStatus(item.getStatus());
	        dto.setStatusText(statusText);
	        dto.setPayStatus(item.getPayStatus());
	        
	        result.add(dto);
	    }

	    return result;
	}

	@Override
	public List<BoardPost> getBoardList(int userNo) {
		return md.getBoardList(userNo);
	}
	
	@Override
	public List<BoardPost> getBoardListByCategory(int userNo, Integer category){
		Map<String, Object> param = new HashMap<>();
		param.put("userNo", userNo);
		param.put("category", category);
		
	    return md.getBoardListByCategory(param);
	}

	@Override
	public List<ReplyListDto> getReplyList(int userNo) {
		return md.getReplyList(userNo);
	}

	@Override
	public List<Report> getReportList(int userNo) {
		return md.getReportList(userNo);
	}

	@Override
	public int updateUser(Member user) {
		return md.updateUser(user);
	}

	@Override
	public Member selectUserByNo(int userNo) {
		return md.selectUserByNo(userNo);
	}

	@Override
	public List<Report> getReportedList(int userNo) {
		return md.getReportedList(userNo);
	}
	
	public List<Faq> getFaqList(int userNo) {
	    return md.getFaqList(userNo);
	}

	public List<FaqCategory> getCategoryList() {
	    return md.getCategoryList();
	}

	public int insertFaq(Faq faq, List<MultipartFile> files) {

	    String savePath = "C:/upload/faq/";
	    String serverIp = "192.168.10.25:8081";
	    String webPath = "/kbay/upload/faq/";

	    File dir = new File(savePath);
	    if (!dir.exists()) dir.mkdirs();

	    // 1. FAQ 먼저 insert
	    int result = md.insertFaq(faq);

	    if(result <= 0) return 0;

	    // 2. 파일 처리
	    if(files != null) {
	        for(MultipartFile file : files) {

	            if(file.isEmpty()) continue;

	            String originName = file.getOriginalFilename();
	            String ext = originName.substring(originName.lastIndexOf("."));
	            String changeName = UUID.randomUUID().toString() + ext;

	            try {
	                file.transferTo(new File(savePath + changeName));

	                FaqImg fi = new FaqImg();
	                fi.setFaqId(faq.getFaqId()); // ★ 중요
	                fi.setOriginName(originName);
	                fi.setChangeName(changeName);
	                fi.setFilePath("http://" + serverIp + webPath + changeName);

	                md.insertFaqFile(fi);

	            } catch (IOException e) {
	                throw new RuntimeException("파일 업로드 실패");
	            }
	        }
	    }

	    return 1;
	}

	public Faq getFaqDetail(int id) {
	    return md.getFaqDetail(id);
	}

	@Override
	public List<FaqImg> getFaqFiles(int faqId) {
	    return md.selectFaqFiles(faqId);
	}
	
	@Override
    public List<BidListDto> getWonList(Map<String, Object> map) {
        // DAO에 Map을 그대로 전달합니다.
        List<BidListDto> list = md.getWonList(map);
        
        // 이미지 null 처리 등 비즈니스 로직 추가
        for(BidListDto dto : list) {
            dto.setStatusText("낙찰완료");
            if(dto.getImgUrl() == null) {
                dto.setImgUrl("/resources/images/no-image.png");
            }
        }
        return list;
    }
	


	@Override
    public List<SaleListDto> getSellerPaymentList(Map<String, Object> map) {
        return md.getSellerPaymentList(map);
    }

	@Override
	public int increaseSellerLike(int itemNo) {
	    return md.increaseSellerLike(itemNo);
	}

	@Override
	public int updatePassword(int userNo, String encPwd) {
	    Map<String, Object> map = new HashMap<>();
	    map.put("userNo", userNo);
	    map.put("encPwd", encPwd);
	    return md.updatePassword(map);
	}
}
