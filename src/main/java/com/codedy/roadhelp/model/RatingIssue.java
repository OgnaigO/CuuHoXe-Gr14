package com.codedy.roadhelp.model;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import java.io.Serializable;
import java.util.LinkedHashMap;

@Entity
@Table(name = "ratingissues")
//@JsonIdentityInfo(scope = Authority.class, generator = ObjectIdGenerators.PropertyGenerator.class, property = "id")
public class RatingIssue extends BaseModel implements Serializable {

    //region - Define Fields -
    @NotNull
    private int ratePoint;

    @Size(max = 256)
    private String comment;
    //endregion


    //region - Relationship -
    @OneToOne
    @JoinColumn(name = "issue_id")
    private Issue issue;

    @ManyToOne
    @JoinColumn(name = "user_member_id")
    private User userMember;
    //endregion


    //region - Getter & Setter -
    public int getRatePoint() {
        return ratePoint;
    }

    public void setRatePoint(int ratePoint) {
        this.ratePoint = ratePoint;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Issue getIssue() {
        return issue;
    }

    public void setIssue(Issue issue) {
        this.issue = issue;
    }

    public User getUserMember() {
        return userMember;
    }

    public void setUserMember(User userMember) {
        this.userMember = userMember;
    }
    //endregion


    //region - Relationship Helper -

    /**
     * Hàm này trả về cấu trúc nguyên thủy của entity này.<br/><br/>
     * <p>
     *
     * @return
     */
    protected LinkedHashMap<String, Object> toHashMap() {
        LinkedHashMap<String, Object> hashMap = super.toHashMap();

        hashMap.put("issueId", issue != null ? issue.getId() : null);
        hashMap.put("userMemberId", userMember != null ? userMember.getId() : null);

        hashMap.put("ratePoint", ratePoint);
        hashMap.put("comment", comment);

        return hashMap;
    }

    /**
     * Hàm này trả về định dạng hiển thị dữ liệu API cho entity này.<br/><br/>
     * <p>
     *
     * @return
     */
    public LinkedHashMap<String, Object> toApiResponse() {
        LinkedHashMap<String, Object> hashMap = this.toHashMap();

        hashMap.remove("issueId");
        hashMap.remove("userMemberId");

        hashMap.put("issue", getIssueHashMap());
        hashMap.put("userMember", getUserMemberHashMap());

        return hashMap;
    }

    //@JsonProperty("issue")
    private LinkedHashMap<String, Object> getIssueHashMap() {
        return issue != null ? issue.toHashMap() : null;
    }

    //@JsonProperty("userMember")
    private LinkedHashMap<String, Object> getUserMemberHashMap() {
        return userMember != null ? userMember.toHashMap() : null;
    }
    //endregion

}
