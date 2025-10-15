package com.evdealer.entity;

import jakarta.persistence.*;
import org.hibernate.annotations.CreationTimestamp;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "customer_payments")
public class CustomerPayment {
    
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "payment_id")
    private UUID paymentId;
    
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "order_id", nullable = true)
    private Order order;
    
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "customer_id", nullable = true)
    private Customer customer;
    
    @Column(name = "payment_number", nullable = false, unique = true, length = 100)
    private String paymentNumber;
    
    @Column(name = "payment_date", nullable = false)
    private LocalDate paymentDate;
    
    @Column(name = "amount", nullable = false, precision = 12, scale = 2)
    private BigDecimal amount;
    
    @Column(name = "payment_type", length = 50)
    private String paymentType;
    
    @Column(name = "payment_method", length = 100)
    private String paymentMethod;
    
    @Column(name = "reference_number", length = 100)
    private String referenceNumber;
    
    @Column(name = "status", length = 50, nullable = false)
    private String status = "pending";
    
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "processed_by")
    private User processedBy;
    
    @Column(name = "notes", columnDefinition = "TEXT")
    private String notes;
    
    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
    
    // Constructors
    public CustomerPayment() {}
    
    public CustomerPayment(Order order, Customer customer, String paymentNumber, LocalDate paymentDate, BigDecimal amount) {
        this.order = order;
        this.customer = customer;
        this.paymentNumber = paymentNumber;
        this.paymentDate = paymentDate;
        this.amount = amount;
    }
    
    // Getters and Setters
    public UUID getPaymentId() {
        return paymentId;
    }
    
    public void setPaymentId(UUID paymentId) {
        this.paymentId = paymentId;
    }
    
    public Order getOrder() {
        return order;
    }
    
    public void setOrder(Order order) {
        this.order = order;
    }
    
    public Customer getCustomer() {
        return customer;
    }
    
    public void setCustomer(Customer customer) {
        this.customer = customer;
    }
    
    public String getPaymentNumber() {
        return paymentNumber;
    }
    
    public void setPaymentNumber(String paymentNumber) {
        this.paymentNumber = paymentNumber;
    }
    
    public LocalDate getPaymentDate() {
        return paymentDate;
    }
    
    public void setPaymentDate(LocalDate paymentDate) {
        this.paymentDate = paymentDate;
    }
    
    public BigDecimal getAmount() {
        return amount;
    }
    
    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }
    
    public String getPaymentType() {
        return paymentType;
    }
    
    public void setPaymentType(String paymentType) {
        this.paymentType = paymentType;
    }
    
    public String getPaymentMethod() {
        return paymentMethod;
    }
    
    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }
    
    public String getReferenceNumber() {
        return referenceNumber;
    }
    
    public void setReferenceNumber(String referenceNumber) {
        this.referenceNumber = referenceNumber;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public User getProcessedBy() {
        return processedBy;
    }
    
    public void setProcessedBy(User processedBy) {
        this.processedBy = processedBy;
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
}

