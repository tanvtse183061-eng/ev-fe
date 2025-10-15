package com.evdealer.entity;

import jakarta.persistence.*;
import org.hibernate.annotations.Immutable;
import java.math.BigDecimal;
import java.util.UUID;

@Entity
@Table(name = "dealer_performance_report")
@Immutable
public class DealerPerformanceReport {
    
    @Id
    @Column(name = "target_id")
    private UUID targetId;
    
    @Column(name = "target_year")
    private Integer targetYear;
    
    @Column(name = "target_month")
    private Integer targetMonth;
    
    @Column(name = "target_type")
    private String targetType;
    
    @Column(name = "target_amount")
    private BigDecimal targetAmount;
    
    @Column(name = "target_quantity")
    private Integer targetQuantity;
    
    @Column(name = "achieved_amount")
    private BigDecimal achievedAmount;
    
    @Column(name = "achieved_quantity")
    private Integer achievedQuantity;
    
    @Column(name = "achievement_rate")
    private BigDecimal achievementRate;
    
    @Column(name = "performance_level")
    private String performanceLevel;
    
    @Column(name = "target_status")
    private String targetStatus;
    
    @Column(name = "notes")
    private String notes;
    
    // Constructors
    public DealerPerformanceReport() {}
    
    // Getters and Setters
    public UUID getTargetId() {
        return targetId;
    }
    
    public void setTargetId(UUID targetId) {
        this.targetId = targetId;
    }
    
    public Integer getTargetYear() {
        return targetYear;
    }
    
    public void setTargetYear(Integer targetYear) {
        this.targetYear = targetYear;
    }
    
    public Integer getTargetMonth() {
        return targetMonth;
    }
    
    public void setTargetMonth(Integer targetMonth) {
        this.targetMonth = targetMonth;
    }
    
    public String getTargetType() {
        return targetType;
    }
    
    public void setTargetType(String targetType) {
        this.targetType = targetType;
    }
    
    public BigDecimal getTargetAmount() {
        return targetAmount;
    }
    
    public void setTargetAmount(BigDecimal targetAmount) {
        this.targetAmount = targetAmount;
    }
    
    public Integer getTargetQuantity() {
        return targetQuantity;
    }
    
    public void setTargetQuantity(Integer targetQuantity) {
        this.targetQuantity = targetQuantity;
    }
    
    public BigDecimal getAchievedAmount() {
        return achievedAmount;
    }
    
    public void setAchievedAmount(BigDecimal achievedAmount) {
        this.achievedAmount = achievedAmount;
    }
    
    public Integer getAchievedQuantity() {
        return achievedQuantity;
    }
    
    public void setAchievedQuantity(Integer achievedQuantity) {
        this.achievedQuantity = achievedQuantity;
    }
    
    public BigDecimal getAchievementRate() {
        return achievementRate;
    }
    
    public void setAchievementRate(BigDecimal achievementRate) {
        this.achievementRate = achievementRate;
    }
    
    public String getPerformanceLevel() {
        return performanceLevel;
    }
    
    public void setPerformanceLevel(String performanceLevel) {
        this.performanceLevel = performanceLevel;
    }
    
    public String getTargetStatus() {
        return targetStatus;
    }
    
    public void setTargetStatus(String targetStatus) {
        this.targetStatus = targetStatus;
    }
    
    public String getNotes() {
        return notes;
    }
    
    public void setNotes(String notes) {
        this.notes = notes;
    }
}
