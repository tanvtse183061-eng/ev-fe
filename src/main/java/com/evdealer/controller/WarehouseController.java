package com.evdealer.controller;

import com.evdealer.entity.Warehouse;
import com.evdealer.service.WarehouseService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/warehouses")
@CrossOrigin(origins = "*")
@Tag(name = "Warehouse Management", description = "APIs for managing warehouses")
public class WarehouseController {
    
    @Autowired
    private WarehouseService warehouseService;
    
    @GetMapping
    @Operation(summary = "Get all warehouses", description = "Retrieve a list of all warehouses")
    public ResponseEntity<List<Warehouse>> getAllWarehouses() {
        List<Warehouse> warehouses = warehouseService.getAllWarehouses();
        return ResponseEntity.ok(warehouses);
    }
    
    @GetMapping("/active")
    @Operation(summary = "Get active warehouses", description = "Retrieve a list of all active warehouses")
    public ResponseEntity<List<Warehouse>> getActiveWarehouses() {
        List<Warehouse> warehouses = warehouseService.getActiveWarehouses();
        return ResponseEntity.ok(warehouses);
    }
    
    @GetMapping("/{warehouseId}")
    @Operation(summary = "Get warehouse by ID", description = "Retrieve a specific warehouse by its ID")
    public ResponseEntity<Warehouse> getWarehouseById(@PathVariable @Parameter(description = "Warehouse ID") UUID warehouseId) {
        return warehouseService.getWarehouseById(warehouseId)
                .map(warehouse -> ResponseEntity.ok(warehouse))
                .orElse(ResponseEntity.notFound().build());
    }
    
    @GetMapping("/code/{warehouseCode}")
    @Operation(summary = "Get warehouse by code", description = "Retrieve a specific warehouse by its code")
    public ResponseEntity<Warehouse> getWarehouseByCode(@PathVariable String warehouseCode) {
        return warehouseService.getWarehouseByCode(warehouseCode)
                .map(warehouse -> ResponseEntity.ok(warehouse))
                .orElse(ResponseEntity.notFound().build());
    }
    
    @GetMapping("/city/{city}")
    @Operation(summary = "Get warehouses by city", description = "Retrieve warehouses in a specific city")
    public ResponseEntity<List<Warehouse>> getWarehousesByCity(@PathVariable String city) {
        List<Warehouse> warehouses = warehouseService.getWarehousesByCity(city);
        return ResponseEntity.ok(warehouses);
    }
    
    @GetMapping("/province/{province}")
    @Operation(summary = "Get warehouses by province", description = "Retrieve warehouses in a specific province")
    public ResponseEntity<List<Warehouse>> getWarehousesByProvince(@PathVariable String province) {
        List<Warehouse> warehouses = warehouseService.getWarehousesByProvince(province);
        return ResponseEntity.ok(warehouses);
    }
    
    @PostMapping
    @Operation(summary = "Create warehouse", description = "Create a new warehouse")
    public ResponseEntity<Warehouse> createWarehouse(@RequestBody Warehouse warehouse) {
        try {
            Warehouse createdWarehouse = warehouseService.createWarehouse(warehouse);
            return ResponseEntity.status(HttpStatus.CREATED).body(createdWarehouse);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().build();
        }
    }
    
    @PutMapping("/{warehouseId}")
    @Operation(summary = "Update warehouse", description = "Update an existing warehouse")
    public ResponseEntity<Warehouse> updateWarehouse(
            @PathVariable UUID warehouseId, 
            @RequestBody Warehouse warehouseDetails) {
        try {
            Warehouse updatedWarehouse = warehouseService.updateWarehouse(warehouseId, warehouseDetails);
            return ResponseEntity.ok(updatedWarehouse);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }
    
    @PutMapping("/{warehouseId}/activate")
    @Operation(summary = "Activate warehouse", description = "Activate a warehouse")
    public ResponseEntity<Warehouse> activateWarehouse(@PathVariable UUID warehouseId) {
        try {
            Warehouse activatedWarehouse = warehouseService.activateWarehouse(warehouseId);
            return ResponseEntity.ok(activatedWarehouse);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }
    
    @PutMapping("/{warehouseId}/deactivate")
    @Operation(summary = "Deactivate warehouse", description = "Deactivate a warehouse")
    public ResponseEntity<Warehouse> deactivateWarehouse(@PathVariable UUID warehouseId) {
        try {
            Warehouse deactivatedWarehouse = warehouseService.deactivateWarehouse(warehouseId);
            return ResponseEntity.ok(deactivatedWarehouse);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }
    
    @DeleteMapping("/{warehouseId}")
    @Operation(summary = "Delete warehouse", description = "Delete a warehouse")
    public ResponseEntity<Void> deleteWarehouse(@PathVariable UUID warehouseId) {
        try {
            warehouseService.deleteWarehouse(warehouseId);
            return ResponseEntity.noContent().build();
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }
}
