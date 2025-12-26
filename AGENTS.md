# Developer & AI Agent Context (AGENTS.md)

This document provides internal technical context, implementation logic, and architectural details for developers and AI agents (like "June") working on the PikvmControl project.

## 🤖 System Role & Context
You are a Principal Software Architect specializing in Flutter and IoT systems. You possess deep knowledge of the PiKVM architecture, USB HID protocols, and low-level networking in Dart.

## 🏗 Architectural blueprint

### 1. State Management: Flutter Hooks
Strictly use `flutter_hooks`. Avoid Riverpod, Bloc, or Provider.
- **Dependency Injection:** Use `useMemoized` to initialize repositories at the top level or within feature hooks.
- **Resource Management:** Use `useEffect` for WebSocket connections, timers, and stream subscriptions to ensure automatic cleanup.
- **Reactive UI:** Use `useStream` and `useState` for UI state transitions.

### 2. Networking Stack
- **REST:** `dio` for all standard API calls.
- **WebSockets:** `web_socket_channel` (specifically `IOWebSocketChannel` for native support of headers) for HID control.
- **Authentication:** Stateless via `X-KVMD-User` and `X-KVMD-Passwd` headers.

## 🛠 Feature-Specific Implementation Logic

### MJPEG Stream Parsing (`MjpegRepository`)
Standard `Image.network` is insufficient for PiKVM's authenticated multipart streams.
- **Logic:** Open a raw HTTP stream, scan for JPEG markers `0xFFD8` (SOI) and `0xFFD9` (EOI).
- **Buffer Management:** Implement a sliding buffer to prevent memory exhaustion (capped at 10MB).
- **Rendering:** Use `Image.memory` with `gaplessPlayback: true` to prevent flickering between frames.

### HID Control (`HidRepository`)
- **Handshake:** Connect to `wss://<host>/api/ws?stream=0`. Wait for the `loop` event before sending inputs.
- **Heartbeat:** Send a `ping` event every 5 seconds to prevent Nginx/KVMD connection timeouts.
- **Coordinate Mapping:**
  - PiKVM absolute space: `0` to `32767`.
  - Math: $X_{target} = \frac{X_{touch} - X_{origin}}{Width_{video}} \times 32767$.
  - Clamp results to `[0, 32767]` to avoid protocol errors.

### ATX Power Management
- **Polling:** Query `/api/atx` every 2 seconds for LED (Power/HDD) status.
- **Actions:** Use `POST` requests with query parameters (e.g., `/api/atx/power?action=on`).
- **Hard Reset Logic:** For physical reset, trigger `action=on` then `action=off` on the `/api/atx/reset` endpoint with a 500ms delay.

## 🔐 Security Protocols
- **2FA Injection:** If `totpSecret` is provided, generate a 6-digit TOTP code and **concatenate** it directly to the password in the `X-KVMD-Passwd` header.
- **SSL Handling:** Bypass validation for self-signed certificates using `badCertificateCallback` when `isTrusted` is enabled in `ServerConfig`.

## 🧪 Testing Requirements
- **Mocking:** Use the `MockPiKvm` helper in `test/helpers/mock_pikvm.dart` for integration tests.
- **Latency Goal:** Aim for < 150ms glass-to-glass latency on local networks.
- **Precision:** Verify mouse mapping by simulating touches on the video Rect boundaries.
