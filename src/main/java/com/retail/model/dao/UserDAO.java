package com.retail.model.dao;

import com.retail.model.bean.User;
import com.retail.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    public User authenticate(String username, String password) {
        User user = null;
        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    user.setFullName(rs.getString("full_name"));
                    user.setRole(rs.getString("role"));
                    user.setPhone(rs.getString("phone"));
                    user.setEmail(rs.getString("email"));
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return user;
    }

    /**
     * UPDATED: Fetches EVERYONE including the Owner so the table is complete.
     */
    public List<User> getAllStaff() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT user_id, username, full_name, role, phone, email FROM users ORDER BY user_id ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setUsername(rs.getString("username"));
                u.setFullName(rs.getString("full_name"));
                u.setRole(rs.getString("role"));
                u.setPhone(rs.getString("phone")); // Correctly mapping Phone
                u.setEmail(rs.getString("email")); // Correctly mapping Email
                list.add(u);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean registerUser(User u) {
        String sql = "INSERT INTO users (username, password, full_name, role, phone, email) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, u.getUsername());
            ps.setString(2, u.getPassword());
            ps.setString(3, u.getFullName());
            ps.setString(4, u.getRole());
            ps.setString(5, u.getPhone());
            ps.setString(6, u.getEmail());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean updateStaffContact(int userId, String phone, String email) {
        String sql = "UPDATE users SET phone = ?, email = ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phone);
            ps.setString(2, email);
            ps.setInt(3, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean updateProfile(User u) {
        String sql = "UPDATE users SET full_name = ?, phone = ?, email = ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, u.getFullName());
            ps.setString(2, u.getPhone());
            ps.setString(3, u.getEmail());
            ps.setInt(4, u.getUserId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean resetPassword(String username, String email, String newPassword) {
        String sql = "UPDATE users SET password = ? WHERE username = ? AND email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newPassword);
            ps.setString(2, username);
            ps.setString(3, email);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean deleteUser(int id) {
        // Prevention: Cannot delete Owner in the DAO level
        String sql = "DELETE FROM users WHERE user_id = ? AND role != 'OWNER'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}