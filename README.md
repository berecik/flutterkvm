# FlutterKVM

A native Flutter client for PiKVM (V3 and V4) devices, designed for high-performance remote server management from mobile devices.

## 🚀 Features

- **Low-Latency Video:** Custom MJPEG stream parser for real-time visual feedback.
- **HID Control:** Full keyboard and absolute mouse support (mapped to 0-32767 coordinate space).
- **ATX Power Management:** Physical power control (On/Off/Reset) with real-time LED status polling.
- **Secure Networking:** Support for 2FA/TOTP, custom authentication headers, and self-signed SSL certificate handling.
- **Clean Architecture:** Built with a functional core and hooks-based dependency injection.

## 🏗 Architecture & System Design

### PiKVM Service Topology
FlutterKVM interfaces with a complex microservices architecture running on the PiKVM device (Arch Linux ARM):
- **KVMD (Keyboard Video Mouse Daemon):** The central orchestration layer (Python). Manages GPIO for ATX, USB Gadget subsystem for HID, and user authentication.
- **uStreamer:** Optimized C-based video streamer. Provides ultra-low latency MJPEG feeds via `/stream`.
- **Nginx:** Acts as a reverse proxy, terminating SSL and routing traffic to internal services.
- **Janus (Future):** Used for H.264/WebRTC streaming.

### Technical Implementation
The project follows Clean Architecture principles, ensuring separation of concerns:

- **Entities:** Immutable data models using `freezed`.
- **Repositories:** Data layer handling network protocols:
  - **MJPEG Parsing:** Manual byte-level scanning for `0xFFD8`/`0xFFD9` markers to bypass browser/widget limitations and inject custom headers.
  - **HID over WebSocket:** 16-bit absolute coordinate mapping (`0-32767`) for precise touch-to-mouse translation.
- **Hooks:** State management and dependency injection using `flutter_hooks`.
- **Presentation:** High-performance UI components.

### State Management & DI
Strictly uses `flutter_hooks`. Dependency injection is achieved via `useMemoized` inside custom hooks or high-level widgets. This functional approach ensures automatic resource disposal and minimal boilerplate.

## 🛠 Installation

### Prerequisites
- Flutter SDK (Latest Stable)
- Android Studio / Xcode (for mobile deployment)

### Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/berecik/flutterkvm.git
   cd flutterkvm
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Generate code:**
   The project uses `freezed` and `json_serializable`. Generate the necessary files with:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

## ⚙️ Configuration

The application connects to a PiKVM instance using the `ServerConfig` entity.

```dart
final config = ServerConfig(
  host: 'your-pikvm-ip',
  port: 443,
  username: 'admin',
  password: 'your-password',
  totpSecret: 'your-totp-secret', // Optional
  isTrusted: true, // Set to true to bypass self-signed SSL checks
);
```

### Authentication
FlutterKVM uses the `X-KVMD-User` and `X-KVMD-Passwd` headers for stateless authentication. If a TOTP secret is provided, the code is automatically appended to the password.

## 🧪 Testing

The project includes a comprehensive suite of unit and integration tests.

### Running Tests
```bash
flutter test
```

### Mock PiKVM Server
For development and integration testing without a physical device, a `MockPiKvm` server is included in `test/helpers/mock_pikvm.dart`. It simulates:
- REST API (/api/info, /api/atx)
- MJPEG Stream (/stream)
- HID WebSocket (/api/ws)

## 📱 Supported Platforms
- **Android:** Native performance via `Dio` and `IOWebSocketChannel`.
- **iOS:** Full support for secure networking and touch-to-mouse mapping.
- **Linux/macOS/Windows:** Functional for desktop use.

## 🛡 Security & Connectivity

### Authentication
FlutterKVM uses the `X-KVMD-User` and `X-KVMD-Passwd` headers for stateless authentication.
- **2FA/TOTP:** If a TOTP secret is provided, the code is automatically generated and **concatenated** to the password string (e.g., `password123456`).
- **SSL Certificates:** Handles self-signed certificates via `badCertificateCallback` when `isTrusted` is enabled in `ServerConfig`. We recommend a Trust-On-First-Use (TOFU) model for production implementations.

### Hardware Compatibility
Designed to work with:
- **PiKVM V3:** Full support for ATX and HID.
- **PiKVM V4 (Mini/Plus):** Optimized for V4 endpoint management.
- **DIY Builds (V2):** Compatible with standard uStreamer/KVMD setups.

---
*Built with ❤️ for the PiKVM community.*
