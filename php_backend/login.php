<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');
header('Content-Type: application/json');

require_once 'config.php';

// Check if it's a POST request
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    sendResponse(false, 'Only POST requests are allowed');
}

// Get POST data
$email = isset($_POST['email']) ? sanitizeInput($_POST['email']) : '';
$password = isset($_POST['password']) ? $_POST['password'] : '';

// Validate required fields
if (empty($email) || empty($password)) {
    sendResponse(false, 'Email and password are required');
}

// Validate email format
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    sendResponse(false, 'Invalid email format');
}

// Get database connection
$conn = getDbConnection();

// Prepare statement to prevent SQL injection
$stmt = $conn->prepare("SELECT id, name, email, department, is_admin, password FROM users WHERE email = ?");
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();

// Check if user exists
if ($result->num_rows === 0) {
    $stmt->close();
    $conn->close();
    sendResponse(false, 'Invalid email or password');
}

// Get user data
$user = $result->fetch_assoc();

// Verify password using MD5
$passwordMd5 = md5($password);

if ($passwordMd5 !== $user['password']) {
    $stmt->close();
    $conn->close();
    sendResponse(false, 'Invalid email or password');
}

// Remove password from response
unset($user['password']);

// Close connections
$stmt->close();
$conn->close();

// Send success response
sendResponse(true, 'Login successful', $user);
?>