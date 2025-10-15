package com.evdealer.entity;

import jakarta.persistence.*;
import org.hibernate.annotations.Immutable;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.UUID;

@Entity
@Table(name = "delivery_tracking_report")
@Immutable
public class DeliveryTrackingReport {
    
    @Id
    @Column(name = "delivery_id")
    private UUID deliveryId;
    
    @Column(name = "delivery_date")
    private LocalDate deliveryDate;
    
    @Column(name = "delivery_time")
    private LocalTime deliveryTime;
    
    @Column(name = "delivery_status")
    private String deliveryStatus;
    
    @Column(name = "customer_name")
    private String customerName;
    
    @Column(name = "customer_phone")
    private String customerPhone;
    
    @Column(name = "order_number")
    private String orderNumber;
    
    @Column(name = "vehicle_info")
    private String vehicleInfo;
    
    @Column(name = "color_name")
    private String colorName;
    
    @Column(name = "vin")
    private String vin;
    
    @Column(name = "delivery_address")
    private String deliveryAddress;
    
    @Column(name = "delivery_contact_name")
    private String deliveryContactName;
    
    @Column(name = "delivery_contact_phone")
    private String deliveryContactPhone;
    
    @Column(name = "delivered_by")
    private String deliveredBy;
    
    @Column(name = "delivery_confirmation_date")
    private LocalDateTime deliveryConfirmationDate;
    
    // Constructors
    public DeliveryTrackingReport() {}
    
    // Getters and Setters
    public UUID getDeliveryId() {
        return deliveryId;
    }
    
    public void setDeliveryId(UUID deliveryId) {
        this.deliveryId = deliveryId;
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
    
    public String getDeliveryStatus() {
        return deliveryStatus;
    }
    
    public void setDeliveryStatus(String deliveryStatus) {
        this.deliveryStatus = deliveryStatus;
    }
    
    public String getCustomerName() {
        return customerName;
    }
    
    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }
    
    public String getCustomerPhone() {
        return customerPhone;
    }
    
    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }
    
    public String getOrderNumber() {
        return orderNumber;
    }
    
    public void setOrderNumber(String orderNumber) {
        this.orderNumber = orderNumber;
    }
    
    public String getVehicleInfo() {
        return vehicleInfo;
    }
    
    public void setVehicleInfo(String vehicleInfo) {
        this.vehicleInfo = vehicleInfo;
    }
    
    public String getColorName() {
        return colorName;
    }
    
    public void setColorName(String colorName) {
        this.colorName = colorName;
    }
    
    public String getVin() {
        return vin;
    }
    
    public void setVin(String vin) {
        this.vin = vin;
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
    
    public String getDeliveredBy() {
        return deliveredBy;
    }
    
    public void setDeliveredBy(String deliveredBy) {
        this.deliveredBy = deliveredBy;
    }
    
    public LocalDateTime getDeliveryConfirmationDate() {
        return deliveryConfirmationDate;
    }
    
    public void setDeliveryConfirmationDate(LocalDateTime deliveryConfirmationDate) {
        this.deliveryConfirmationDate = deliveryConfirmationDate;
    }
}
