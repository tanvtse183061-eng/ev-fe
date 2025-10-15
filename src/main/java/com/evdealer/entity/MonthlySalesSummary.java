package com.evdealer.entity;

import jakarta.persistence.*;
import org.hibernate.annotations.Immutable;
import java.math.BigDecimal;

@Entity
@Table(name = "monthly_sales_summary")
@Immutable
public class MonthlySalesSummary {
    
    @Id
    @Column(name = "sales_year")
    private BigDecimal salesYear;
    
    @Column(name = "sales_month")
    private BigDecimal salesMonth;
    
    @Column(name = "total_orders")
    private Long totalOrders;
    
    @Column(name = "total_revenue")
    private BigDecimal totalRevenue;
    
    @Column(name = "total_deposits")
    private BigDecimal totalDeposits;
    
    @Column(name = "total_balance")
    private BigDecimal totalBalance;
    
    @Column(name = "cash_orders")
    private Long cashOrders;
    
    @Column(name = "installment_orders")
    private Long installmentOrders;
    
    @Column(name = "avg_order_value")
    private BigDecimal avgOrderValue;
    
    // Constructors
    public MonthlySalesSummary() {}
    
    // Getters and Setters
    public BigDecimal getSalesYear() {
        return salesYear;
    }
    
    public void setSalesYear(BigDecimal salesYear) {
        this.salesYear = salesYear;
    }
    
    public BigDecimal getSalesMonth() {
        return salesMonth;
    }
    
    public void setSalesMonth(BigDecimal salesMonth) {
        this.salesMonth = salesMonth;
    }
    
    public Long getTotalOrders() {
        return totalOrders;
    }
    
    public void setTotalOrders(Long totalOrders) {
        this.totalOrders = totalOrders;
    }
    
    public BigDecimal getTotalRevenue() {
        return totalRevenue;
    }
    
    public void setTotalRevenue(BigDecimal totalRevenue) {
        this.totalRevenue = totalRevenue;
    }
    
    public BigDecimal getTotalDeposits() {
        return totalDeposits;
    }
    
    public void setTotalDeposits(BigDecimal totalDeposits) {
        this.totalDeposits = totalDeposits;
    }
    
    public BigDecimal getTotalBalance() {
        return totalBalance;
    }
    
    public void setTotalBalance(BigDecimal totalBalance) {
        this.totalBalance = totalBalance;
    }
    
    public Long getCashOrders() {
        return cashOrders;
    }
    
    public void setCashOrders(Long cashOrders) {
        this.cashOrders = cashOrders;
    }
    
    public Long getInstallmentOrders() {
        return installmentOrders;
    }
    
    public void setInstallmentOrders(Long installmentOrders) {
        this.installmentOrders = installmentOrders;
    }
    
    public BigDecimal getAvgOrderValue() {
        return avgOrderValue;
    }
    
    public void setAvgOrderValue(BigDecimal avgOrderValue) {
        this.avgOrderValue = avgOrderValue;
    }
}
