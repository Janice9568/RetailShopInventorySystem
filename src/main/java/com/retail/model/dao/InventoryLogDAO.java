package com.retail.model.dao;

import com.retail.model.bean.InventoryLog;
import com.retail.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InventoryLogDAO {
    public List<InventoryLog> getAllLogs() {
        List<InventoryLog> logs = new ArrayList<>();
        String sql = "SELECT l.*, p.product_name, u.full_name as user_name FROM inventory_logs l " +
                "JOIN products p ON l.product_id = p.product_id " +
                "JOIN users u ON l.user_id = u.user_id ORDER BY l.log_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                InventoryLog log = new InventoryLog();
                log.setLogId(rs.getInt("log_id"));
                log.setProductName(rs.getString("product_name"));
                log.setUserName(rs.getString("user_name"));
                log.setChangeQuantity(rs.getInt("change_quantity"));
                log.setReason(rs.getString("reason"));
                log.setLogDate(rs.getTimestamp("log_date"));
                logs.add(log);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return logs;
    }
}