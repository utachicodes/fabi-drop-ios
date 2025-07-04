import Foundation
import CoreLocation

// MARK: - User Model
struct User: Identifiable, Codable {
    let id: String
    var name: String
    var email: String
    var location: Location?
    var orderHistory: [String] // Order IDs
    var preferences: UserPreferences
    
    init(id: String, name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
        self.location = nil
        self.orderHistory = []
        self.preferences = UserPreferences()
    }
}

struct UserPreferences: Codable {
    var language: Language = .french
    var notificationsEnabled: Bool = true
    var deliveryPreference: DeliveryType = .standard
}

enum Language: String, CaseIterable, Codable {
    case french = "fr"
    case wolof = "wo"
    
    var displayName: String {
        switch self {
        case .french: return "Français"
        case .wolof: return "Wolof"
        }
    }
}

// MARK: - Location Model
struct Location: Codable {
    let latitude: Double
    let longitude: Double
    let city: String?
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(latitude: Double, longitude: Double, city: String? = nil) {
        self.latitude = latitude
        self.longitude = longitude
        self.city = city
    }
}

// MARK: - Seller Model
struct Seller: Identifiable, Codable {
    let id: String
    var name: String
    var location: Location
    var products: [String] // Product IDs
    var rating: Double
    var reviewCount: Int
    var contactInfo: String
    var description: String?
    var isVerified: Bool = false
    
    init(id: String, name: String, location: Location, contactInfo: String) {
        self.id = id
        self.name = name
        self.location = location
        self.products = []
        self.rating = 0.0
        self.reviewCount = 0
        self.contactInfo = contactInfo
    }
}

// MARK: - Product Model
struct Product: Identifiable, Codable {
    let id: String
    var name: String
    var description: String
    var images: [String] // Image URLs
    var price: Double
    var stock: Int
    var sellerId: String
    var category: ProductCategory
    var tags: [String]
    var isAvailable: Bool {
        return stock > 0
    }
    
    init(id: String, name: String, description: String, price: Double, stock: Int, sellerId: String, category: ProductCategory) {
        self.id = id
        self.name = name
        self.description = description
        self.images = []
        self.price = price
        self.stock = stock
        self.sellerId = sellerId
        self.category = category
        self.tags = []
    }
}

enum ProductCategory: String, CaseIterable, Codable {
    case fashion = "fashion"
    case beauty = "beauty"
    case tech = "tech"
    case home = "home"
    case other = "other"
    
    var displayName: String {
        switch self {
        case .fashion: return "Mode"
        case .beauty: return "Beauté"
        case .tech: return "Technologie"
        case .home: return "Maison"
        case .other: return "Autre"
        }
    }
}

// MARK: - Order Model
struct Order: Identifiable, Codable {
    let id: String
    var userId: String
    var productId: String
    var sellerId: String
    var status: OrderStatus
    var deliveryDetails: DeliveryDetails
    var createdAt: Date
    var updatedAt: Date
    
    init(id: String, userId: String, productId: String, sellerId: String, deliveryDetails: DeliveryDetails) {
        self.id = id
        self.userId = userId
        self.productId = productId
        self.sellerId = sellerId
        self.status = .processing
        self.deliveryDetails = deliveryDetails
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

enum OrderStatus: String, CaseIterable, Codable {
    case processing = "processing"
    case shipped = "shipped"
    case delivered = "delivered"
    case cancelled = "cancelled"
    
    var displayName: String {
        switch self {
        case .processing: return "En cours"
        case .shipped: return "Expédié"
        case .delivered: return "Livré"
        case .cancelled: return "Annulé"
        }
    }
}

struct DeliveryDetails: Codable {
    var type: DeliveryType
    var address: String
    var phoneNumber: String
    var estimatedDelivery: Date?
    var trackingNumber: String?
    
    init(type: DeliveryType, address: String, phoneNumber: String) {
        self.type = type
        self.address = address
        self.phoneNumber = phoneNumber
    }
}

enum DeliveryType: String, CaseIterable, Codable {
    case standard = "standard"
    case express = "express"
    
    var displayName: String {
        switch self {
        case .standard: return "Standard"
        case .express: return "Express"
        }
    }
    
    var deliveryTime: String {
        switch self {
        case .standard: return "2-3 jours"
        case .express: return "24h"
        }
    }
}

// MARK: - Custom Request Model
struct CustomRequest: Identifiable, Codable {
    let id: String
    var userId: String
    var productDetails: String
    var imageURL: String?
    var status: RequestStatus
    var createdAt: Date
    var responseMessage: String?
    var responseDate: Date?
    
    init(id: String, userId: String, productDetails: String, imageURL: String? = nil) {
        self.id = id
        self.userId = userId
        self.productDetails = productDetails
        self.imageURL = imageURL
        self.status = .pending
        self.createdAt = Date()
    }
}

enum RequestStatus: String, CaseIterable, Codable {
    case pending = "pending"
    case inProgress = "inProgress"
    case completed = "completed"
    case cancelled = "cancelled"
    
    var displayName: String {
        switch self {
        case .pending: return "En attente"
        case .inProgress: return "En cours"
        case .completed: return "Terminé"
        case .cancelled: return "Annulé"
        }
    }
}

// MARK: - Search Result Model
struct SearchResult {
    let products: [Product]
    let sellers: [Seller]
    let totalCount: Int
    let searchQuery: String
    let searchType: SearchType
}

enum SearchType {
    case keyword
    case image
}

// MARK: - Cart Model
struct CartItem: Identifiable {
    let id = UUID()
    let product: Product
    var quantity: Int
    var deliveryType: DeliveryType
    
    var totalPrice: Double {
        return product.price * Double(quantity)
    }
}

// MARK: - Payment Model
struct PaymentDetails {
    let amount: Double
    let currency: String = "XOF"
    let paymentMethod: PaymentMethod
    let orderId: String
}

enum PaymentMethod: String, CaseIterable {
    case applePay = "apple_pay"
    case orangeMoney = "orange_money"
    case wave = "wave"
    
    var displayName: String {
        switch self {
        case .applePay: return "Apple Pay"
        case .orangeMoney: return "Orange Money"
        case .wave: return "Wave"
        }
    }
} 