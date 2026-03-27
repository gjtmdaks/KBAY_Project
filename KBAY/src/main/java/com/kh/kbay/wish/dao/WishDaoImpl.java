package com.kh.kbay.wish.dao;

import java.util.Map;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Repository
@Slf4j
@RequiredArgsConstructor
public class WishDaoImpl implements WishDao {

    private final SqlSessionTemplate session;


    @Override
    public int checkWishlist(Map<String, Object> map) {
        return session.selectOne("wish.checkWishlist", map);
    }

    @Override
    public int insertWishlist(Map<String, Object> map) {
        return session.insert("wish.insertWishlist", map);
    }

    @Override
    public int deleteWishlist(Map<String, Object> map) {
        return session.delete("wish.deleteWishlist", map);
    }
}