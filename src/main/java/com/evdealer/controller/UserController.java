package com.evdealer.controller;

import com.evdealer.entity.User;
import com.evdealer.entity.UserRole;
import com.evdealer.service.UserService;
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
@RequestMapping("/api/users")
@CrossOrigin(origins = "*")
@Tag(name = "User Management", description = "APIs for managing users and user roles")
public class UserController {
    
    @Autowired
    private UserService userService;
    
    // User endpoints
    @GetMapping
    @Operation(summary = "Get all users", description = "Retrieve a list of all users in the system")
    public ResponseEntity<List<User>> getAllUsers() {
        List<User> users = userService.getAllUsers();
        // Remove password hash from all users for security
        users.forEach(user -> user.setPasswordHash(null));
        return ResponseEntity.ok(users);
    }
    
    @GetMapping("/active")
    @Operation(summary = "Get active users", description = "Retrieve a list of all active users")
    public ResponseEntity<List<User>> getActiveUsers() {
        List<User> users = userService.getActiveUsers();
        // Remove password hash from all users for security
        users.forEach(user -> user.setPasswordHash(null));
        return ResponseEntity.ok(users);
    }
    
    @GetMapping("/{userId}")
    @Operation(summary = "Get user by ID", description = "Retrieve a specific user by their ID")
    public ResponseEntity<User> getUserById(@PathVariable @Parameter(description = "User ID") UUID userId) {
        return userService.getUserById(userId)
                .map(user -> {
                    // Remove password hash for security
                    user.setPasswordHash(null);
                    return ResponseEntity.ok(user);
                })
                .orElse(ResponseEntity.notFound().build());
    }
    
    @GetMapping("/username/{username}")
    public ResponseEntity<User> getUserByUsername(@PathVariable String username) {
        return userService.getUserByUsername(username)
                .map(user -> {
                    // Remove password hash for security
                    user.setPasswordHash(null);
                    return ResponseEntity.ok(user);
                })
                .orElse(ResponseEntity.notFound().build());
    }
    
    @GetMapping("/email/{email}")
    public ResponseEntity<User> getUserByEmail(@PathVariable String email) {
        return userService.getUserByEmail(email)
                .map(user -> {
                    // Remove password hash for security
                    user.setPasswordHash(null);
                    return ResponseEntity.ok(user);
                })
                .orElse(ResponseEntity.notFound().build());
    }
    
    @GetMapping("/role/{roleName}")
    public ResponseEntity<List<User>> getUsersByRole(@PathVariable String roleName) {
        List<User> users = userService.getUsersByRole(roleName);
        // Remove password hash from all users for security
        users.forEach(user -> user.setPasswordHash(null));
        return ResponseEntity.ok(users);
    }
    
    @GetMapping("/search")
    public ResponseEntity<List<User>> searchUsersByName(@RequestParam String name) {
        List<User> users = userService.searchUsersByName(name);
        // Remove password hash from all users for security
        users.forEach(user -> user.setPasswordHash(null));
        return ResponseEntity.ok(users);
    }
    
    @PostMapping
    public ResponseEntity<User> createUser(@RequestBody User user) {
        try {
            User createdUser = userService.createUser(user);
            // Remove password hash from response for security
            createdUser.setPasswordHash(null);
            return ResponseEntity.status(HttpStatus.CREATED).body(createdUser);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().build();
        }
    }
    
    @PutMapping("/{userId}")
    public ResponseEntity<User> updateUser(@PathVariable UUID userId, @RequestBody User userDetails) {
        try {
            User updatedUser = userService.updateUser(userId, userDetails);
            // Remove password hash from response for security
            updatedUser.setPasswordHash(null);
            return ResponseEntity.ok(updatedUser);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }
    
    @DeleteMapping("/{userId}")
    public ResponseEntity<Void> deleteUser(@PathVariable UUID userId) {
        try {
            userService.deleteUser(userId);
            return ResponseEntity.noContent().build();
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }
    
    @PutMapping("/{userId}/deactivate")
    public ResponseEntity<Void> deactivateUser(@PathVariable UUID userId) {
        try {
            userService.deactivateUser(userId);
            return ResponseEntity.ok().build();
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }
    
    // User Role endpoints
    @GetMapping("/roles")
    public ResponseEntity<List<UserRole>> getAllRoles() {
        List<UserRole> roles = userService.getAllRoles();
        return ResponseEntity.ok(roles);
    }
    
    @GetMapping("/roles/{roleId}")
    public ResponseEntity<UserRole> getRoleById(@PathVariable Integer roleId) {
        return userService.getRoleById(roleId)
                .map(role -> ResponseEntity.ok(role))
                .orElse(ResponseEntity.notFound().build());
    }
    
    @GetMapping("/roles/name/{roleName}")
    public ResponseEntity<UserRole> getRoleByName(@PathVariable String roleName) {
        return userService.getRoleByName(roleName)
                .map(role -> ResponseEntity.ok(role))
                .orElse(ResponseEntity.notFound().build());
    }
    
    @PostMapping("/roles")
    public ResponseEntity<UserRole> createRole(@RequestBody UserRole role) {
        try {
            UserRole createdRole = userService.createRole(role);
            return ResponseEntity.status(HttpStatus.CREATED).body(createdRole);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().build();
        }
    }
}

