import Foundation
import SwiftUI
import PhotosUI

class ProductManager: ObservableObject {
    @Published var products: [Product] = []
    @Published var sellers: [Seller] = []
    @Published var searchResults: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Sample data for demo purposes
    private var sampleProducts: [Product] = []
    private var sampleSellers: [Seller] = []
    
    init() {
        loadSampleData()
    }
    
    // MARK: - Search Methods
    func searchProducts(keyword: String) {
        guard !keyword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            searchResults = []
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        // Simulate API call delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let filteredProducts = self.sampleProducts.filter { product in
                product.name.localizedCaseInsensitiveContains(keyword) ||
                product.description.localizedCaseInsensitiveContains(keyword) ||
                product.tags.contains { $0.localizedCaseInsensitiveContains(keyword) }
            }
            
            DispatchQueue.main.async {
                self.searchResults = filteredProducts
                self.isLoading = false
            }
        }
    }
    
    func searchProductsByImage(_ image: UIImage) {
        isLoading = true
        errorMessage = nil
        
        // Simulate image recognition API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // For demo purposes, return random products
            let randomProducts = Array(self.sampleProducts.shuffled().prefix(5))
            
            DispatchQueue.main.async {
                self.searchResults = randomProducts
                self.isLoading = false
            }
        }
    }
    
    // MARK: - Product Management
    func getProduct(by id: String) -> Product? {
        return sampleProducts.first { $0.id == id }
    }
    
    func getProductsBySeller(_ sellerId: String) -> [Product] {
        return sampleProducts.filter { $0.sellerId == sellerId }
    }
    
    func getProductsByCategory(_ category: ProductCategory) -> [Product] {
        return sampleProducts.filter { $0.category == category }
    }
    
    func getTrendingProducts() -> [Product] {
        // Return products with high ratings or recent activity
        return Array(sampleProducts.shuffled().prefix(6))
    }
    
    // MARK: - Seller Management
    func getSeller(by id: String) -> Seller? {
        return sampleSellers.first { $0.id == id }
    }
    
    func getNearbySellers(location: CLLocation, maxDistance: Double = 50000) -> [Seller] {
        return sampleSellers.filter { seller in
            let sellerLocation = CLLocation(
                latitude: seller.location.latitude,
                longitude: seller.location.longitude
            )
            let distance = location.distance(from: sellerLocation)
            return distance <= maxDistance
        }.sorted { seller1, seller2 in
            let location1 = CLLocation(
                latitude: seller1.location.latitude,
                longitude: seller1.location.longitude
            )
            let location2 = CLLocation(
                latitude: seller2.location.latitude,
                longitude: seller2.location.longitude
            )
            let distance1 = location.distance(from: location1)
            let distance2 = location.distance(from: location2)
            return distance1 < distance2
        }
    }
    
    // MARK: - Custom Request
    func submitCustomRequest(productDetails: String, imageURL: String? = nil, userId: String) -> CustomRequest {
        let request = CustomRequest(
            id: UUID().uuidString,
            userId: userId,
            productDetails: productDetails,
            imageURL: imageURL
        )
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // In a real app, this would be sent to the backend
            print("Custom request submitted: \(request.id)")
        }
        
        return request
    }
    
    // MARK: - Sample Data
    private func loadSampleData() {
        // Sample sellers
        let dakarLocation = Location(latitude: 14.7167, longitude: -17.4677, city: "Dakar")
        let thiesLocation = Location(latitude: 14.7833, longitude: -16.9333, city: "Thiès")
        let tivaouaneLocation = Location(latitude: 14.9500, longitude: -16.8167, city: "Tivaouane")
        
        sampleSellers = [
            Seller(
                id: "seller1",
                name: "Boutique Mode Dakar",
                location: dakarLocation,
                contactInfo: "+221 77 123 4567"
            ),
            Seller(
                id: "seller2",
                name: "Beauté & Co",
                location: dakarLocation,
                contactInfo: "+221 77 234 5678"
            ),
            Seller(
                id: "seller3",
                name: "Tech Store Thiès",
                location: thiesLocation,
                contactInfo: "+221 77 345 6789"
            ),
            Seller(
                id: "seller4",
                name: "Fashion House Tivaouane",
                location: tivaouaneLocation,
                contactInfo: "+221 77 456 7890"
            )
        ]
        
        // Sample products
        sampleProducts = [
            Product(
                id: "prod1",
                name: "Robe Rouge Élégante",
                description: "Robe rouge élégante parfaite pour les occasions spéciales",
                price: 25000,
                stock: 5,
                sellerId: "seller1",
                category: .fashion
            ),
            Product(
                id: "prod2",
                name: "Écouteurs Sans Fil",
                description: "Écouteurs bluetooth haute qualité avec réduction de bruit",
                price: 45000,
                stock: 12,
                sellerId: "seller3",
                category: .tech
            ),
            Product(
                id: "prod3",
                name: "Crème Hydratante Naturelle",
                description: "Crème hydratante 100% naturelle pour tous types de peau",
                price: 8000,
                stock: 20,
                sellerId: "seller2",
                category: .beauty
            ),
            Product(
                id: "prod4",
                name: "Sac à Main Tendance",
                description: "Sac à main moderne et spacieux, parfait pour le quotidien",
                price: 35000,
                stock: 8,
                sellerId: "seller1",
                category: .fashion
            ),
            Product(
                id: "prod5",
                name: "Smartphone Android",
                description: "Smartphone dernière génération avec appareil photo haute résolution",
                price: 180000,
                stock: 3,
                sellerId: "seller3",
                category: .tech
            ),
            Product(
                id: "prod6",
                name: "Parfum Exclusif",
                description: "Parfum exclusif avec des notes florales et boisées",
                price: 55000,
                stock: 15,
                sellerId: "seller2",
                category: .beauty
            ),
            Product(
                id: "prod7",
                name: "Décoration Murale",
                description: "Décoration murale africaine traditionnelle",
                price: 15000,
                stock: 10,
                sellerId: "seller4",
                category: .home
            ),
            Product(
                id: "prod8",
                name: "T-shirt Basique",
                description: "T-shirt en coton bio, confortable et durable",
                price: 12000,
                stock: 25,
                sellerId: "seller1",
                category: .fashion
            )
        ]
        
        // Add tags to products
        sampleProducts[0].tags = ["robe", "rouge", "élégant", "occasion"]
        sampleProducts[1].tags = ["écouteurs", "bluetooth", "sans fil", "audio"]
        sampleProducts[2].tags = ["crème", "hydratante", "naturelle", "peau"]
        sampleProducts[3].tags = ["sac", "main", "tendance", "quotidien"]
        sampleProducts[4].tags = ["smartphone", "android", "photo", "technologie"]
        sampleProducts[5].tags = ["parfum", "exclusif", "floral", "boisé"]
        sampleProducts[6].tags = ["décoration", "murale", "africain", "traditionnel"]
        sampleProducts[7].tags = ["t-shirt", "coton", "bio", "basique"]
        
        // Update sellers with products
        for (index, seller) in sampleSellers.enumerated() {
            sampleSellers[index].products = sampleProducts.filter { $0.sellerId == seller.id }.map { $0.id }
        }
    }
}

// MARK: - Image Picker Helper
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()
            
            guard let provider = results.first?.itemProvider else { return }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        self.parent.selectedImage = image as? UIImage
                    }
                }
            }
        }
    }
} 