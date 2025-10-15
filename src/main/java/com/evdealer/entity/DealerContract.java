package com.evdealer.entity;

import jakarta.persistence.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "dealer_contracts")
public class DealerContract {
    
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "contract_id")
    private UUID contractId;
    
    @Column(name = "contract_number", nullable = false, unique = true, length = 100)
    private String contractNumber;
    
    @Column(name = "contract_type", nullable = false, length = 50)
    private String contractType;
    
    @Column(name = "start_date", nullable = false)
    private LocalDate startDate;
    
    @Column(name = "end_date", nullable = false)
    private LocalDate endDate;
    
    @Column(name = "territory", length = 255)
    private String territory;
    
    @Column(name = "commission_rate", precision = 5, scale = 2)
    private BigDecimal commissionRate;
    
    @Column(name = "minimum_sales_target", precision = 15, scale = 2)
    private BigDecimal minimumSalesTarget;
    
    @Column(name = "contract_status", length = 50, nullable = false)
    private String contractStatus = "active";
    
    @Column(name = "signed_date")
    private LocalDate signedDate;
    
    @Column(name = "contract_file_url", length = 500)
    private String contractFileUrl;
    
    @Column(name = "contract_file_path", length = 500)
    private String contractFilePath;
    
    @Column(name = "terms_and_conditions", columnDefinition = "TEXT")
    private String termsAndConditions;
    
    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
    
    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;
    
    // Constructors
    public DealerContract() {}
    
    public DealerContract(String contractNumber, String contractType, LocalDate startDate, LocalDate endDate) {
        this.contractNumber = contractNumber;
        this.contractType = contractType;
        this.startDate = startDate;
        this.endDate = endDate;
    }
    
    // Getters and Setters
    public UUID getContractId() {
        return contractId;
    }
    
    public void setContractId(UUID contractId) {
        this.contractId = contractId;
    }
    
    public String getContractNumber() {
        return contractNumber;
    }
    
    public void setContractNumber(String contractNumber) {
        this.contractNumber = contractNumber;
    }
    
    public String getContractType() {
        return contractType;
    }
    
    public void setContractType(String contractType) {
        this.contractType = contractType;
    }
    
    public LocalDate getStartDate() {
        return startDate;
    }
    
    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }
    
    public LocalDate getEndDate() {
        return endDate;
    }
    
    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }
    
    public String getTerritory() {
        return territory;
    }
    
    public void setTerritory(String territory) {
        this.territory = territory;
    }
    
    public BigDecimal getCommissionRate() {
        return commissionRate;
    }
    
    public void setCommissionRate(BigDecimal commissionRate) {
        this.commissionRate = commissionRate;
    }
    
    public BigDecimal getMinimumSalesTarget() {
        return minimumSalesTarget;
    }
    
    public void setMinimumSalesTarget(BigDecimal minimumSalesTarget) {
        this.minimumSalesTarget = minimumSalesTarget;
    }
    
    public String getContractStatus() {
        return contractStatus;
    }
    
    public void setContractStatus(String contractStatus) {
        this.contractStatus = contractStatus;
    }
    
    public LocalDate getSignedDate() {
        return signedDate;
    }
    
    public void setSignedDate(LocalDate signedDate) {
        this.signedDate = signedDate;
    }
    
    public String getContractFileUrl() {
        return contractFileUrl;
    }
    
    public void setContractFileUrl(String contractFileUrl) {
        this.contractFileUrl = contractFileUrl;
    }
    
    public String getContractFilePath() {
        return contractFilePath;
    }
    
    public void setContractFilePath(String contractFilePath) {
        this.contractFilePath = contractFilePath;
    }
    
    public String getTermsAndConditions() {
        return termsAndConditions;
    }
    
    public void setTermsAndConditions(String termsAndConditions) {
        this.termsAndConditions = termsAndConditions;
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
