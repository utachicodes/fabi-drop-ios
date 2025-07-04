# Fabidrop

**Fabidrop** is a modern iOS app that lets users in Senegal discover and purchase trendy products seen on social media from local sellers. Built with SwiftUI, it features a stunning glassmorphic UI, vibrant green accents, and a seamless, local-first shopping experience.

---

## Features

- **Keyword & Image Search:** Find products by text or upload screenshots/photos
- **Local Seller Discovery:** See sellers near you, with price, stock, and delivery info
- **Custom Requests:** Request products not found locally
- **In-App Ordering & Payment:** Apple Pay and local gateways (Orange Money, Wave)
- **Push Notifications:** Order updates and custom request responses
- **Glassmorphic UI:** Modern, frosted-glass design with vibrant green (#00FF7F) accents
- **French Localization:** Full French language support (Wolof coming soon)

---

## Tech Stack

- **SwiftUI** (iOS 15+)
- **Firebase** (Firestore, Auth, Storage, Functions, FCM)
- **Google Cloud Vision API** (image search)
- **Stripe iOS SDK** (Apple Pay, local payments)
- **Core Location** (geolocation)
- **SF Symbols & SF Pro Rounded** (icons & typography)

---

## Getting Started

### 1. Clone the Repository
```bash
$ git clone https://github.com/yourusername/fabidrop-ios.git
$ cd fabidrop-ios
```

### 2. Open in Xcode
- Open `Fabidrop.xcodeproj` in Xcode 15 or later

### 3. Install Dependencies
- Use Swift Package Manager to add:
  - Firebase (Firestore, Auth, Storage, Functions, Messaging)
  - Stripe iOS SDK
- (Optional) Add Google Cloud Vision API client if using image search

### 4. Configure Firebase
- Create a Firebase project
- Download `GoogleService-Info.plist` and add it to the `Fabidrop` target
- Enable Firestore, Auth, Storage, and FCM in the Firebase console

### 5. Set Up Apple Pay & Local Payments
- Configure Apple Pay in your Apple Developer account
- Set up Stripe and local payment gateways (Orange Money, Wave)

### 6. Run the App
- Select a simulator or device and hit **Run** (⌘R)

---

## Development Workflow

- **Branching:** Use feature branches (`feature/xyz`) for new features
- **Commits:** Write clear, descriptive commit messages
- **Pull Requests:** Open PRs for review before merging to `main`
- **Testing:** Add unit/UI tests for new features (coming soon)
- **Localization:** Use `Localizable.strings` for all user-facing text
- **Assets:** Place images and icons in `Assets.xcassets`

---

## Project Structure

```
Fabidrop/
├── Assets.xcassets/         # App icons, colors, images
├── Managers/                # Auth, Product, Location, Payment, Notification
├── Models/                  # Data models (User, Seller, Product, etc.)
├── Views/                   # SwiftUI screens & components
├── Localization/            # Localizable.strings (French)
├── Info.plist               # App configuration & permissions
├── ContentView.swift        # Main app entry point
├── FabidropApp.swift        # App lifecycle
└── ...
```

---

## Contributing

1. Fork the repo and create your branch: `git checkout -b feature/your-feature`
2. Commit your changes: `git commit -m 'Add some feature'`
3. Push to the branch: `git push origin feature/your-feature`
4. Open a Pull Request

**Please follow the code style and add tests where possible.**

---

## License

[MIT](LICENSE)

---

## Credits

- Design & Development: [Your Name]
- Inspired by Senegalese youth, local sellers, and the vibrant social shopping scene

---

## Roadmap

- [ ] Backend integration (Firebase, Stripe, Vision API)
- [ ] Wolof localization
- [ ] Advanced analytics & crash reporting
- [ ] UI/UX polish & accessibility improvements
- [ ] App Store launch

---

**Fabidrop — Social shopping, local power.** 