package com.kh.kbay.wish.dao;

import java.util.Map;

public interface WishDao {
    int checkWishlist(Map<String, Object> map);
    int insertWishlist(Map<String, Object> map);
    int deleteWishlist(Map<String, Object> map);
}