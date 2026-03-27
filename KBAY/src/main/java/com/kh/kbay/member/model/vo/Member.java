package com.kh.kbay.member.model.vo;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class Member implements UserDetails , Serializable{
	private static final long serialVersionUID = 1L;
	
	private int userNo;
	private int authority;
	private String userId;
	private String userPwd;
	private String userName;
	private String userAddress;
	private String userPhone;
	private String userEmail;
	private Date userEnrollDate;
	private char userDeleteYn;
	private String userLoginIp;
	private int likeCount;
	private int noPayCount;
	private char userStatus;

	
	public String getUserName() {
        return userName;
    }

    public int getAuthority() {
        return authority;
    }
    
    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        Collection<GrantedAuthority> authorities = new ArrayList<>();
        // int 타입을 String으로 변환하여 전달
        authorities.add(new SimpleGrantedAuthority(String.valueOf(this.authority)));
        return authorities;
    }

    @Override
    public String getPassword() {
        return this.userPwd;
    }

    @Override
    public String getUsername() {
        return this.userId;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }
}
