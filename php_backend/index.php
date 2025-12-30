<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ELMS API - Employee Leave Management System</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
        }
        h1 {
            color: #667eea;
            margin-bottom: 10px;
            font-size: 2.5em;
        }
        .subtitle {
            color: #666;
            margin-bottom: 30px;
            font-size: 1.2em;
        }
        .status {
            display: inline-block;
            padding: 10px 20px;
            background: #10b981;
            color: white;
            border-radius: 20px;
            margin-bottom: 30px;
            font-weight: bold;
        }
        .endpoint {
            background: #f8f9fa;
            padding: 20px;
            margin-bottom: 20px;
            border-radius: 10px;
            border-left: 4px solid #667eea;
        }
        .endpoint h3 {
            color: #667eea;
            margin-bottom: 10px;
        }
        .method {
            display: inline-block;
            padding: 5px 15px;
            background: #667eea;
            color: white;
            border-radius: 5px;
            font-weight: bold;
            margin-bottom: 10px;
            font-size: 0.9em;
        }
        .method.get {
            background: #10b981;
        }
        .method.post {
            background: #3b82f6;
        }
        code {
            background: #e5e7eb;
            padding: 3px 8px;
            border-radius: 4px;
            font-family: 'Courier New', monospace;
            font-size: 0.9em;
        }
        .params {
            margin-top: 10px;
        }
        .params strong {
            color: #667eea;
        }
        .test-btn {
            display: inline-block;
            padding: 10px 20px;
            background: #10b981;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            margin-top: 10px;
            transition: background 0.3s;
        }
        .test-btn:hover {
            background: #059669;
        }
        .credentials {
            background: #fef3c7;
            padding: 20px;
            border-radius: 10px;
            margin-top: 30px;
            border-left: 4px solid #f59e0b;
        }
        .credentials h3 {
            color: #f59e0b;
            margin-bottom: 15px;
        }
        .cred-item {
            margin-bottom: 10px;
            font-family: 'Courier New', monospace;
        }
        .footer {
            margin-top: 40px;
            text-align: center;
            color: #666;
            padding-top: 20px;
            border-top: 2px solid #e5e7eb;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 ELMS API</h1>
        <p class="subtitle">Employee Leave Management System - REST API</p>
        <div class="status">✅ API is Running</div>

        <div class="endpoint">
            <span class="method get">GET</span>
            <h3>Test Connection</h3>
            <p><code>/test_connection.php</code></p>
            <p>Test database connection and get API status</p>
            <a href="test_connection.php" class="test-btn" target="_blank">🔍 Test Now</a>
        </div>

        <div class="endpoint">
            <span class="method post">POST</span>
            <h3>Login</h3>
            <p><code>/login.php</code></p>
            <div class="params">
                <strong>Parameters:</strong>
                <ul>
                    <li><code>email</code> - User email address</li>
                    <li><code>password</code> - User password</li>
                </ul>
            </div>
        </div>

        <div class="endpoint">
            <span class="method post">POST</span>
            <h3>Add Employee</h3>
            <p><code>/employees_crud.php</code></p>
            <div class="params">
                <strong>Parameters:</strong>
                <ul>
                    <li><code>action</code> - Set to "add"</li>
                    <li><code>name</code> - Employee name</li>
                    <li><code>email</code> - Employee email</li>
                    <li><code>password</code> - Employee password</li>
                    <li><code>department</code> - Department name</li>
                </ul>
            </div>
        </div>

        <div class="endpoint">
            <span class="method post">POST</span>
            <h3>Apply Leave</h3>
            <p><code>/apply_leave.php</code></p>
            <div class="params">
                <strong>Parameters:</strong>
                <ul>
                    <li><code>employee_id</code> - Employee ID</li>
                    <li><code>leave_type</code> - Type of leave</li>
                    <li><code>start_date</code> - Start date (YYYY-MM-DD)</li>
                    <li><code>end_date</code> - End date (YYYY-MM-DD)</li>
                    <li><code>reason</code> - Reason for leave</li>
                </ul>
            </div>
        </div>

        <div class="endpoint">
            <span class="method get">GET</span>
            <h3>Get Leaves</h3>
            <p><code>/get_leaves.php</code></p>
            <div class="params">
                <strong>Optional Parameters:</strong>
                <ul>
                    <li><code>employee_id</code> - Get leaves for specific employee (omit for all leaves)</li>
                </ul>
            </div>
        </div>

        <div class="endpoint">
            <span class="method post">POST</span>
            <h3>Update Leave Status</h3>
            <p><code>/update_leave_status.php</code></p>
            <div class="params">
                <strong>Parameters:</strong>
                <ul>
                    <li><code>leave_id</code> - Leave request ID</li>
                    <li><code>status</code> - New status (approved/rejected/pending)</li>
                </ul>
            </div>
        </div>

        <div class="credentials">
            <h3>🔑 Default Login Credentials</h3>
            <div class="cred-item">
                <strong>Admin:</strong><br>
                Email: admin@company.com<br>
                Password: admin123
            </div>
            <div class="cred-item" style="margin-top: 15px;">
                <strong>Employee:</strong><br>
                Email: emp@gmail.com<br>
                Password: emp123
            </div>
        </div>

        <div class="footer">
            <p><strong>Base URL:</strong> http://localhost/elms_php/</p>
            <p style="margin-top: 10px;">
                For Android Emulator use: <code>http://10.0.2.2/elms_php/</code><br>
                For Physical Device use: <code>http://YOUR_PC_IP/elms_php/</code>
            </p>
            <p style="margin-top: 20px;">© 2024 ELMS API - All Rights Reserved</p>
        </div>
    </div>
</body>
</html>