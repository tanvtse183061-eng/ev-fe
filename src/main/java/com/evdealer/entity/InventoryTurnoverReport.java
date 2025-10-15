package com.evdealer.entity;

import jakarta.persistence.*;
import org.hibernate.annotations.Immutable;
import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "inventory_turnover_report")
@Immutable
public class InventoryTurnoverReport {
    
    @Id
    @Column(name = "brand_name")
    private String brandName;
    
    @Column(name = "model_name")
    private String modelName;
    
    @Column(name = "variant_name")
    private String variantName;
    
    @Column(name = "color_name")
    private String colorName;
    
    @Column(name = "total_inventory")
    private Long totalInventory;
    
    @Column(name = "available_count")
    private Long availableCount;
    
    @Column(name = "sold_count")
    private Long soldCount;
    
    @Column(name = "reserved_count")
    private Long reservedCount;
    
    @Column(name = "avg_cost_price")
    private BigDecimal avgCostPrice;
    
    @Column(name = "avg_selling_price")
    private BigDecimal avgSellingPrice;
    
    @Column(name = "avg_profit_margin")
    private BigDecimal avgProfitMargin;
    
    @Column(name = "first_arrival")
    private LocalDate firstArrival;
    
    @Column(name = "last_arrival")
    private LocalDate lastArrival;
    
    // Constructors
    public InventoryTurnoverReport() {}
    
    // Getters and Setters
    public String getBrandName() {
        return brandName;
    }
    
    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }
    
    public String getModelName() {
        return modelName;
    }
    
    public void setModelName(String modelName) {
        this.modelName = modelName;
    }
    
    public String getVariantName() {
        return variantName;
    }
    
    public void setVariantName(String variantName) {
        this.variantName = variantName;
    }
    
    public String getColorName() {
        return colorName;
    }
    
    public void setColorName(String colorName) {
        this.colorName = colorName;
    }
    
    public Long getTotalInventory() {
        return totalInventory;
    }
    
    public void setTotalInventory(Long totalInventory) {
        this.totalInventory = totalInventory;
    }
    
    public Long getAvailableCount() {
        return availableCount;
    }
    
    public void setAvailableCount(Long availableCount) {
        this.availableCount = availableCount;
    }
    
    public Long getSoldCount() {
        return soldCount;
    }
    
    public void setSoldCount(Long soldCount) {
        this.soldCount = soldCount;
    }
    
    public Long getReservedCount() {
        return reservedCount;
    }
    
    public void setReservedCount(Long reservedCount) {
        this.reservedCount = reservedCount;
    }
    
    public BigDecimal getAvgCostPrice() {
        return avgCostPrice;
    }
    
    public void setAvgCostPrice(BigDecimal avgCostPrice) {
        this.avgCostPrice = avgCostPrice;
    }
    
    public BigDecimal getAvgSellingPrice() {
        return avgSellingPrice;
    }
    
    public void setAvgSellingPrice(BigDecimal avgSellingPrice) {
        this.avgSellingPrice = avgSellingPrice;
    }
    
    public BigDecimal getAvgProfitMargin() {
        return avgProfitMargin;
    }
    
    public void setAvgProfitMargin(BigDecimal avgProfitMargin) {
        this.avgProfitMargin = avgProfitMargin;
    }
    
    public LocalDate getFirstArrival() {
        return firstArrival;
    }
    
    public void setFirstArrival(LocalDate firstArrival) {
        this.firstArrival = firstArrival;
    }
    
    public LocalDate getLastArrival() {
        return lastArrival;
    }
    
    public void setLastArrival(LocalDate lastArrival) {
        this.lastArrival = lastArrival;
    }
}
