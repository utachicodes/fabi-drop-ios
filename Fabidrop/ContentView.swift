import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        Group {
            if authManager.isAuthenticated {
                HomeView()
                    .onAppear {
                        // Request location permission when user is authenticated
                        if locationManager.authorizationStatus == .notDetermined {
                            locationManager.requestLocationPermission()
                        }
                    }
            } else {
                LoginView()
            }
        }
        .animation(.easeInOut(duration: 0.3), value: authManager.isAuthenticated)
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthManager())
            .environmentObject(LocationManager())
    }
} 