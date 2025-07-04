

# Fabidrop Product Requirements Document (PRD)

## 1. Introduction

### 1.1 Purpose
This Product Requirements Document (PRD) defines the specifications, features, and implementation plan for Fabidrop, an iOS mobile application designed to enable users in Senegal to discover and purchase trendy products (e.g., fashion, beauty, tech) seen on social media platforms like TikTok and Instagram from local sellers. The app aims to streamline product discovery, promote local commerce, and provide a visually stunning, glassmorphic user interface (UI) built with SwiftUI. This document serves as a comprehensive guide to ensure alignment on the app’s vision, functionality, and one-month development timeline for the Minimum Viable Product (MVP).

### 1.2 Scope
The Fabidrop MVP will include:
- Keyword and image-based product search.
- Local seller discovery with price, stock, and delivery information.
- Custom request system for products not available locally.
- In-app ordering and payment via Apple Pay and local gateways (e.g., Orange Money, Wave).
- Push notifications for order updates and custom request responses.
- Glassmorphic UI design with frosted-glass effects, vibrant green (#00FF7F) accents, and SF Pro typography.
- Support for French and Wolof languages.
- Deployment to the iOS App Store within one month.

Future phases will introduce local deals, a buyer community space, smart recommendations, and seller partnerships.

### 1.3 Target Audience
- **Primary Users**: Young adults (18–35) in Senegal (e.g., Dakar, Thiès, Tivaouane) who discover trendy products on social media and seek to purchase them locally.
- **Secondary Users**: Local sellers (small businesses, boutiques) offering fashion, beauty, or tech products, looking to reach a digital audience.
- **Demographics**: Tech-savvy, urban, social media users with basic smartphone proficiency.

### 1.4 Business Objectives
- **Connect Buyers and Sellers**: Facilitate seamless connections between young buyers and local sellers in Senegal.
- **Simplify Product Discovery**: Enable users to quickly locate trendy products seen online.
- **Promote Local Commerce**: Prioritize local businesses over foreign e-commerce platforms.
- **Establish Market Leadership**: Position Fabidrop as the leading app for social media-inspired shopping in Senegal.
- **Deliver Aesthetic Appeal**: Create a modern, glassmorphic UI that resonates with young users.
- **Rapid Development**: Launch a functional MVP within one month.

## 2. Product Vision and Goals

### 2.1 Vision
Fabidrop aspires to be Senegal’s premier mobile platform for discovering and purchasing trendy products inspired by social media, empowering local businesses and delivering a visually captivating, user-friendly experience through a glassmorphic design.

### 2.2 Long-Term Goals
- Build a trusted database of verified sellers across Senegal.
- Become the primary platform for social media-driven shopping in West Africa.
- Introduce advanced features: local deals, buyer community space, smart recommendations, and seller partnerships.
- Expand to other West African markets post-MVP.

### 2.3 Success Metrics
- **User Engagement**:
  - 10,000 active users within 6 months post-launch.
  - Average of 3 searches per user per week.
- **Seller Adoption**:
  - Onboard 100 verified sellers within 3 months.
  - 80% seller retention rate after 6 months.
- **Order Volume**:
  - 1,000 orders processed within 3 months.
  - 90% order completion rate (successful deliveries).
- **User Satisfaction**:
  - Achieve an App Store rating of 4.5/5.
  - 80% of custom requests fulfilled within 48 hours.
- **UI Appeal**:
  - 80% positive user feedback on glassmorphic design in user testing.

## 3. Functional Requirements

### 3.1 Core Features
1. **Product Search**:
   - **Keyword Search**: Users can input keywords (e.g., “red dress,” “wireless earbuds”) to find products.
     - Input: Text field with autocomplete suggestions.
     - Output: List of matching products from local sellers.
   - **Image-Based Search**: Users can upload screenshots or photos of products seen on social media.
     - Input: Image upload via PhotosPicker.
     - Output: Matching products based on image recognition analysis.
   - **Priority**: High.
2. **Local Seller Discovery**:
   - Display sellers based on user’s location (e.g., Dakar, Thiès, Tivaouane).
   - Show product details: image, name, price, stock status, delivery options, seller name, and rating.
   - Include filters for sorting by price, distance, or rating.
   - **Priority**: High.
3. **Custom Request System**:
   - Allow users to submit requests for products not found locally.
   - Form fields: Product description (text), optional image upload, contact info.
   - Backend team or sellers respond with availability or sourcing options within 48 hours.
   - **Priority**: Medium.
4. **In-App Ordering and Delivery**:
   - Enable users to add products to a cart, select delivery options (standard, express), and pay via Apple Pay or local gateways.
   - Track order status (e.g., “Processing,” “Shipped,” “Delivered”).
   - **Priority**: High.
5. **Push Notifications**:
   - Notify users of order updates, custom request responses, and new local deals.
   - Support opt-in for notifications during onboarding.
   - **Priority**: Medium.

### 3.2 Additional Features
- **User Profiles**:
  - Save preferences, view order history, manage custom requests.
  - Support Apple Sign-In and email/password authentication.
- **Seller Profiles**:
  - Display seller name, location, ratings, reviews, and product catalog.
  - Include contact button for direct communication.
- **Localization**:
  - Support French and Wolof with iOS localization.
- **Accessibility**:
  - Ensure VoiceOver compatibility, high-contrast text, and large touch targets.
- **Glassmorphic UI**:
  - Implement frosted-glass effects (`.ultraThinMaterial`), vibrant green (#00FF7F) accents, rounded corners, and subtle shadows across all screens.

### 3.3 User Flows
1. **Onboarding**:
   - User downloads app from App Store.
   - Signs up via Apple Sign-In or email/password.
   - Grants location access for personalized results.
   - Selects preferred language (French or Wolof).
2. **Product Search**:
   - User navigates to Home screen.
   - Enters keyword in search bar or uploads image via PhotosPicker.
   - Views results in a glassmorphic list with filters (price, distance).
3. **Custom Request**:
   - If no results, user selects “Custom Request” from search screen.
   - Submits form with product details and optional image.
   - Receives notification when team/seller responds.
4. **Ordering**:
   - User selects product, adds to cart, and chooses delivery option.
   - Completes payment via Apple Pay or local gateway.
   - Tracks order status in profile.
5. **Seller Interaction**:
   - User views seller profile from product details.
   - Contacts seller or leaves a review post-purchase.
6. **Notifications**:
   - User receives push notifications for order updates or custom request responses.

## 4. Non-Functional Requirements

### 4.1 Usability
- **Intuitive Interface**: Glassmorphic design with frosted-glass cards, vibrant green (#00FF7F) accents, and SF Pro font for a modern, beginner-friendly experience.
- **Navigation**: Core actions (search, order, custom request) completed in ≤3 taps.
- **Localization**: Seamless French and Wolof support with language switching.
- **Accessibility**: VoiceOver compatibility, high-contrast text, and large touch targets.

### 4.2 Performance
- **Search Speed**: Keyword search results load in ≤2 seconds; image search results in ≤5 seconds under normal network conditions.
- **Concurrency**: Support 10,000 concurrent users without degradation.
- **UI Rendering**: Glassmorphic effects (blur, shadows) render smoothly on iPhone 8 and newer.
- **App Size**: ≤100 MB for fast downloads in Senegal.

### 4.3 Scalability
- Support expansion to additional Senegal cities and West African markets.
- Database must handle ≥1,000 sellers and 10,000 products.

### 4.4 Security
- **Authentication**: Secure login with Apple Sign-In and email/password.
- **Data Protection**: Encrypt user data (location, payment details) using HTTPS and secure storage.
- **Payments**: Secure transactions via Apple Pay and local gateways.
- **Privacy**: Comply with App Store privacy policies and Senegal data regulations.

### 4.5 Reliability
- **Uptime**: 99.9% app availability.
- **Error Handling**: Graceful handling of failed searches, uploads, or payments with clear error messages.
- **Backup**: Regular database backups to prevent data loss.

## 5. Technical Architecture

### 5.1 System Overview
Fabidrop is an iOS app with a SwiftUI frontend featuring glassmorphic design, a serverless backend, and integrations with Apple’s native frameworks and external APIs. The architecture prioritizes rapid development, scalability, and a seamless user experience.

### 5.2 Technology Stack
- **Frontend**:
  - **SwiftUI**: Declarative framework for glassmorphic UI with `.ultraThinMaterial`, `UIVisualEffectView`, and custom gradients.
  - **Design Tool**: Figma for creating high-fidelity glassmorphic mockups, exportable to SwiftUI.
- **Backend**:
  - **Firebase**:
    - **Firestore**: NoSQL database for users, sellers, products, orders, custom requests.
    - **Functions**: Serverless logic for custom requests and notifications.
    - **Authentication**: Apple Sign-In and email/password.
    - **Storage**: Store user-uploaded images and product photos.
  - **Node.js**: Used in Firebase Functions for server-side logic.
- **Image-Based Search**:
  - **Google Cloud Vision API**: Pre-trained image recognition for matching uploaded screenshots to products.
- **Geolocation**:
  - **Core Location**: Native iOS framework for user location and proximity-based seller filtering.
  - **MapKit** (optional): For displaying sellers on a map view.
- **Payment Gateway**:
  - **Stripe**: Supports Apple Pay and local gateways (e.g., Orange Money, Wave).
- **Notifications**:
  - **Firebase Cloud Messaging (FCM)**: Push notifications via Apple Push Notification Service (APNS).
- **Development Environment**:
  - **Xcode**: For iOS builds, testing, and App Store submission.
  - **Figma-to-SwiftUI Plugin**: Converts mockups to initial SwiftUI code.

### 5.3 System Components
1. **Frontend (SwiftUI)**:
   - **Login View**: Apple Sign-In and email/password form with glassmorphic design.
   - **Home View**: Search bar, PhotosPicker button, trending products grid on frosted-glass cards.
   - **Search Results View**: Product list with filters, displayed on glassmorphic cards.
   - **Custom Request View**: Form with text field, image upload, and submit button.
   - **Checkout View**: Product summary, delivery options, Apple Pay button.
   - **Seller Profile View**: Seller details, product grid, contact button, and reviews.
   - **Reusable Component**: `FrostedCardView` for consistent glassmorphic styling.
2. **Backend Services (Firebase)**:
   - **Search Service**: Handles keyword and image-based searches via Firestore and Vision API.
   - **Location Service**: Filters sellers by proximity using Core Location data.
   - **Order Management**: Processes orders and tracks status.
   - **Custom Request Service**: Manages user requests and seller responses.
   - **Notification Service**: Triggers FCM notifications.
3. **Database Schema (Firestore)**:
   - **Users**: `{ userID, name, email, location, orderHistory, preferences }`
   - **Sellers**: `{ sellerID, name, location, products, rating, contactInfo }`
   - **Products**: `{ productID, name, description, images, price, stock, sellerID }`
   - **Orders**: `{ orderID, userID, productID, status, deliveryDetails }`
   - **Custom Requests**: `{ requestID, userID, productDetails, imageURL, status }`

### 5.4 Glassmorphic UI Design
- **Style Guide**:
  - **Background**: Translucent white with `.ultraThinMaterial` for frosted-glass effect.
  - **Accents**: Vibrant green (#00FF7F) for buttons, highlights, and borders.
  - **Cards**: Semi-transparent with rounded corners (12px radius), subtle shadows (radius 5), and `.ultraThinMaterial`.
  - **Typography**: SF Pro (Regular, Medium, Bold) for iOS consistency.
  - **Icons**: SF Symbols with green accents for navigation and actions.
- **Implementation**:
  - Use `FrostedCardView` for reusable UI components.
  - Apply `.background(.ultraThinMaterial)` and `.shadow(radius: 5)` for glassmorphic effects.
  - Optimize blur effects for performance on older iPhones (e.g., iPhone 8).

## 6. User Stories
- **As a user**, I want to search for products by keyword or image to find items seen on social media.
- **As a user**, I want to view local sellers near my location with price and stock details to choose the best option.
- **As a user**, I want to submit custom requests for unavailable products to have them sourced locally.
- **As a user**, I want to order products in-app with Apple Pay or local gateways for a seamless checkout.
- **As a user**, I want notifications for order updates and custom request responses to stay informed.
- **As a user**, I want a visually stunning, glassmorphic interface that is modern and easy to use.
- **As a seller**, I want a profile to showcase my products and ratings to attract buyers.
- **As a seller**, I want to receive custom requests to expand my offerings.

## 7. Login System
### 7.1 Requirements
- **Authentication Methods**:
  - Apple Sign-In: Primary method for seamless iOS integration.
  - Email/Password: Secondary option for users without Apple ID.
- **Onboarding**:
  - Prompt users to sign in during first app launch.
  - Request location permissions for personalized results.
  - Allow language selection (French or Wolof).
- **Security**:
  - Secure login with Firebase Authentication.
  - Store user credentials securely with encryption.
  - Support single sign-on (SSO) via Apple Sign-In.
- **User Profile**:
  - Display name, email, location, order history, and preferences.
  - Allow profile editing and notification settings management.

### 7.2 User Flow
1. **App Launch**:
   - Welcome screen with “Sign In with Apple” and “Email/Password” options.
   - Glassmorphic design with frosted background and green (#00FF7F) buttons.
2. **Sign-In**:
   - Apple Sign-In: User authenticates via Apple ID, granting name and email.
   - Email/Password: User enters credentials or registers with email verification.
3. **Permissions**:
   - App requests location access (“Allow While Using App”).
   - User selects language (French or Wolof).
4. **Home Screen**:
   - User lands on Home screen post-login, with location-based content.

## 8. Implementation Plan

### 8.1 Development Timeline (4 Weeks)
The one-month timeline focuses on rapid development of the MVP, leveraging a serverless backend and efficient frontend framework.

#### Week 1: Setup and UI Prototyping
- **Tasks**:
  - Set up iOS development environment (Xcode, project configuration).
  - Create glassmorphic mockups in Figma for Login, Home, Search Results, Custom Request, Checkout, and Seller Profile screens.
  - Implement SwiftUI screens with glassmorphic design (`.ultraThinMaterial`, green accents).
  - Configure backend services (database, authentication, storage).
  - Test UI in iOS Simulator.
- **Deliverables**: Glassmorphic UI prototype, backend setup, login flow (~5 days).

#### Week 2: Backend and Search
- **Tasks**:
  - Implement database schemas and queries for keyword search.
  - Integrate image recognition API for image-based search.
  - Add geolocation for proximity-based seller filtering.
  - Test search functionality with sample data (10 sellers, 50 products).
- **Deliverables**: Functional search (keyword and image) with location filtering (~5 days).

#### Week 3: Ordering and Notifications
- **Tasks**:
  - Integrate payment gateway with Apple Pay.
  - Implement order placement and tracking logic.
  - Set up push notifications for order updates and custom requests.
  - Test end-to-end flow: search → select product → checkout → notification.
- **Deliverables**: Complete ordering system with notifications (~4 days).

#### Week 4: Testing and Deployment
- **Tasks**:
  - Debug glassmorphic UI performance (e.g., blur effects).
  - Implement French/Wolof localization.
  - Conduct user testing via TestFlight.
  - Prepare App Store submission (icons, screenshots, privacy policy).
- **Deliverables**: App ready for App Store submission (~4 days).

### 8.2 Development Tools
- **Xcode**: For iOS builds, testing, and App Store submission.
- **Figma**: For glassmorphic mockups and design-to-code export.
- **Backend Console**: For managing database, serverless functions, and notifications.
- **Google Cloud Console**: For image recognition API setup and monitoring.

## 9. Risks and Mitigations
- **Risk**: Glassmorphic UI impacts performance on older iPhones.
  - **Mitigation**: Optimize blur effects and test on iPhone 8.
- **Risk**: Inaccurate image-based search results.
  - **Mitigation**: Prioritize keyword search, use image search as secondary, and collect user feedback.
- **Risk**: Limited seller participation.
  - **Mitigation**: Offer free listings and promotional features.
- **Risk**: Tight one-month timeline.
  - **Mitigation**: Focus on MVP features and leverage serverless architecture.
- **Risk**: Payment gateway integration delays.
  - **Mitigation**: Start with Apple Pay, add local gateways post-MVP.

## 10. Assumptions
- A solo developer or small team with Swift experience.
- Access to free-tier backend and API services.
- Initial seller data (10–20 sellers) for testing.
- Stable internet for API integrations.
- User testing group for TestFlight feedback.

## 11. Future Enhancements
- **Local Deals**: Add a deals section with time-limited promotions.
- **Buyer Community**: Create a forum for user reviews and photos.
- **Smart Recommendations**: Implement on-device product suggestions.
- **Seller Partnerships**: Offer verified badges and expand catalogs.
- **Cross-Platform**: Develop Android version post-MVP.

## 12. Appendix
### 12.1 Glassmorphic Style Guide
- **Colors**:
  - Primary: White (#FFFFFF) with `.ultraThinMaterial`.
  - Accent: Vibrant green (#00FF7F) for buttons, highlights, borders.
- **Typography**: SF Pro (Regular, Medium, Bold).
- **Effects**:
  - Blur: `.ultraThinMaterial` for backgrounds and cards.
  - Shadows: `.shadow(radius: 5, x: 0, y: 2)`.
  - Corners: `.cornerRadius(12)` for cards and buttons.
- **Icons**: SF Symbols with green accents.

### 12.2 Sample Database Schema
```json
{
  "users": {
    "userID": "string",
    "name": "string",
    "email": "string",
    "location": { "latitude": "double", "longitude": "double" },
    "orderHistory": ["orderID"],
    "preferences": { "language": "French|Wolof" }
  },
  "sellers": {
    "sellerID": "string",
    "name": "string",
    "location": { "latitude": "double", "longitude": "double" },
    "products": ["productID"],
    "rating": "double",
    "contactInfo": "string"
  },
  "products": {
    "productID": "string",
    "name": "string",
    "description": "string",
    "images": ["string"],
    "price": "double",
    "stock": "int",
    "sellerID": "string"
  },
  "orders": {
    "orderID": "string",
    "userID": "string",
    "productID": "string",
    "status": "Processing|Shipped|Delivered",
    "deliveryDetails": { "基本的には「標準」「エクスプレス」 }.
    "customRequests": {
      "requestID": "string",
      "userID": "string",
      "productDetails": "string",
      "imageURL": "string",
      "status": "Pending|InProgress|Completed"
    }
  }
}
```

### 12.3 Dependencies
- **SwiftUI**: iOS 15.0+ for `.ultraThinMaterial`.
- **Firebase SDK**: For database, authentication, functions, storage, notifications.
- **Google Cloud Vision API**: For image-based search.
- **Stripe iOS SDK**: For Apple Pay and local gateways.
- **Core Location**: For geolocation.

## 13. Conclusion
Fabidrop is set to transform local commerce in Senegal by connecting young buyers with local sellers for social media-inspired products. Its glassmorphic UI, built with SwiftUI, delivers a modern, engaging experience. The one-month timeline is achievable through a serverless backend, native iOS frameworks, and efficient development practices. This PRD provides a complete roadmap for stakeholders, ensuring the MVP is delivered on time and supports Fabidrop’s vision of empowering local businesses and simplifying product discovery.

