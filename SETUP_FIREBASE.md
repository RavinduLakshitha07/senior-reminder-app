# Firebase Setup Guide for Senior Reminder App

## Prerequisites
- A Google account (for Firebase Console)
- Flutter SDK already installed

## Step 1: Create a Firebase Project
1. Go to **[Firebase Console](https://console.firebase.google.com)**
2. Click **Add project**
3. Enter project name: `Senior Reminder`
4. Disable Google Analytics (optional) → Click **Create**

## Step 2: Register Android App
1. In Project Overview, click the **Android** icon `</>` to add an Android app
2. **Android package name:** `com.example.senior_reminder_app`
   - This matches the `applicationId` in `android/app/build.gradle.kts`
3. **App nickname:** Senior Reminder (optional)
4. Click **Register app**

## Step 3: Download `google-services.json`
1. Click **Download google-services.json**
2. Place the file at: **`android/app/google-services.json`**
3. Click **Next**

## Step 4: Update Android Gradle Files ✅ (Already Done)

These files have already been modified for you — no action needed.

### 4a. `android/settings.gradle.kts` (Updated ✅)
```kotlin
plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.11.1" apply false
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
    id("com.google.gms.google-services") version "4.5.0" apply false  // ← Added
}
```

### 4b. `android/app/build.gradle.kts` (Updated ✅)
```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")  // ← Added
}

// Inside dependencies block:
dependencies {
    implementation(platform("com.google.firebase:firebase-bom:34.16.0"))   // ← Added
    implementation("com.google.firebase:firebase-analytics")               // ← Added
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}
```

## Step 5: Enable Authentication (Email/Password)
1. In Firebase Console → **Authentication** → **Get started**
2. Go to **Sign-in method** tab
3. Click **Email/Password** → **Enable** → **Save**

## Step 6: Create Firestore Database
1. In Firebase Console → **Firestore Database** → **Create database**
2. Select **Start in test mode** (for development)
3. Choose a Cloud Firestore location (e.g., `nam5` - United States)
4. Click **Enable**

## Step 7: (Optional) Register iOS App
1. In Firebase Console → Project Overview → **Add app** → **iOS**
2. **iOS bundle ID:** `com.example.seniorReminderApp`
3. Download `GoogleService-Info.plist`
4. Open `ios/Runner.xcworkspace` in Xcode
5. Right-click `Runner` → **Add Files to "Runner"** → select `GoogleService-Info.plist`

## Step 8: Verify & Run

### Run these commands:
```bash
cd /Users/ravindulakshitha/senior_reminder_app
flutter clean
flutter pub get
flutter run
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| `google-services.json` not found | Make sure the file is at `android/app/google-services.json` |
| `FirebaseApp` not initialized | Ensure `Firebase.initializeApp()` is called in `main.dart` (already done) |
| Authentication fails | Double-check **Email/Password** is enabled in Firebase Console |
| Firestore permission denied | Set Firestore rules to test mode: `allow read, write: if true;` |
| Build error: duplicate classes | Run `flutter clean` then `flutter pub get` |

---

> **Note:** The app works offline without Firebase for local features (reminders, history, notifications). Firebase is only required for:
> - Cloud backup/sync (Settings → Backup & Sync)
> - User authentication (Login/Sign Up)
> - Cross-device data synchronization
