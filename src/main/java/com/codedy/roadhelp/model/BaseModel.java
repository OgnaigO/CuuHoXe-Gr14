package com.codedy.roadhelp.model;

import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.MappedSuperclass;
import javax.persistence.PrePersist;
import javax.persistence.PreUpdate;

import java.util.Date;
import java.util.LinkedHashMap;

/**
 * <p>
 * Chứa các trường hệ thống, dùng chung cho tất cả các bảng <br><br>
 * <p>
 */
@MappedSuperclass
public class BaseModel {

    //region - Define Fields -
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    //@Column(name = "created_by")
    private String createdBy;
    //@Column(name = "created_at")
    private Date createdAt;
    //@Column(name = "updated_by")
    private String updatedBy;
    //@Column(name = "updated_at")
    private Date updatedAt;

    //@Version
    private int version;
    private Boolean deleted;
    //endregion


    //region - Getter, Setter -
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(String createdBy) {
        this.createdBy = createdBy;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public String getUpdatedBy() {
        return updatedBy;
    }

    public void setUpdatedBy(String updatedBy) {
        this.updatedBy = updatedBy;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    public int getVersion() {
        return version;
    }

    public void setVersion(int version) {
        this.version = version;
    }

    public Boolean getDeleted() {
        return deleted;
    }

    public void setDeleted(Boolean deleted) {
        this.deleted = deleted;
    }
    //endregion


    //region - Relationship Helper -

    /**
     * Hàm này trả về cấu trúc nguyên thủy của entity này.<br/><br/>
     * <p>
     *
     * @return
     */

     @PrePersist
    protected void onCreate() {
        Date now = new Date();
        if (this.createdAt == null) this.createdAt = now;
        if (this.updatedAt == null) this.updatedAt = now;
        if (this.createdBy == null) this.createdBy = "Codedy";
        if (this.updatedBy == null) this.updatedBy = "Codedy";
        if (this.version == 0) this.version = 1;
        if (this.deleted == null) this.deleted = false;
    }
    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = new Date();
    }
    protected LinkedHashMap<String, Object> toHashMap() {
        LinkedHashMap<String, Object> hashMap = new LinkedHashMap<>();
        hashMap.put("id", id);
        hashMap.put("createdAt", createdAt);
        hashMap.put("createdBy", createdBy);
        hashMap.put("updatedAt", updatedAt);
        hashMap.put("updatedBy", updatedBy);
        hashMap.put("version", version);
        hashMap.put("deleted", deleted);

        return hashMap;
    }
    //endregion

}
