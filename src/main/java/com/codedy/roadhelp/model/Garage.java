package com.codedy.roadhelp.model;

import javax.persistence.*;
import javax.validation.constraints.Size;
import java.io.Serializable;
import java.util.LinkedHashMap;
import java.util.List;

@Entity
@Table(name = "garage")
//@JsonIdentityInfo(scope = Authority.class, generator = ObjectIdGenerators.PropertyGenerator.class, property = "id")
public class Garage extends BaseModel implements Serializable {

    //region - Define Fields -
    @Size(min = 2, max = 64)
    private String name;

    @Size(max = 128)
    private String address;

    @Size(min = 10)
    private String phone;

    private double rateAvg;

    private double longitude;

    private double latitude;

    @Size(max = 500)
    private String description;

    private Boolean active;

    private Boolean isFeatured;
    //endregion


    //region - Relationship -
    @ManyToOne
    @JoinColumn(name = "user_partner_id") //updatable = false, insertable = false
    private User userPartner;

    @OneToMany(mappedBy = "garage", cascade = {CascadeType.PERSIST, CascadeType.MERGE, CascadeType.DETACH, CascadeType.REFRESH})
    private List<GarageImage> garageImages;

    @OneToMany(mappedBy = "garage", cascade = {CascadeType.PERSIST, CascadeType.MERGE, CascadeType.DETACH, CascadeType.REFRESH})
    private List<RatingGarage> ratingGarages;

    @ManyToOne
    @JoinColumn(name = "province_id") //updatable = false, insertable = false
    private Province province;

    @ManyToOne
    @JoinColumn(name = "district_id") //updatable = false, insertable = false
    private District district;

    @ManyToOne
    @JoinColumn(name = "ward_id") //updatable = false, insertable = false
    private Ward ward;
    //endregion


    //region - Getter & Setter -
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public double getRateAvg() {
        return rateAvg;
    }

    public void setRateAvg(double rateAvg) {
        this.rateAvg = rateAvg;
    }

    public double getLongitude() {
        return longitude;
    }

    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }

    public double getLatitude() {
        return latitude;
    }

    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Boolean getActive() {
        return active;
    }

    public void setActive(Boolean active) {
        this.active = active;
    }

    public Boolean getFeatured() {
        return isFeatured;
    }

    public void setFeatured(Boolean featured) {
        isFeatured = featured;
    }

    public User getUserPartner() {
        return userPartner;
    }

    public void setUserPartner(User userPartner) {
        this.userPartner = userPartner;
    }

    public List<GarageImage> getGarageImages() {
        return garageImages;
    }

    public void setGarageImages(List<GarageImage> garageImages) {
        this.garageImages = garageImages;
    }

    public List<RatingGarage> getRatingGarages() {
        return ratingGarages;
    }

    public void setRatingGarages(List<RatingGarage> ratingGarages) {
        this.ratingGarages = ratingGarages;
    }

    public Province getProvince() {
        return province;
    }

    public void setProvince(Province province) {
        this.province = province;
    }

    public District getDistrict() {
        return district;
    }

    public void setDistrict(District district) {
        this.district = district;
    }

    public Ward getWard() {
        return ward;
    }

    public void setWard(Ward ward) {
        this.ward = ward;
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

        hashMap.put("userPartnerId", userPartner != null ? userPartner.getId() : null);
        hashMap.put("provinceId", province != null ? province.getId() : null);
        hashMap.put("districtId", district != null ? district.getId() : null);
        hashMap.put("wardId", ward != null ? ward.getId() : null);

        hashMap.put("name", name);
        hashMap.put("phone", phone);
        hashMap.put("rateAvg", rateAvg);
        hashMap.put("address", address);
        hashMap.put("longitude", longitude);
        hashMap.put("latitude", latitude);
        hashMap.put("description", description);
        hashMap.put("active", active);
        hashMap.put("featured", isFeatured);

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

        hashMap.remove("userPartnerId");
        hashMap.remove("provinceId");
        hashMap.remove("districtId");
        hashMap.remove("wardId");

        hashMap.put("userPartner", getUserPartnerHashMap());
        hashMap.put("ratingGarages", getRatingGaragesHashMap());
        hashMap.put("garageImages", getGarageImagesHashMap());
        hashMap.put("province", getProvinceHashMap());
        hashMap.put("district", getDistrictHashMap());
        hashMap.put("ward", getWardHashMap());

        return hashMap;
    }

    //@JsonProperty("userPartner")
    private LinkedHashMap<String, Object> getUserPartnerHashMap() {
        return userPartner != null ? userPartner.toHashMap() : null;
    }

    //@JsonProperty("ratingGarages")
    private List<LinkedHashMap<String, Object>> getRatingGaragesHashMap() {
        return ratingGarages != null ? ratingGarages.stream().map(RatingGarage::toHashMap).toList() : null;
    }

    //@JsonProperty("garageImages")
    private List<LinkedHashMap<String, Object>> getGarageImagesHashMap() {
        return garageImages != null ? garageImages.stream().map(GarageImage::toHashMap).toList() : null;
    }

    //@JsonProperty("province")
    private LinkedHashMap<String, Object> getProvinceHashMap() {
        return province != null ? province.toHashMap() : null;
    }

    //@JsonProperty("district")
    private LinkedHashMap<String, Object> getDistrictHashMap() {
        return district != null ? district.toHashMap() : null;
    }

    //@JsonProperty("ward")
    private LinkedHashMap<String, Object> getWardHashMap() {
        return ward != null ? ward.toHashMap() : null;
    }
    //endregion

}
