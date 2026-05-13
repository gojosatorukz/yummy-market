# AITU Sports Market 🛒

A cross-platform e-commerce mobile application developed as the Final Project for the Mobile Development course at Astana IT University. The application demonstrates mastery of state management, local/cloud persistence, and complex UI layouts using Clean Architecture principles.

## 📱 Features
* **Product Catalog:** Fetches and displays a list of sports products and equipment using an external REST API.
* **Shopping Cart:** Real-time cart state management with automatic total price calculation.
* **Favorites (Local Persistence):** Users can save favorite products locally on their device, available offline.
* **Order Checkout (Cloud):** Submits the finalized order details and total sum directly to a cloud database.
* **Theme Switching:** Toggles between Light and Dark modes, saving user preferences automatically.
* **Responsive UI:** Uses GridView for a responsive product catalog and complex layouts.

## 🛠 Tech Stack
This project strict adherence to **Clean Architecture** (separating UI, Domain, and Data layers) and utilizes the following modern Flutter packages:
* **State Management & Dependency Injection:** `flutter_riverpod`
* **Navigation:** `go_router` (Declarative routing)
* **Network / API:** `chopper` & `json_annotation` (FakeStoreAPI integration)
* **Local Database:** `drift` & `sqlite3` (For complex structured data)
* **Cloud Persistence:** `cloud_firestore` & `firebase_core` (For order history)
* **Local Settings:** `shared_preferences` (For theme persistence)
* **Code Generation:** `build_runner` & `freezed`

## 📂 Project Architecture
```text
lib/
 ├── core/               # Routing and global constants
 ├── data/               # Data layer (API, Drift DB, Models, Repositories)
 ├── presentation/       # UI layer
 │    ├── providers/     # Riverpod state notifiers
 │    ├── screens/       # Main app screens
 │    └── widgets/       # Reusable UI components
 └── main.dart           # App entry point

```

## 🚀 Setup & Installation

Follow these steps to run the project locally:

1. **Clone the repository:**
```bash
git clone <your-repo-link>
cd yummy_market

```


2. **Install dependencies:**
```bash
flutter pub get

```


3. **Generate code (for Drift, Chopper, and Freezed):**
```bash
dart run build_runner build --delete-conflicting-outputs

```


4. **Connect Firebase:**
Run the FlutterFire CLI to generate your `firebase_options.dart` file:
```bash
dart pub global run flutterfire_cli:flutterfire configure

```


*(Ensure you enable Firestore in Test Mode in your Firebase Console).*
5. **Run the app:**
```bash
flutter run

```



## 👨‍💻 Author

**Bekzat Rashiduly**
Software Engineering Student | Astana IT University