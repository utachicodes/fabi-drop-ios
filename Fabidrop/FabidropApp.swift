import SwiftUI

@main
struct FabidropApp: App {
    @StateObject private var authManager = AuthManager()
    @StateObject private var locationManager = LocationManager()
    @StateObject private var productManager = ProductManager()
    @StateObject private var paymentManager = PaymentManager()
    @StateObject private var notificationManager = NotificationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authManager)
                .environmentObject(locationManager)
                .environmentObject(productManager)
                .environmentObject(paymentManager)
                .environmentObject(notificationManager)
                .preferredColorScheme(.light)
        }
    }
} 