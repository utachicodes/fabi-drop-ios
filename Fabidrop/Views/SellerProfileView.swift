import SwiftUI

struct SellerProfileView: View {
    let seller: Seller
    @EnvironmentObject var productManager: ProductManager
    @EnvironmentObject var locationManager: LocationManager
    @State private var selectedTab = 0
    @State private var showingContact = false
    
    private var sellerProducts: [Product] {
        return productManager.getProductsBySeller(seller.id)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        Color.blue.opacity(0.2),
                        Color.purple.opacity(0.2),
                        Color("AccentGreen").opacity(0.1)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Seller header
                        FrostedCardView {
                            VStack(spacing: 16) {
                                // Seller info
                                HStack {
                                    // Seller avatar
                                    Circle()
                                        .fill(Color("AccentGreen").opacity(0.2))
                                        .frame(width: 80, height: 80)
                                        .overlay(
                                            Text(String(seller.name.prefix(1)).uppercased())
                                                .font(.title)
                                                .fontWeight(.bold)
                                                .foregroundColor(Color("AccentGreen"))
                                        )
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack {
                                            Text(seller.name)
                                                .font(.title2)
                                                .fontWeight(.bold)
                                            
                                            if seller.isVerified {
                                                Image(systemName: "checkmark.seal.fill")
                                                    .foregroundColor(Color("AccentGreen"))
                                            }
                                        }
                                        
                                        HStack {
                                            Image(systemName: "location.circle.fill")
                                                .foregroundColor(.gray)
                                            Text(seller.location.city ?? "Ville inconnue")
                                                .font(.body)
                                                .foregroundColor(.secondary)
                                        }
                                        
                                        HStack {
                                            Image(systemName: "star.fill")
                                                .foregroundColor(.yellow)
                                            Text(String(format: "%.1f", seller.rating))
                                                .font(.body)
                                                .fontWeight(.medium)
                                            Text("(\(seller.reviewCount) avis)")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    
                                    Spacer()
                                }
                                
                                // Contact button
                                GlassmorphicButton(title: "Contacter le vendeur") {
                                    showingContact = true
                                }
                            }
                            .padding()
                        }
                        .padding(.horizontal)
                        
                        // Seller stats
                        HStack(spacing: 16) {
                            StatCard(
                                title: "Produits",
                                value: "\(sellerProducts.count)",
                                icon: "bag.fill"
                            )
                            
                            StatCard(
                                title: "Note",
                                value: String(format: "%.1f", seller.rating),
                                icon: "star.fill"
                            )
                            
                            if let userLocation = locationManager.location,
                               let distance = locationManager.calculateDistance(to: seller.location) {
                                StatCard(
                                    title: "Distance",
                                    value: locationManager.formatDistance(distance),
                                    icon: "location.fill"
                                )
                            }
                        }
                        .padding(.horizontal)
                        
                        // Tab selector
                        HStack(spacing: 0) {
                            TabButton(
                                title: "Produits",
                                isSelected: selectedTab == 0
                            ) {
                                selectedTab = 0
                            }
                            
                            TabButton(
                                title: "À propos",
                                isSelected: selectedTab == 1
                            ) {
                                selectedTab = 1
                            }
                            
                            TabButton(
                                title: "Avis",
                                isSelected: selectedTab == 2
                            ) {
                                selectedTab = 2
                            }
                        }
                        .padding(.horizontal)
                        
                        // Tab content
                        switch selectedTab {
                        case 0:
                            ProductsTabView(products: sellerProducts)
                        case 1:
                            AboutTabView(seller: seller)
                        case 2:
                            ReviewsTabView(seller: seller)
                        default:
                            EmptyView()
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.top)
                }
            }
            .navigationTitle(seller.name)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Share seller profile
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(Color("AccentGreen"))
                    }
                }
            }
        }
        .sheet(isPresented: $showingContact) {
            ContactSellerView(seller: seller)
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        FrostedCardView {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(Color("AccentGreen"))
                
                Text(value)
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
    }
}

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.body)
                .fontWeight(.medium)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(
                    Rectangle()
                        .fill(isSelected ? Color("AccentGreen") : Color.clear)
                )
                .foregroundColor(isSelected ? .white : .primary)
        }
    }
}

struct ProductsTabView: View {
    let products: [Product]
    @State private var showingProductDetail = false
    @State private var selectedProduct: Product?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Produits (\(products.count))")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            if products.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "bag")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    
                    Text("Aucun produit disponible")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
            } else {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                    ForEach(products) { product in
                        SellerProductCard(product: product) {
                            selectedProduct = product
                            showingProductDetail = true
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct SellerProductCard: View {
    let product: Product
    let onTap: () -> Void
    
    var body: some View {
        FrostedCardView {
            VStack(alignment: .leading, spacing: 8) {
                // Product image
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 120)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.name)
                        .font(.body)
                        .fontWeight(.medium)
                        .lineLimit(2)
                    
                    Text("\(Int(product.price)) XOF")
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(Color("AccentGreen"))
                    
                    HStack {
                        Circle()
                            .fill(product.isAvailable ? Color.green : Color.red)
                            .frame(width: 8, height: 8)
                        
                        Text(product.isAvailable ? "En stock" : "Rupture")
                            .font(.caption)
                            .foregroundColor(product.isAvailable ? .green : .red)
                        
                        Spacer()
                        
                        if product.isAvailable {
                            Text("\(product.stock)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .padding(8)
        }
        .onTapGesture {
            onTap()
        }
    }
}

struct AboutTabView: View {
    let seller: Seller
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("À propos")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            FrostedCardView {
                VStack(alignment: .leading, spacing: 16) {
                    if let description = seller.description {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.body)
                                .fontWeight(.medium)
                            
                            Text(description)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Informations")
                            .font(.body)
                            .fontWeight(.medium)
                        
                        InfoRow(icon: "location.circle.fill", title: "Localisation", value: seller.location.city ?? "Non spécifiée")
                        InfoRow(icon: "phone.fill", title: "Contact", value: seller.contactInfo)
                        InfoRow(icon: "star.fill", title: "Note moyenne", value: String(format: "%.1f/5", seller.rating))
                        InfoRow(icon: "checkmark.seal.fill", title: "Statut", value: seller.isVerified ? "Vérifié" : "Non vérifié")
                    }
                }
                .padding()
            }
            .padding(.horizontal)
        }
    }
}

struct InfoRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Color("AccentGreen"))
                .frame(width: 20)
            
            Text(title)
                .font(.body)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.body)
                .fontWeight(.medium)
        }
    }
}

struct ReviewsTabView: View {
    let seller: Seller
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Avis clients")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            if seller.reviewCount == 0 {
                VStack(spacing: 16) {
                    Image(systemName: "star.slash")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    
                    Text("Aucun avis pour le moment")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
            } else {
                // Sample reviews - in a real app, this would fetch from backend
                VStack(spacing: 12) {
                    ForEach(0..<min(5, seller.reviewCount), id: \.self) { index in
                        ReviewCard(
                            reviewerName: "Client \(index + 1)",
                            rating: Double.random(in: 3.0...5.0),
                            comment: "Excellent vendeur, produits de qualité et livraison rapide !",
                            date: Date().addingTimeInterval(-Double.random(in: 0...2592000)) // Random date within last 30 days
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct ReviewCard: View {
    let reviewerName: String
    let rating: Double
    let comment: String
    let date: Date
    
    var body: some View {
        FrostedCardView {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(reviewerName)
                        .font(.body)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        ForEach(1...5, id: \.self) { star in
                            Image(systemName: star <= Int(rating) ? "star.fill" : "star")
                                .font(.caption)
                                .foregroundColor(.yellow)
                        }
                    }
                }
                
                Text(comment)
                    .font(.body)
                    .foregroundColor(.secondary)
                
                Text(formatDate(date))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

struct ContactSellerView: View {
    let seller: Seller
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        Color.blue.opacity(0.2),
                        Color.purple.opacity(0.2),
                        Color("AccentGreen").opacity(0.1)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // Seller info
                    FrostedCardView {
                        VStack(spacing: 16) {
                            Circle()
                                .fill(Color("AccentGreen").opacity(0.2))
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Text(String(seller.name.prefix(1)).uppercased())
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color("AccentGreen"))
                                )
                            
                            Text(seller.name)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text(seller.location.city ?? "Ville inconnue")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                    }
                    .padding(.horizontal)
                    
                    // Contact options
                    VStack(spacing: 16) {
                        ContactOptionButton(
                            icon: "phone.fill",
                            title: "Appeler",
                            subtitle: seller.contactInfo,
                            action: {
                                // Make phone call
                                if let url = URL(string: "tel:\(seller.contactInfo.replacingOccurrences(of: " ", with: ""))") {
                                    UIApplication.shared.open(url)
                                }
                            }
                        )
                        
                        ContactOptionButton(
                            icon: "message.fill",
                            title: "Envoyer un message",
                            subtitle: "WhatsApp ou SMS",
                            action: {
                                // Send message
                                if let url = URL(string: "https://wa.me/\(seller.contactInfo.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "+", with: ""))") {
                                    UIApplication.shared.open(url)
                                }
                            }
                        )
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.top)
            }
            .navigationTitle("Contacter")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(Color("AccentGreen"))
                }
            }
        }
    }
}

struct ContactOptionButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(Color("AccentGreen"))
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body)
                        .fontWeight(.medium)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview
struct SellerProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleSeller = Seller(
            id: "seller1",
            name: "Boutique Mode Dakar",
            location: Location(latitude: 14.7167, longitude: -17.4677, city: "Dakar"),
            contactInfo: "+221 77 123 4567"
        )
        
        SellerProfileView(seller: sampleSeller)
            .environmentObject(ProductManager())
            .environmentObject(LocationManager())
    }
} 