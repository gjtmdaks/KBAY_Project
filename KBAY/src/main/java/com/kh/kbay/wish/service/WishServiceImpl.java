package com.kh.kbay.wish.service;

import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.kh.kbay.wish.dao.WishDao;

@Service("WishServiceImpl")
public class WishServiceImpl implements WishService {

    @Autowired
    private WishDao wd;
    
    @Override
    @Transactional
    public String toggleWishlist(Map<String, Object> map) {
        int count = wd.checkWishlist(map);
        if (count > 0) {
            wd.deleteWishlist(map);
            return "DELETE";
        } else {
            wd.insertWishlist(map);
            return "INSERT";
        }
    }
}