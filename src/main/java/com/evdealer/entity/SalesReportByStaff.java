package com.evdealer.entity;

import jakarta.persistence.*;
import org.hibernate.annotations.Immutable;
import java.math.BigDecimal;
import java.util.UUID;

@Entity
@Table(name = "sales_report_by_staff")
@Immutable
public class SalesReportByStaff {
    
    @Id
    @Column(name = "user_id")
    private UUID userId;
    
    @Column(name = "staff_name")
    private String staffName;
    
    @Column(name = "role_id")
    private Integer roleId;
    
    @Column(name = "role_name")
    private String roleName;
    
    @Column(name = "total_orders")
    private Long totalOrders;
    
    @Column(name = "total_sales")
    private BigDecimal totalSales;
    
    @Column(name = "avg_order_value")
    private BigDecimal avgOrderValue;
    
    @Column(name = "completed_orders")
    private Long completedOrders;
    
    @Column(name = "completed_sales")
    private BigDecimal completedSales;
    
    // Constructors
    public SalesReportByStaff() {}
    
    // Getters and Setters
    public UUID getUserId() {
        return userId;
    }
    
    public void setUserId(UUID userId) {
        this.userId = userId;
    }
    
    public String getStaffName() {
        return staffName;
    }
    
    public void setStaffName(String staffName) {
        this.staffName = staffName;
    }
    
    public Integer getRoleId() {
        return roleId;
    }
    
    public void setRoleId(Integer roleId) {
        this.roleId = roleId;
    }
    
    public String getRoleName() {
        return roleName;
    }
    
    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }
    
    public Long getTotalOrders() {
        return totalOrders;
    }
    
    public void setTotalOrders(Long totalOrders) {
        this.totalOrders = totalOrders;
    }
    
    public BigDecimal getTotalSales() {
        return totalSales;
    }
    
    public void setTotalSales(BigDecimal totalSales) {
        this.totalSales = totalSales;
    }
    
    public BigDecimal getAvgOrderValue() {
        return avgOrderValue;
    }
    
    public void setAvgOrderValue(BigDecimal avgOrderValue) {
        this.avgOrderValue = avgOrderValue;
    }
    
    public Long getCompletedOrders() {
        return completedOrders;
    }
    
    public void setCompletedOrders(Long completedOrders) {
        this.completedOrders = completedOrders;
    }
    
    public BigDecimal getCompletedSales() {
        return completedSales;
    }
    
    public void setCompletedSales(BigDecimal completedSales) {
        this.completedSales = completedSales;
    }
}
