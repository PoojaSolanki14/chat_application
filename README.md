
```markdown
# Talkzy - Real-Time Chat Application

Talkzy is a real-time chat application built using Flutter and Firebase. It provides users with a fast, secure, and seamless messaging experience including features like text messaging, image/video sharing, voice notes, friend invitations, emoji support, and push notifications.

---

## 📱 Features

- Real-time text messaging
- Send and receive images, videos, and voice notes
- User authentication with email/password and Google Sign-In
- Friend invitation through shareable links
- Emojis support with emoji picker
- Beautiful and responsive UI (Light and Dark Mode)
- User profile management
- Add, delete, and chat with friends

---

## 🛠 Technologies Used

- **Frontend**: Flutter (Dart)
- **Backend**: Firebase
  - Firestore (Database)
  - Firebase Storage
  - Firebase Authentication
  - Firebase Cloud Messaging (Push Notifications)
- **IDE**: Android Studio
- **Version Control**: GitHub

---

## 🗂 Project Structure

```
lib/
├── components/
├── pages/
├── services/
├── themes/
├── models/
assets/
```

- `components/` - UI components like chat bubbles, custom buttons, etc.
- `pages/` - All application screens (login, register, home, chat, settings, etc.)
- `services/` - Authentication and Chat Services (Firebase interactions)
- `themes/` - Light and dark theme settings
- `models/` - Data models like Message
- `assets/` - App images, icons, etc.

---

## 🚀 How to Run Locally

1. Clone the repository:

```bash
git clone https://github.com/<your-username>/<your-repo-name>.git
```

2. Navigate into the project directory:

```bash
cd cablenetworkTV
```

3. Install dependencies:

```bash
flutter pub get
```

4. Set up Firebase:
   - Create a Firebase project.
   - Add Android/iOS app to Firebase.
   - Download `google-services.json` (for Android) and place it inside `android/app/`.
   - Configure Firebase for iOS if needed.

5. Run the app:

```bash
flutter run
```

---

## 📸 App Snapshots

- Login Page
- Register Page  
- Chat Screen  
- Friends List  
- Invite Friends Feature  
- Settings (Dark Mode Toggle)

(*Screenshots can be added if available*)

---

## 🧠 Project Motivation

This project was developed as part of the M.Sc. (I.T.) Semester 4 Industrial Project at  
**Dr. V. R. Godhaniya College of Information Technology, Porbandar**, affiliated with **Bhakta Kavi Narsinh Mehta University**.

---

## 👩‍💻 Developer

**Pooja V. Solanki**  
M.Sc. (I.T.) – Semester 4  
Dr. V. R. Godhaniya College of Information Technology

---

## 📜 License

This project is licensed for academic purposes.

