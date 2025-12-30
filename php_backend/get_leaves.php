<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET');
header('Access-Control-Allow-Headers: Content-Type');
header('Content-Type: application/json');

require_once 'config.php';

// Check if it's a GET request
if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    sendResponse(false, 'Only GET requests are allowed');
}

// Get database connection
$conn = getDbConnection();

// Check if employee_id is provided (for employee-specific leaves)
$employeeId = isset($_GET['employee_id']) ? (int) $_GET['employee_id'] : null;

if ($employeeId !== null) {
    // Get leaves for specific employee
    if ($employeeId <= 0) {
        $conn->close();
        sendResponse(false, 'Invalid employee ID');
    }
    
    $stmt = $conn->prepare("
        SELECT 
            l.id,
            l.employee_id,
            u.name,
            u.department,
            l.leave_type,
            l.start_date,
            l.end_date,
            l.reason,
            l.status,
            l.created_at
        FROM leaves l
        JOIN users u ON l.employee_id = u.id
        WHERE l.employee_id = ?
        ORDER BY l.created_at DESC
    ");
    $stmt->bind_param("i", $employeeId);
} else {
    // Get all leaves (for admin)
    $stmt = $conn->prepare("
        SELECT 
            l.id,
            l.employee_id,
            u.name,
            u.department,
            l.leave_type,
            l.start_date,
            l.end_date,
            l.reason,
            l.status,
            l.created_at
        FROM leaves l
        JOIN users u ON l.employee_id = u.id
        ORDER BY 
            CASE l.status
                WHEN 'pending' THEN 1
                WHEN 'approved' THEN 2
                WHEN 'rejected' THEN 3
            END,
            l.created_at DESC
    ");
}

$stmt->execute();
$result = $stmt->get_result();

$leaves = [];
while ($row = $result->fetch_assoc()) {
    $leaves[] = $row;
}

$stmt->close();
$conn->close();

// Send response
if (count($leaves) > 0) {
    sendResponse(true, 'Leaves retrieved successfully', $leaves);
} else {
    sendResponse(true, 'No leave requests found', []);
}
?>