# 📱 Employee Leave Management System (ELMS)

A complete Employee Leave Management System built with **Flutter** and **PHP MySQL**. This app allows employees to apply for leaves and admins to manage and approve/reject leave requests.

## ✨ Features

### Admin Features
- 🔐 Secure login
- ➕ Add new employees
- 📋 View all leave requests
- ✅ Approve/reject leaves
- 🔍 Filter leaves by status
- 📊 View employee details

### Employee Features
- 🔐 Secure login
- 📝 Apply for leave with date pickers
- 📅 Multiple leave types (Sick, Casual, Annual, etc.)
- 📜 View leave history
- 🔍 Filter personal leaves
- 📊 Track leave status

## 🛠️ Tech Stack

### Frontend (Mobile App)
- **Flutter** 3.0+
- **Dart** 3.0+
- Material Design 3
- HTTP package for API calls
- Intl package for date formatting

### Backend (API)
- **PHP** 7.4+
- **MySQL** 5.7+
- RESTful API
- XAMPP Server

## 📸 Screenshots

_Add your app screenshots here_

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- XAMPP (Apache + MySQL)
- Android Studio / VS Code
- Android Emulator or Physical Device

### Backend Setup

1. **Install XAMPP** and start Apache & MySQL

2. **Create Database:**
    - Open phpMyAdmin: `http://localhost/phpmyadmin`
    - Create database: `elms_db`
    - Import `database.sql` from the `php_backend` folder

3. **Setup PHP Files:**
    - Copy all PHP files to: `C:\xampp\htdocs\elms_php\`
    - Test: `http://localhost/elms_php/`

4. **Default Credentials:**
    - **Admin:** admin@company.com / admin123
    - **Employee:** emp@gmail.com / emp123

### Flutter App Setup

1. **Clone the repository:**
```bash
git clone https://github.com/developerfozan/Employee_Leave_Management_Flutter.git
cd Employee_Leave_Management_Flutter
```

2. **Install dependencies:**
```bash
flutter pub get
```

3. **Update API URL:**
    - Open `lib/config/constants.dart`
    - Update `baseUrl`:
        - Android Emulator: `http://10.0.2.2/elms_php`
        - Physical Device: `http://YOUR_PC_IP/elms_php`

4. **Run the app:**
```bash
flutter run
```

## 📁 Project Structure
```
lib/
├── config/
│   └── constants.dart              # App configuration
├── core/
│   └── exceptions/
│       └── app_exception.dart      # Custom exceptions
├── models/
│   ├── user_model.dart             # User data model
│   └── leave_model.dart            # Leave data model
├── utils/
│   ├── validators.dart             # Form validators
│   └── date_helper.dart            # Date utilities
├── services/
│   └── api_service.dart            # API calls
├── auth/
│   ├── login_selection_screen.dart
│   └── login_screen.dart
├── screens/
│   ├── admin/                      # Admin screens
│   └── employee/                   # Employee screens
└── main.dart                       # App entry point
```

## 🔧 Configuration

### For Physical Device

1. Find your PC's IP address:
    - Windows: `ipconfig` in CMD
    - Look for IPv4 Address (e.g., 192.168.1.100)

2. Update `lib/config/constants.dart`:
```dart
static const String baseUrl = 'http://192.168.1.100/elms_php';
```

3. Ensure phone and PC are on the same WiFi network

## 🐛 Troubleshooting

### "Connection failed"
- Check if XAMPP Apache is running
- Verify base URL in constants.dart
- For emulator, use `10.0.2.2`
- For device, use your PC's IP

### "Database error"
- Check if MySQL is running
- Verify database name is `elms_db`
- Import database.sql again

## 📦 Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.6.0
  intl: ^0.20.2
  cupertino_icons: ^1.0.8
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 👨‍💻 Developer

**Fozan**
- GitHub: [@developerfozan](https://github.com/developerfozan)

## 🙏 Acknowledgments

- Flutter Team for the amazing framework
- Material Design for UI components
- XAMPP for easy local server setup

## 📞 Support

For support, email your-email@example.com or create an issue in this repository.

---

Made with ❤️ using Flutter