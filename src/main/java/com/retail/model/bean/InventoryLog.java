package com.retail.model.bean;

import java.io.Serializable;
import java.sql.Timestamp;

public class InventoryLog implements Serializable {
    private int logId;
    private int productId;
    private String productName; // Joined for display
    private int userId;
    private String userName;    // Joined for display
    private int changeQuantity;
    private String reason;
    private Timestamp logDate;

    public InventoryLog() {}

    public int getLogId() { return logId; }
    public void setLogId(int logId) { this.logId = logId; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public int getChangeQuantity() { return changeQuantity; }
    public void setChangeQuantity(int changeQuantity) { this.changeQuantity = changeQuantity; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public Timestamp getLogDate() { return logDate; }
    public void setLogDate(Timestamp logDate) { this.logDate = logDate; }
}