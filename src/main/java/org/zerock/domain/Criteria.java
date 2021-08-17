package org.zerock.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.springframework.web.util.UriComponentsBuilder;

@Getter
@Setter
@ToString
public class Criteria {

    private int pageNum;
    private int amount;
    private  String type;
    private String keyword;

    public Criteria() {
        this(1,10);
    }

    public Criteria(int pageNum, int amount) {
        this.pageNum = pageNum;
        this.amount = amount;
    }
    // 검색조건을 배열로 만들어서 한번에 처리하기 위함
    public String[] getTypeArr(){
        return type == null ? new String[] {}: type.split("");
    }
    // 여러 개의 파라미터들을 연결해서 URL의 형태로 만들어 주는 기능
//    public String getListLink(){
//        UriComponentsBuilder builder = UriComponentsBuilder.fromPath("")
//                .queryParam("pageNum", this.pageNum)
//                .queryParam("amount",this.getAmount())
//                .queryParam("type",this.getType())
//                .queryParam("keyword",this.getKeyword());
//        return builder.toUriString();
//    }

    public String getListLink(){
        UriComponentsBuilder builder = UriComponentsBuilder.fromPath("")
        .queryParam("pageNum", this.pageNum)
        .queryParam("amount",this.getAmount())
        .queryParam("type",this.getType())
        .queryParam("keyword",this.getKeyword());
        return builder.toUriString();

    }
}
