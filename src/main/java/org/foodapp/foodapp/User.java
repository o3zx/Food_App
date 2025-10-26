package org.foodapp.foodapp;

public class User {
    private int id;
    private String username;
    private String passwordHash;
    private String email;
    private String role;
    private String Address;
    public User() {}
    public User(int id, String username, String passwordHash, String email, String role, String Address) {
        this.id = id;
        this.username = username;
        this.passwordHash = passwordHash;
        this.email = email;
        this.role = role;
        this.Address = Address;
    }
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }
    public String getUsername() {
        return username;
    }
    public void setUsername(String username) {
        this.username = username;
    }
    public String getPasswordHash() {
        return passwordHash;
    }
    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }
    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }
    public String getRole() {
        return role;
    }
    public void setRole(String role) {
        this.role = role;
    }
    public String getAddress() { return  Address; }
    public void setAddress(String Address) { this.Address = Address; }
}
