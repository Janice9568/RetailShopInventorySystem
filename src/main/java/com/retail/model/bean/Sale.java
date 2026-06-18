package com.retail.model.bean;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.List;

public class Sale implements Serializable {
    private int saleId;
    private Timestamp saleDate;
    private double totalAmount;
    private String paymentMethod; // CASH, CREDIT_CARD, E-WALLET
    private String paymentStatus; // PAID, UNPAID
    private int userId;
    private String sellerName; // Joined for display
    private List<SaleItem> items;

    public Sale() {}

    public int getSaleId() { return saleId; }
    public void setSaleId(int saleId) { this.saleId = saleId; }

    public Timestamp getSaleDate() { return saleDate; }
    public void setSaleDate(Timestamp saleDate) { this.saleDate = saleDate; }

    // 在你的明细模型类里加上这个字段和 getter/setter
    private String saleDateStr;

    public String getSaleDateStr() {
        return saleDateStr;
    }
    public void setSaleDateStr(String saleDateStr) {
        this.saleDateStr = saleDateStr;
    }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getSellerName() { return sellerName; }
    public void setSellerName(String sellerName) { this.sellerName = sellerName; }

    public List<SaleItem> getItems() { return items; }
    public void setItems(List<SaleItem> items) { this.items = items; }

    private String cancelReason;

    public String getCancelReason() { return cancelReason; }
    public void setCancelReason(String cancelReason) { this.cancelReason = cancelReason; }
}