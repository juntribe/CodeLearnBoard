package org.zerock.security;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Component;
import org.zerock.domain.CustomUser;
import org.zerock.domain.MemberVO;
import org.zerock.mapper.MemberMapper;

@Log4j


public class CustomUserDetailsService implements UserDetailsService {


    @Setter(onMethod_ ={@Autowired} )
    private MemberMapper memberMapper;


    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        log.warn("Load User By UserName :" + username);

        // userName means userid
        MemberVO vo = memberMapper.read(username);
        log.warn("quried by member mapper:" +vo);

        return vo == null ? null : new CustomUser(vo);
    }
}
