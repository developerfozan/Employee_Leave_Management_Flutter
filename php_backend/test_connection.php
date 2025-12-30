<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

require_once 'config.php';

try {
    // Test database connection
    $conn = getDbConnection();
    
    // Test if users table exists
    $result = $conn->query("SELECT COUNT(*) as count FROM users");
    $userCount = $result->fetch_assoc()['count'];
    
    // Test if leaves table exists
    $result = $conn->query("SELECT COUNT(*) as count FROM leaves");
    $leaveCount = $result->fetch_assoc()['count'];
    
    $conn->close();
    
    echo json_encode([
        'success' => true,
        'message' => 'Database connection successful!',
        'data' => [
            'database' => DB_NAME,
            'host' => DB_HOST,
            'total_users' => $userCount,
            'total_leaves' => $leaveCount,
            'timestamp' => date('Y-m-d H:i:s')
        ]
    ]);
    
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'message' => 'Database connection failed',
        'error' => $e->getMessage()
    ]);
}
?>