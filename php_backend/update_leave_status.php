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

// Validate required fields
validateRequired(['leave_id', 'status'], $_POST);

// Get and sanitize input
$leaveId = (int) $_POST['leave_id'];
$status = sanitizeInput($_POST['status']);

// Validate leave ID
if ($leaveId <= 0) {
    sendResponse(false, 'Invalid leave ID');
}

// Validate status
$allowedStatuses = ['approved', 'rejected', 'pending'];
if (!in_array($status, $allowedStatuses)) {
    sendResponse(false, 'Invalid status. Allowed values: approved, rejected, pending');
}

// Get database connection
$conn = getDbConnection();

// Check if leave exists
$checkStmt = $conn->prepare("SELECT id, status FROM leaves WHERE id = ?");
$checkStmt->bind_param("i", $leaveId);
$checkStmt->execute();
$checkResult = $checkStmt->get_result();

if ($checkResult->num_rows === 0) {
    $checkStmt->close();
    $conn->close();
    sendResponse(false, 'Leave request not found');
}

$leave = $checkResult->fetch_assoc();
$checkStmt->close();

// Check if leave is already approved or rejected
if ($leave['status'] === $status) {
    $conn->close();
    sendResponse(false, 'Leave is already ' . $status);
}

// Update leave status
$stmt = $conn->prepare("UPDATE leaves SET status = ?, updated_at = NOW() WHERE id = ?");
$stmt->bind_param("si", $status, $leaveId);

if ($stmt->execute()) {
    $stmt->close();
    $conn->close();
    
    $message = 'Leave request has been ' . $status . ' successfully';
    sendResponse(true, $message);
} else {
    $error = $stmt->error;
    $stmt->close();
    $conn->close();
    sendResponse(false, 'Failed to update leave status: ' . $error);
}
?>