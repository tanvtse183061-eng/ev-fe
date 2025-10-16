package com.evdealer.service;

import com.evdealer.entity.User;
import com.evdealer.entity.UserRole;
import com.evdealer.repository.UserRepository;
import com.evdealer.repository.UserRoleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@Transactional
public class UserService {
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private UserRoleRepository userRoleRepository;
    
    @Autowired
    private PasswordEncoder passwordEncoder;
    
    public List<User> getAllUsers() {
        try {
            return userRepository.findAll();
        } catch (Exception e) {
            // Return empty list if there's an issue
            return new java.util.ArrayList<>();
        }
    }
    
    public List<User> getActiveUsers() {
        return userRepository.findByIsActiveTrue();
    }
    
    public Optional<User> getUserById(UUID userId) {
        return userRepository.findById(userId);
    }
    
    public Optional<User> getUserByUsername(String username) {
        return userRepository.findByUsername(username);
    }
    
    public Optional<User> getUserByEmail(String email) {
        return userRepository.findByEmail(email);
    }
    
    public List<User> getUsersByRole(String roleName) {
        return userRepository.findByRoleName(roleName);
    }
    
    public List<User> searchUsersByName(String name) {
        return userRepository.findByNameContaining(name);
    }
    
    public User createUser(User user) {
        if (userRepository.existsByUsername(user.getUsername())) {
            throw new RuntimeException("Username already exists: " + user.getUsername());
        }
        if (userRepository.existsByEmail(user.getEmail())) {
            throw new RuntimeException("Email already exists: " + user.getEmail());
        }
        
        // Hash password before saving
        if (user.getPasswordHash() != null && !user.getPasswordHash().startsWith("$2a$")) {
            // Only hash if it's not already hashed (doesn't start with BCrypt prefix)
            user.setPasswordHash(passwordEncoder.encode(user.getPasswordHash()));
        }
        
        return userRepository.save(user);
    }
    
    public User updateUser(UUID userId, User userDetails) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found with id: " + userId));
        
        // Check for duplicate username (excluding current user)
        if (!user.getUsername().equals(userDetails.getUsername()) && 
            userRepository.existsByUsername(userDetails.getUsername())) {
            throw new RuntimeException("Username already exists: " + userDetails.getUsername());
        }
        
        // Check for duplicate email (excluding current user)
        if (!user.getEmail().equals(userDetails.getEmail()) && 
            userRepository.existsByEmail(userDetails.getEmail())) {
            throw new RuntimeException("Email already exists: " + userDetails.getEmail());
        }
        
        user.setUsername(userDetails.getUsername());
        user.setEmail(userDetails.getEmail());
        user.setFirstName(userDetails.getFirstName());
        user.setLastName(userDetails.getLastName());
        user.setPhone(userDetails.getPhone());
        user.setAddress(userDetails.getAddress());
        user.setDateOfBirth(userDetails.getDateOfBirth());
        user.setProfileImageUrl(userDetails.getProfileImageUrl());
        user.setProfileImagePath(userDetails.getProfileImagePath());
        user.setRole(userDetails.getRole());
        user.setIsActive(userDetails.getIsActive());
        
        return userRepository.save(user);
    }
    
    public void deleteUser(UUID userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found with id: " + userId));
        userRepository.delete(user);
    }
    
    public void deactivateUser(UUID userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found with id: " + userId));
        user.setIsActive(false);
        userRepository.save(user);
    }
    
    public List<UserRole> getAllRoles() {
        return userRoleRepository.findAll();
    }
    
    public Optional<UserRole> getRoleById(Integer roleId) {
        return userRoleRepository.findById(roleId);
    }
    
    public Optional<UserRole> getRoleByName(String roleName) {
        return userRoleRepository.findByRoleName(roleName);
    }
    
    public UserRole createRole(UserRole role) {
        if (userRoleRepository.existsByRoleName(role.getRoleName())) {
            throw new RuntimeException("Role already exists: " + role.getRoleName());
        }
        return userRoleRepository.save(role);
    }
    
    // Password Management methods
    public String resetUserPassword(UUID userId, String newPassword) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found with ID: " + userId));
        
        String passwordToSet = (newPassword != null && !newPassword.trim().isEmpty()) 
                ? newPassword 
                : "password123"; // Default password
        
        String hashedPassword = passwordEncoder.encode(passwordToSet);
        user.setPasswordHash(hashedPassword);
        userRepository.save(user);
        
        return "Password reset successfully for user: " + user.getUsername() + 
               (newPassword != null ? " with custom password" : " with default password");
    }
    
    public String resetUserPasswordByUsername(String username, String newPassword) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found with username: " + username));
        
        String passwordToSet = (newPassword != null && !newPassword.trim().isEmpty()) 
                ? newPassword 
                : "password123"; // Default password
        
        String hashedPassword = passwordEncoder.encode(passwordToSet);
        user.setPasswordHash(hashedPassword);
        userRepository.save(user);
        
        return "Password reset successfully for user: " + username + 
               (newPassword != null ? " with custom password" : " with default password");
    }
    
    public String resetUserPasswordByEmail(String email, String newPassword) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found with email: " + email));
        
        String passwordToSet = (newPassword != null && !newPassword.trim().isEmpty()) 
                ? newPassword 
                : "password123"; // Default password
        
        String hashedPassword = passwordEncoder.encode(passwordToSet);
        user.setPasswordHash(hashedPassword);
        userRepository.save(user);
        
        return "Password reset successfully for user: " + user.getUsername() + 
               " (email: " + email + ")" +
               (newPassword != null ? " with custom password" : " with default password");
    }
    
    public java.util.Map<String, Object> bulkResetPasswords(java.util.List<UUID> userIds) {
        java.util.Map<String, Object> result = new java.util.HashMap<>();
        java.util.List<String> successList = new java.util.ArrayList<>();
        java.util.List<String> errorList = new java.util.ArrayList<>();
        
        for (UUID userId : userIds) {
            try {
                String message = resetUserPassword(userId, null); // Use default password
                successList.add(message);
            } catch (Exception e) {
                errorList.add("Failed to reset password for user ID " + userId + ": " + e.getMessage());
            }
        }
        
        result.put("totalRequested", userIds.size());
        result.put("successful", successList.size());
        result.put("failed", errorList.size());
        result.put("successList", successList);
        result.put("errorList", errorList);
        
        return result;
    }
}

