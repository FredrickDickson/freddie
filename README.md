# 🏠 Freddie - Modern Real Estate & Property Management

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Material Design](https://img.shields.io/badge/design-material%203-795548.svg?style=for-the-badge)](https://m3.material.io/)

Freddie is a sophisticated, modern Flutter-based mobile application designed to revolutionize the real estate and property management industry. It provides a seamless experience for property owners, agents, and seekers through a suite of advanced features and a highly responsive user interface.

## ✨ Key Features

- 🤖 **AI Contract Generation**: Automated, intelligent generation of property contracts and agreements.
- 🔍 **Advanced Property Search**: Powerful search and filtering capabilities to find the perfect property.
- 📝 **Property Listings**: Comprehensive management of property listings with rich media support.
- 🛡️ **KYC Verification**: Secure and integrated Know Your Customer (KYC) verification flow.
- 💬 **Real-time Messaging**: Built-in communication system for seamless interaction between users.
- 💳 **Subscription Management**: Tiered subscription plans for enhanced features and visibility.
- 📊 **Interactive Dashboards**: Data-driven insights and analytics for property performance.
- 🗺️ **Map Integration**: Interactive property discovery via Google Maps.
- ✍️ **Digital Signatures**: Integrated signature capture for quick and secure document signing.

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev) (SDK ^3.9.0)
- **Language**: [Dart](https://dart.dev)
- **UI/UX**:
  - `sizer`: For responsive design across all device sizes.
  - `google_fonts`: For premium typography.
  - `flutter_svg`: For high-quality vector icons.
  - `fl_chart`: For advanced data visualization.
- **Core Services**:
  - `dio`: For robust API communication.
  - `shared_preferences`: For efficient local data persistence.
  - `connectivity_plus`: For real-time network status monitoring.
- **Hardware Integration**:
  - `camera` & `image_picker`: For capturing and selecting property images.
  - `google_maps_flutter`: For location-based services.
  - `signature`: For digital document signing.

## 📁 Project Structure

```text
lib/
├── core/           # Core utilities, services, and constants
├── presentation/   # UI Layer: Screens, BLoCs/Providers, and ViewModels
│   ├── ai_contract_generation/
│   ├── authentication/
│   ├── property_dashboard/
│   └── ... (feature-based modules)
├── routes/         # Centralized application routing
├── theme/          # Global styling and theme configuration
├── widgets/        # Reusable UI components and design system
└── main.dart       # Application entry point
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (^3.9.0)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Android SDK / Xcode (for iOS development)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-repo/freddie.git
   cd freddie
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Set up environment:**
   Create an `env.json` file in the root directory (refer to `env.example.json` if available).

4. **Run the application:**
   ```bash
   flutter run
   ```

## 📦 Deployment

Build the production-ready application:

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## 🤝 Acknowledgments

- Powered by [Flutter](https://flutter.dev) & [Dart](https://dart.dev)
- Styled with Material Design 3
- Built with ❤️ for the Real Estate Industry

