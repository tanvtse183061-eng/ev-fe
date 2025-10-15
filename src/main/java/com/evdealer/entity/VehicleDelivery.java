package com.evdealer.entity;

import jakarta.persistence.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.UUID;

@Entity
@Table(name = "vehicle_deliveries")
public class VehicleDelivery {
    
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "delivery_id")
    private UUID deliveryId;
    
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "order_id", nullable = false)
    private Order order;
    
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "inventory_id", nullable = false)
    private VehicleInventory inventory;
    
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "customer_id", nullable = false)
    private Customer customer;
    
    @Column(name = "delivery_date", nullable = false)
    private LocalDate deliveryDate;
    
    @Column(name = "delivery_time")
    private LocalTime deliveryTime;
    
    @Column(name = "delivery_address", nullable = false, columnDefinition = "TEXT")
    private String deliveryAddress;
    
    @Column(name = "delivery_contact_name", length = 100)
    private String deliveryContactName;
    
    @Column(name = "delivery_contact_phone", length = 20)
    private String deliveryContactPhone;
    
    @Column(name = "delivery_status", length = 50, nullable = false)
    private String deliveryStatus = "scheduled";
    
    @Column(name = "delivery_notes", columnDefinition = "TEXT")
    private String deliveryNotes;
    
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "delivered_by")
    private User deliveredBy;
    
    @Column(name = "delivery_confirmation_date")
    private LocalDateTime deliveryConfirmationDate;
    
    @Column(name = "customer_signature_url", length = 500)
    private String customerSignatureUrl;
    
    @Column(name = "customer_signature_path", length = 500)
    private String customerSignaturePath;
    
    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
    
    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;
    
    // Constructors
    public VehicleDelivery() {}
    
    public VehicleDelivery(Order order, VehicleInventory inventory, Customer customer, LocalDate deliveryDate, String deliveryAddress) {
        this.order = order;
        this.inventory = inventory;
        this.customer = customer;
        this.deliveryDate = deliveryDate;
        this.deliveryAddress = deliveryAddress;
    }
    
    // Getters and Setters
    public UUID getDeliveryId() {
        return deliveryId;
    }
    
    public void setDeliveryId(UUID deliveryId) {
        this.deliveryId = deliveryId;
    }
    
    public Order getOrder() {
        return order;
    }
    
    public void setOrder(Order order) {
        this.order = order;
    }
    
    public VehicleInventory getInventory() {
        return inventory;
    }
    
    public void setInventory(VehicleInventory inventory) {
        this.inventory = inventory;
    }
    
    public Customer getCustomer() {
        return customer;
    }
    
    public void setCustomer(Customer customer) {
        this.customer = customer;
    }
    
    public LocalDate getDeliveryDate() {
        return deliveryDate;
    }
    
    public void setDeliveryDate(LocalDate deliveryDate) {
        this.deliveryDate = deliveryDate;
    }
    
    public LocalTime getDeliveryTime() {
        return deliveryTime;
    }
    
    public void setDeliveryTime(LocalTime deliveryTime) {
        this.deliveryTime = deliveryTime;
    }
    
    public String getDeliveryAddress() {
        return deliveryAddress;
    }
    
    public void setDeliveryAddress(String deliveryAddress) {
        this.deliveryAddress = deliveryAddress;
    }
    
    public String getDeliveryContactName() {
        return deliveryContactName;
    }
    
    public void setDeliveryContactName(String deliveryContactName) {
        this.deliveryContactName = deliveryContactName;
    }
    
    public String getDeliveryContactPhone() {
        return deliveryContactPhone;
    }
    
    public void setDeliveryContactPhone(String deliveryContactPhone) {
        this.deliveryContactPhone = deliveryContactPhone;
    }
    
    public String getDeliveryStatus() {
        return deliveryStatus;
    }
    
    public void setDeliveryStatus(String deliveryStatus) {
        this.deliveryStatus = deliveryStatus;
    }
    
    public String getDeliveryNotes() {
        return deliveryNotes;
    }
    
    public void setDeliveryNotes(String deliveryNotes) {
        this.deliveryNotes = deliveryNotes;
    }
    
    public User getDeliveredBy() {
        return deliveredBy;
    }
    
    public void setDeliveredBy(User deliveredBy) {
        this.deliveredBy = deliveredBy;
    }
    
    public LocalDateTime getDeliveryConfirmationDate() {
        return deliveryConfirmationDate;
    }
    
    public void setDeliveryConfirmationDate(LocalDateTime deliveryConfirmationDate) {
        this.deliveryConfirmationDate = deliveryConfirmationDate;
    }
    
    public String getCustomerSignatureUrl() {
        return customerSignatureUrl;
    }
    
    public void setCustomerSignatureUrl(String customerSignatureUrl) {
        this.customerSignatureUrl = customerSignatureUrl;
    }
    
    public String getCustomerSignaturePath() {
        return customerSignaturePath;
    }
    
    public void setCustomerSignaturePath(String customerSignaturePath) {
        this.customerSignaturePath = customerSignaturePath;
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
