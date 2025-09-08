# 📲 Flutter Push Notification (FCM) Assignment

This project demonstrates how to implement **Firebase Cloud Messaging (FCM)** push notifications in a Flutter app with **full-screen notifications**.

---

![Push Notification Demo](https://github.com/user-attachments/assets/96bfaf6d-62d8-4d05-a464-d0e20d54b714)

## 🔧 Requirements

To complete this project, the following were needed:

- **Firebase Project** with Cloud Messaging enabled.
- `google-services.json` (Android) or `GoogleService-Info.plist` (iOS).
- Flutter dependencies:
  - `firebase_core`
  - `firebase_messaging`
  - `flutter_local_notifications`
  - `permission_handler`

---

## ⚙️ Firebase Setup

1. Create a project in **Firebase Console**.
2. Enable **Cloud Messaging**.
3. Download and configure platform-specific files:
   - `google-services.json` → place inside `android/app/`
   - `GoogleService-Info.plist` → add inside `iOS/Runner/`
4. Enable notification permissions on devices.

---

## 🔔 Example Payload Tested

The app was tested with the following FCM payload (using **Postman** or API call):

```json
{
  "to": "YOUR_DEVICE_FCM_TOKEN",
  "priority": "high",
  "data": {
    "title": "High Importance Notifications",
    "body": "This is a full screen test",
    "route": "/home"
  }
}

