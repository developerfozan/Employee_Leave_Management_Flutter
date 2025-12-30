-- Create Database
CREATE DATABASE IF NOT EXISTS elms_db;
USE elms_db;

-- Users Table (for both admin and employees)
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    department VARCHAR(100) DEFAULT NULL,
    is_admin TINYINT(1) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Leaves Table
CREATE TABLE IF NOT EXISTS leaves (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    leave_type VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    reason TEXT NOT NULL,
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert Default Admin
-- Password: admin123 (MD5: 0192023a7bbd73250516f069df18b500)
INSERT INTO users (name, email, password, department, is_admin) 
VALUES ('Admin User', 'admin@company.com', '0192023a7bbd73250516f069df18b500', 'Administration', 1);

-- Insert Sample Employee
-- Password: emp123 (MD5: 0b9e9e89da322c9529d2a7e8c05e7d85)
INSERT INTO users (name, email, password, department, is_admin) 
VALUES ('John Doe', 'emp@gmail.com', '0b9e9e89da322c9529d2a7e8c05e7d85', 'IT Department', 0);

-- Insert More Sample Employees
-- All passwords: emp123 (MD5: 0b9e9e89da322c9529d2a7e8c05e7d85)
INSERT INTO users (name, email, password, department, is_admin) 
VALUES 
('Jane Smith', 'jane@company.com', '0b9e9e89da322c9529d2a7e8c05e7d85', 'HR Department', 0),
('Bob Johnson', 'bob@company.com', '0b9e9e89da322c9529d2a7e8c05e7d85', 'Finance', 0),
('Alice Williams', 'alice@company.com', '0b9e9e89da322c9529d2a7e8c05e7d85', 'Marketing', 0);

-- Insert Sample Leave Requests
INSERT INTO leaves (employee_id, leave_type, start_date, end_date, reason, status)
VALUES
(2, 'Sick Leave', '2024-12-15', '2024-12-17', 'Medical appointment and recovery', 'pending'),
(3, 'Casual Leave', '2024-12-20', '2024-12-22', 'Personal work', 'approved'),
(4, 'Annual Leave', '2024-12-25', '2025-01-02', 'Holiday vacation', 'pending'),
(5, 'Sick Leave', '2024-12-18', '2024-12-19', 'Flu symptoms', 'rejected');