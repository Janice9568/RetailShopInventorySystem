package com.retail.model.dao;

import com.retail.model.bean.SaleItem;
import com.retail.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class ReportDAO {

    /**
     * 获取按天分组的财务总收入
     */
    public Map<String, Double> getSalesSummary(String startDate, String endDate) {
        Map<String, Double> map = new LinkedHashMap<>();
        String sql = "SELECT DATE(sale_date) AS s_date, SUM(total_amount) AS total " +
                "FROM sales WHERE sale_date BETWEEN ? AND ? AND payment_status != 'CANCELLED' " +
                "GROUP BY DATE(sale_date) ORDER BY s_date ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, startDate + " 00:00:00");
            ps.setString(2, endDate + " 23:59:59");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    map.put(rs.getString("s_date"), rs.getDouble("total"));
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return map;
    }

    /**
     * 💡 100% 解决 500 报错：强制使用 AS real_date 别名，确保 rs.getString("real_date") 绝对能拿到数据！
     */
    public List<SaleItem> getDetailedSalesRows(String startDate, String endDate) {
        List<SaleItem> list = new ArrayList<>();
        String sql = "SELECT s.sale_date AS real_date, p.product_name, si.quantity, si.product_id, si.unit_price, si.subtotal " +
                "FROM sales s " +
                "JOIN sale_items si ON s.sale_id = si.sale_id " +
                "JOIN products p ON si.product_id = p.product_id " +
                "WHERE s.sale_date BETWEEN ? AND ? AND s.payment_status != 'CANCELLED' ORDER BY s.sale_date ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, startDate + " 00:00:00");
            ps.setString(2, endDate + " 23:59:59");

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SaleItem item = new SaleItem();
                    item.setProductId(rs.getInt("product_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setUnitPrice(rs.getDouble("unit_price"));
                    item.setSubtotal(rs.getDouble("subtotal"));

                    // 💡 抓取刚刚绑定的明确别名列，100% 安全
                    String fullTimestamp = rs.getString("real_date");
                    String cleanDate = (fullTimestamp != null && fullTimestamp.length() >= 10) ? fullTimestamp.substring(0, 10) : startDate;

                    item.setProductName(cleanDate + "||" + rs.getString("product_name"));
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Map<String, Integer> getProductPerformance() {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = "SELECT p.product_name, SUM(si.quantity) AS total_sold " +
                "FROM sale_items si JOIN products p ON si.product_id = p.product_id " +
                "JOIN sales s ON si.sale_id = s.sale_id WHERE s.payment_status != 'CANCELLED' " +
                "GROUP BY p.product_name ORDER BY total_sold DESC LIMIT 10";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getString("product_name"), rs.getInt("total_sold"));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return map;
    }

    public List<com.retail.model.bean.Sale> getFilteredSalesList(String startDate, String endDate) {
        List<com.retail.model.bean.Sale> list = new ArrayList<>();
        String sql = "SELECT s.*, u.full_name FROM sales s JOIN users u ON s.user_id = u.user_id " +
                "WHERE s.sale_date BETWEEN ? AND ? ORDER BY s.sale_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, startDate + " 00:00:00");
            ps.setString(2, endDate + " 23:59:59");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    com.retail.model.bean.Sale s = new com.retail.model.bean.Sale();
                    s.setSaleId(rs.getInt("sale_id"));
                    s.setSaleDate(rs.getTimestamp("sale_date"));
                    s.setTotalAmount(rs.getDouble("total_amount"));
                    s.setPaymentMethod(rs.getString("payment_method"));
                    s.setPaymentStatus(rs.getString("payment_status"));
                    s.setSellerName(rs.getString("full_name"));
                    s.setCancelReason(rs.getString("cancel_reason"));
                    list.add(s);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public double getTodaySales() {
        double total = 0.0;
        String todayStr = java.time.LocalDate.now().toString();
        String sql = "SELECT SUM(total_amount) FROM sales WHERE sale_date BETWEEN ? AND ? AND payment_status != 'CANCELLED'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, todayStr + " 00:00:00");
            ps.setString(2, todayStr + " 23:59:59");
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) total = rs.getDouble(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return total;
    }

    public int getTodayTransactions() {
        int count = 0;
        String todayStr = java.time.LocalDate.now().toString();
        String sql = "SELECT COUNT(*) FROM sales WHERE sale_date BETWEEN ? AND ? AND payment_status != 'CANCELLED'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, todayStr + " 00:00:00");
            ps.setString(2, todayStr + " 23:59:59");
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) count = rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return count;
    }

    public int getTotalProducts() {
        String sql = "SELECT COUNT(*) FROM products";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public int getLowStockCount() {
        String sql = "SELECT COUNT(*) FROM products WHERE stock_quantity <= low_stock_threshold";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }
}