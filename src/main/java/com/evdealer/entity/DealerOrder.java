package com.evdealer.entity;

import jakarta.persistence.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "dealer_orders")
public class DealerOrder {
    
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "dealer_order_id")
    private UUID dealerOrderId;
    
    @Column(name = "dealer_order_number", nullable = false, unique = true, length = 100)
    private String dealerOrderNumber;
    
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "evm_staff_id", nullable = true)
    private User evmStaff;
    
    @Column(name = "order_date", nullable = false)
    private LocalDate orderDate;
    
    @Column(name = "expected_delivery_date")
    private LocalDate expectedDeliveryDate;
    
    @Column(name = "total_quantity", nullable = false)
    private Integer totalQuantity;
    
    @Column(name = "total_amount", nullable = false, precision = 15, scale = 2)
    private BigDecimal totalAmount;
    
    @Column(name = "status", length = 50, nullable = false)
    private String status = "pending";
    
    @Column(name = "priority", length = 20, nullable = false)
    private String priority = "normal";
    
    @Column(name = "notes", columnDefinition = "TEXT")
    private String notes;
    
    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
    
    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;
    
    // Constructors
    public DealerOrder() {}
    
    public DealerOrder(String dealerOrderNumber, User evmStaff, LocalDate orderDate, Integer totalQuantity, BigDecimal totalAmount) {
        this.dealerOrderNumber = dealerOrderNumber;
        this.evmStaff = evmStaff;
        this.orderDate = orderDate;
        this.totalQuantity = totalQuantity;
        this.totalAmount = totalAmount;
    }
    
    // Getters and Setters
    public UUID getDealerOrderId() {
        return dealerOrderId;
    }
    
    public void setDealerOrderId(UUID dealerOrderId) {
        this.dealerOrderId = dealerOrderId;
    }
    
    public String getDealerOrderNumber() {
        return dealerOrderNumber;
    }
    
    public void setDealerOrderNumber(String dealerOrderNumber) {
        this.dealerOrderNumber = dealerOrderNumber;
    }
    
    public User getEvmStaff() {
        return evmStaff;
    }
    
    public void setEvmStaff(User evmStaff) {
        this.evmStaff = evmStaff;
    }
    
    public LocalDate getOrderDate() {
        return orderDate;
    }
    
    public void setOrderDate(LocalDate orderDate) {
        this.orderDate = orderDate;
    }
    
    public LocalDate getExpectedDeliveryDate() {
        return expectedDeliveryDate;
    }
    
    public void setExpectedDeliveryDate(LocalDate expectedDeliveryDate) {
        this.expectedDeliveryDate = expectedDeliveryDate;
    }
    
    public Integer getTotalQuantity() {
        return totalQuantity;
    }
    
    public void setTotalQuantity(Integer totalQuantity) {
        this.totalQuantity = totalQuantity;
    }
    
    public BigDecimal getTotalAmount() {
        return totalAmount;
    }
    
    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public String getPriority() {
        return priority;
    }
    
    public void setPriority(String priority) {
        this.priority = priority;
    }
    
    public String getNotes() {
        return notes;
    }
    
    public void setNotes(String notes) {
        this.notes = notes;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}

