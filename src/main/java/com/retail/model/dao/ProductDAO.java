package com.retail.model.dao;

import com.retail.model.bean.Product;
import com.retail.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, c.category_name, s.supplier_name FROM products p " +
                "LEFT JOIN categories c ON p.category_id = c.category_id " +
                "LEFT JOIN suppliers s ON p.supplier_id = s.supplier_id";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    public Product getProductById(int id) {
        String sql = "SELECT p.*, c.category_name, s.supplier_name FROM products p " +
                "LEFT JOIN categories c ON p.category_id = c.category_id " +
                "LEFT JOIN suppliers s ON p.supplier_id = s.supplier_id WHERE p.product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapResultSetToProduct(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addProduct(Product p) {
        String sql = "INSERT INTO products (product_name, category_id, supplier_id, model, price, stock_quantity, low_stock_threshold) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getProductName());
            ps.setInt(2, p.getCategoryId());
            ps.setInt(3, p.getSupplierId());
            ps.setString(4, p.getModel());
            ps.setDouble(5, p.getPrice());
            ps.setInt(6, p.getStockQuantity());
            ps.setInt(7, p.getLowStockThreshold());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateProduct(Product p) {
        String sql = "UPDATE products SET product_name=?, category_id=?, supplier_id=?, model=?, price=?, low_stock_threshold=? WHERE product_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getProductName());
            ps.setInt(2, p.getCategoryId());
            ps.setInt(3, p.getSupplierId());
            ps.setString(4, p.getModel());
            ps.setDouble(5, p.getPrice());
            ps.setInt(6, p.getLowStockThreshold());
            ps.setInt(7, p.getProductId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteProduct(int id) {
        String sql = "DELETE FROM products WHERE product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateStock(int productId, int changeQty, int userId, String reason) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Update Product Stock
            String updateSql = "UPDATE products SET stock_quantity = stock_quantity + ? WHERE product_id = ?";
            PreparedStatement psUpdate = conn.prepareStatement(updateSql);
            psUpdate.setInt(1, changeQty);
            psUpdate.setInt(2, productId);
            psUpdate.executeUpdate();

            // Log the change (FR3.1)
            String logSql = "INSERT INTO inventory_logs (product_id, user_id, change_quantity, reason) VALUES (?, ?, ?, ?)";
            PreparedStatement psLog = conn.prepareStatement(logSql);
            psLog.setInt(1, productId);
            psLog.setInt(2, userId);
            psLog.setInt(3, changeQty);
            psLog.setString(4, reason);
            psLog.executeUpdate();

            conn.commit();
            return true;
        } catch (SQLException e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    public List<Product> getLowStockProducts() {
        List<Product> lowStockList = new ArrayList<>();
        // 💡 核心 SQL：查出所有 当前库存 <= 警报线 的商品完整信息
        String sql = "SELECT * FROM products WHERE stock_quantity <= low_stock_threshold";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Product p = new Product();
                // 💡 这里的字段名必须严格对应你们 MySQL 里的 products 表的列名
                p.setProductId(rs.getInt("product_id"));
                p.setProductName(rs.getString("product_name"));
                p.setPrice(rs.getDouble("price"));
                p.setStockQuantity(rs.getInt("stock_quantity"));
                p.setLowStockThreshold(rs.getInt("low_stock_threshold"));

                lowStockList.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lowStockList;
    }

    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setProductId(rs.getInt("product_id"));
        p.setProductName(rs.getString("product_name"));
        p.setCategoryId(rs.getInt("category_id"));
        p.setCategoryName(rs.getString("category_name"));
        p.setSupplierId(rs.getInt("supplier_id"));
        p.setSupplierName(rs.getString("supplier_name"));
        p.setModel(rs.getString("model"));
        p.setPrice(rs.getDouble("price"));
        p.setStockQuantity(rs.getInt("stock_quantity"));
        p.setLowStockThreshold(rs.getInt("low_stock_threshold"));
        return p;
    }
}