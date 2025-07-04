import Foundation
import CoreLocation
import SwiftUI

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    
    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // MARK: - Public Methods
    func requestLocationPermission() {
        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            errorMessage = "Location access is required to show nearby sellers. Please enable it in Settings."
        case .authorizedWhenInUse, .authorizedAlways:
            startLocationUpdates()
        @unknown default:
            break
        }
    }
    
    func startLocationUpdates() {
        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else {
            requestLocationPermission()
            return
        }
        
        isLoading = true
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
        isLoading = false
    }
    
    // MARK: - Distance Calculation
    func calculateDistance(to sellerLocation: Location) -> Double? {
        guard let userLocation = location else { return nil }
        
        let sellerCLLocation = CLLocation(
            latitude: sellerLocation.latitude,
            longitude: sellerLocation.longitude
        )
        
        return userLocation.distance(from: sellerCLLocation)
    }
    
    func formatDistance(_ distance: Double) -> String {
        if distance < 1000 {
            return "\(Int(distance))m"
        } else {
            let kilometers = distance / 1000
            return String(format: "%.1fkm", kilometers)
        }
    }
    
    // MARK: - City Detection
    func getCurrentCity() -> String? {
        guard let location = location else { return nil }
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            DispatchQueue.main.async {
                if let city = placemarks?.first?.locality {
                    // Update user's location with city information
                    let userLocation = Location(
                        latitude: location.coordinate.latitude,
                        longitude: location.coordinate.longitude,
                        city: city
                    )
                    // This would typically update the user's profile
                    print("Current city: \(city)")
                }
            }
        }
        
        return nil // Will be updated asynchronously
    }
    
    // MARK: - Nearby Sellers Filter
    func filterSellersByDistance(_ sellers: [Seller], maxDistance: Double = 50000) -> [Seller] {
        return sellers.filter { seller in
            guard let distance = calculateDistance(to: seller.location) else { return false }
            return distance <= maxDistance
        }.sorted { seller1, seller2 in
            let distance1 = calculateDistance(to: seller1.location) ?? Double.infinity
            let distance2 = calculateDistance(to: seller2.location) ?? Double.infinity
            return distance1 < distance2
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        DispatchQueue.main.async {
            self.location = location
            self.isLoading = false
        }
        
        // Stop updates after getting location
        stopLocationUpdates()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.isLoading = false
            self.errorMessage = "Failed to get location: \(error.localizedDescription)"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.authorizationStatus = status
            
            switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                self.startLocationUpdates()
            case .denied, .restricted:
                self.errorMessage = "Location access denied. Please enable it in Settings to see nearby sellers."
            case .notDetermined:
                break
            @unknown default:
                break
            }
        }
    }
}

// MARK: - Location Permission View
struct LocationPermissionView: View {
    @ObservedObject var locationManager: LocationManager
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "location.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(Color("AccentGreen"))
            
            Text("Enable Location Access")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Fabidrop needs access to your location to show you nearby sellers and provide personalized product recommendations.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            GlassmorphicButton(title: "Enable Location") {
                locationManager.requestLocationPermission()
            }
            
            if let errorMessage = locationManager.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
    }
} 