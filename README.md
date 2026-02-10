# Tampon In? 🩸
Time to change it? 

A mobile timer app to track menstrual product wear time with safety alerts and usage history.

## Features

- **6 Product Types**: Track different period products with product-specific timing
  - Disposable Pad (3.5h recommended, 8h max)
  - Tampon (6h recommended, 8h max)
  - Menstrual Cup (10h recommended, 12h max)
  - Menstrual Disc (10h recommended, 12h max)
  - Period Underwear (10h recommended, 12h max)
  - Reusable Pad (5h recommended, 12h max)

- **Timer Tracking**: Real-time countdown in HH:MM:SS format
- **Progress Visualization**: Color-coded progress bar (cyan → orange → red)
- **Smart Notifications**: Two-tier notification system
  - Recommended time: "⏰ Time to Consider Changing"
  - Maximum time: "⚠️ CHANGE NOW!"
- **Safety Warnings**: Visual alerts with pulsing animations when approaching limits
- **Session History**: Track your last 20 sessions with timestamps and color-coded warnings
- **Glass-morphism UI**: Modern design with light rose gradient background

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- VS Code or Android Studio (recommended IDE)

### Installation

1. Install Flutter by following the [official installation guide](https://docs.flutter.dev/get-started/install)

2. Verify your installation:
   ```bash
   flutter doctor
   ```

3. Get dependencies:
   ```bash
   flutter pub get
   ```

### Running the App

- Run on connected device/emulator:
  ```bash
  flutter run
  ```

- Run in debug mode:
  ```bash
  flutter run --debug
  ```

- Run in release mode:
  ```bash
  flutter run --release
  ```

### Building the App

- Build APK (Android):
  ```bash
  flutter build apk
  ```

- Build iOS:
  ```bash
  flutter build ios
  ```

- Build Web:
  ```bash
  flutter build web
  ```

## How It Works

1. **Select Your Product**: Choose from 6 different period product types
2. **Start Tracking**: Press the large green button to start the timer
3. **Monitor Status**: Watch the color-coded display (cyan = safe, orange = warning, red = danger)
4. **Get Notified**: Receive alerts at recommended and maximum times
5. **Reset & Log**: Press the red button to reset and automatically save to history

## Project Structure

```
tin/
├── lib/
│   ├── main.dart                       # Main application entry point
│   ├── models/
│   │   ├── product_type.dart           # Product types and timing configs
│   │   └── session_history.dart        # History data model
│   ├── screens/
│   │   └── home_screen.dart            # Main timer screen
│   ├── services/
│   │   ├── timer_service.dart          # Timer tracking logic
│   │   ├── notification_service.dart   # Two-tier notifications
│   │   └── history_service.dart        # Session history storage
│   └── widgets/
│       ├── product_selector.dart       # Horizontal product selector
│       ├── circular_button.dart        # Large start/reset button
│       ├── timer_display.dart          # Timer with progress bar
│       └── history_section.dart        # Scrollable history list
├── pubspec.yaml                        # Flutter dependencies
└── README.md                           # This file
```

## Development

### Architecture

- **Services**: Singleton pattern for business logic (Timer, Notifications, History)
- **Models**: Data models for products and session history
- **Widgets**: Reusable UI components with animations
- **Persistence**: `shared_preferences` for timer state and history storage
- **Notifications**: Two-tier system using `flutter_local_notifications` and `timezone`

### Design Features

- **Light Rose Gradient**: Beautiful gradient background (light pink to almost white)
- **Glass-morphism**: Semi-transparent cards with backdrop blur effect
- **Color Coding**: Cyan (safe) → Orange (warning) → Red (danger)
- **Animations**: Pulsing effects for urgent states, smooth transitions
- **Touch-Friendly**: Large buttons (192px circular button, 112px product cards)

### Platform Setup

#### Mobile (iOS/Android)
1. Run `flutter pub get`
2. Connect device or start emulator
3. Run `flutter run`
4. Grant notification permissions when prompted

#### Web
1. Run `flutter run -d chrome`
2. Note: Web notifications work differently than mobile

#### macOS
1. Run `flutter run -d macos`
2. Full notification support

## Safety Notice

⚠️ **Important**: These are general guidelines based on medical recommendations. Always follow your healthcare provider's advice regarding menstrual product usage. The app is designed to help you stay safe, but it's not a substitute for medical advice.
