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
validateRequired(['employee_id', 'leave_type', 'start_date', 'end_date', 'reason'], $_POST);

// Get and sanitize input
$employeeId = (int) $_POST['employee_id'];
$leaveType = sanitizeInput($_POST['leave_type']);
$startDate = sanitizeInput($_POST['start_date']);
$endDate = sanitizeInput($_POST['end_date']);
$reason = sanitizeInput($_POST['reason']);

// Validate employee ID
if ($employeeId <= 0) {
    sendResponse(false, 'Invalid employee ID');
}

// Validate dates
$startDateTime = DateTime::createFromFormat('Y-m-d', $startDate);
$endDateTime = DateTime::createFromFormat('Y-m-d', $endDate);

if (!$startDateTime || !$endDateTime) {
    sendResponse(false, 'Invalid date format. Use YYYY-MM-DD');
}

// Check if end date is after start date
if ($endDateTime < $startDateTime) {
    sendResponse(false, 'End date must be after or equal to start date');
}

// Check if dates are not in the past
$today = new DateTime();
$today->setTime(0, 0, 0);

if ($startDateTime < $today) {
    sendResponse(false, 'Start date cannot be in the past');
}

// Validate reason length
if (strlen($reason) < 10) {
    sendResponse(false, 'Reason must be at least 10 characters');
}

if (strlen($reason) > 500) {
    sendResponse(false, 'Reason must be less than 500 characters');
}

// Get database connection
$conn = getDbConnection();

// Check if employee exists and is not an admin
$checkStmt = $conn->prepare("SELECT is_admin FROM users WHERE id = ?");
$checkStmt->bind_param("i", $employeeId);
$checkStmt->execute();
$checkResult = $checkStmt->get_result();

if ($checkResult->num_rows === 0) {
    $checkStmt->close();
    $conn->close();
    sendResponse(false, 'Employee not found');
}

$user = $checkResult->fetch_assoc();
if ($user['is_admin'] == 1) {
    $checkStmt->close();
    $conn->close();
    sendResponse(false, 'Admins cannot apply for leave');
}
$checkStmt->close();

// Check for overlapping leave dates
$overlapStmt = $conn->prepare("
    SELECT id FROM leaves 
    WHERE employee_id = ? 
    AND status != 'rejected'
    AND (
        (start_date <= ? AND end_date >= ?) OR
        (start_date <= ? AND end_date >= ?) OR
        (start_date >= ? AND end_date <= ?)
    )
");
$overlapStmt->bind_param("issssss", $employeeId, $startDate, $startDate, $endDate, $endDate, $startDate, $endDate);
$overlapStmt->execute();
$overlapResult = $overlapStmt->get_result();

if ($overlapResult->num_rows > 0) {
    $overlapStmt->close();
    $conn->close();
    sendResponse(false, 'You already have a leave request for these dates');
}
$overlapStmt->close();

// Insert leave request
$stmt = $conn->prepare("INSERT INTO leaves (employee_id, leave_type, start_date, end_date, reason, status) VALUES (?, ?, ?, ?, ?, 'pending')");
$stmt->bind_param("issss", $employeeId, $leaveType, $startDate, $endDate, $reason);

if ($stmt->execute()) {
    $leaveId = $stmt->insert_id;
    $stmt->close();
    $conn->close();
    sendResponse(true, 'Leave application submitted successfully', ['leave_id' => $leaveId]);
} else {
    $error = $stmt->error;
    $stmt->close();
    $conn->close();
    sendResponse(false, 'Failed to submit leave application: ' . $error);
}
?>