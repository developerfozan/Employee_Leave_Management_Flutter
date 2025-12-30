<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, PUT, DELETE');
header('Access-Control-Allow-Headers: Content-Type');
header('Content-Type: application/json');

require_once 'config.php';

// Check if it's a POST request
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    sendResponse(false, 'Only POST requests are allowed');
}

// Get action
$action = isset($_POST['action']) ? sanitizeInput($_POST['action']) : '';

if ($action === 'add') {
    addEmployee();
} else {
    sendResponse(false, 'Invalid action');
}

function addEmployee() {
    // Validate required fields
    validateRequired(['name', 'email', 'password', 'department'], $_POST);
    
    $name = sanitizeInput($_POST['name']);
    $email = sanitizeInput($_POST['email']);
    $password = $_POST['password'];
    $department = sanitizeInput($_POST['department']);
    
    // Validate email format
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        sendResponse(false, 'Invalid email format');
    }
    
    // Validate password length
    if (strlen($password) < 6) {
        sendResponse(false, 'Password must be at least 6 characters');
    }
    
    // Get database connection
    $conn = getDbConnection();
    
    // Check if email already exists
    $checkStmt = $conn->prepare("SELECT id FROM users WHERE email = ?");
    $checkStmt->bind_param("s", $email);
    $checkStmt->execute();
    $checkResult = $checkStmt->get_result();
    
    if ($checkResult->num_rows > 0) {
        $checkStmt->close();
        $conn->close();
        sendResponse(false, 'Email already exists');
    }
    $checkStmt->close();
    
    // Hash password using MD5
    $hashedPassword = md5($password);
    
    // Insert new employee
    $stmt = $conn->prepare("INSERT INTO users (name, email, password, department, is_admin) VALUES (?, ?, ?, ?, 0)");
    $stmt->bind_param("ssss", $name, $email, $hashedPassword, $department);
    
    if ($stmt->execute()) {
        $stmt->close();
        $conn->close();
        sendResponse(true, 'Employee added successfully');
    } else {
        $stmt->close();
        $conn->close();
        sendResponse(false, 'Failed to add employee: ' . $conn->error);
    }
}
?>