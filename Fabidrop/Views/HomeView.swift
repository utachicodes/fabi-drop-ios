import SwiftUI
import PhotosUI

struct HomeView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var productManager: ProductManager
    @EnvironmentObject var locationManager: LocationManager
    @State private var searchText = ""
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var showingSearchResults = false
    @State private var showingCustomRequest = false
    
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
                        // Welcome section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Bonjour, \(authManager.currentUser?.name.components(separatedBy: " ").first ?? "Utilisateur")")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("Que recherchez-vous aujourd'hui ?")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        
                        // Search section
                        VStack(spacing: 16) {
                            GlassmorphicSearchBar(
                                placeholder: "Rechercher un produit...",
                                text: $searchText
                            ) {
                                performSearch()
                            }
                            
                            HStack(spacing: 12) {
                                GlassmorphicImagePicker(title: "Recherche par image") {
                                    showingImagePicker = true
                                }
                                
                                GlassmorphicButton(title: "Demande personnalisée", isPrimary: false) {
                                    showingCustomRequest = true
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Location status
                        if locationManager.authorizationStatus == .denied || locationManager.authorizationStatus == .restricted {
                            LocationPermissionView(locationManager: locationManager)
                                .padding(.horizontal)
                        }
                        
                        // Trending products
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Produits tendance")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                
                                Spacer()
                                
                                Button("Voir tout") {
                                    // Navigate to all products
                                }
                                .font(.body)
                                .foregroundColor(Color("AccentGreen"))
                            }
                            .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(productManager.getTrendingProducts()) { product in
                                        TrendingProductCard(product: product)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        // Categories
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Catégories")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                                ForEach(ProductCategory.allCases, id: \.self) { category in
                                    CategoryCard(category: category)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Nearby sellers
                        if locationManager.location != nil {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Vendeurs à proximité")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .padding(.horizontal)
                                
                                let nearbySellers = locationManager.getNearbySellers(
                                    location: locationManager.location!,
                                    maxDistance: 50000
                                )
                                
                                if !nearbySellers.isEmpty {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 16) {
                                            ForEach(nearbySellers.prefix(5)) { seller in
                                                NearbySellerCard(seller: seller)
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                } else {
                                    Text("Aucun vendeur trouvé à proximité")
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                }
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.top)
                }
            }
            .navigationTitle("Fabidrop")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Show profile or settings
                    }) {
                        Image(systemName: "person.circle")
                            .font(.title2)
                            .foregroundColor(Color("AccentGreen"))
                    }
                }
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .onChange(of: selectedImage) { image in
            if let image = image {
                productManager.searchProductsByImage(image)
                showingSearchResults = true
            }
        }
        .sheet(isPresented: $showingSearchResults) {
            SearchResultsView(searchResults: productManager.searchResults)
        }
        .sheet(isPresented: $showingCustomRequest) {
            CustomRequestView()
        }
    }
    
    private func performSearch() {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        productManager.searchProducts(keyword: searchText)
        showingSearchResults = true
    }
}

struct TrendingProductCard: View {
    let product: Product
    
    var body: some View {
        FrostedCardView {
            VStack(alignment: .leading, spacing: 8) {
                // Product image placeholder
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 120, height: 120)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.name)
                        .font(.caption)
                        .fontWeight(.medium)
                        .lineLimit(2)
                    
                    Text("\(Int(product.price)) XOF")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(Color("AccentGreen"))
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .font(.caption2)
                            .foregroundColor(.yellow)
                        
                        Text("4.5")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .frame(width: 120)
            .padding(8)
        }
    }
}

struct CategoryCard: View {
    let category: ProductCategory
    
    var body: some View {
        FrostedCardView {
            VStack(spacing: 12) {
                Image(systemName: categoryIcon)
                    .font(.title2)
                    .foregroundColor(Color("AccentGreen"))
                
                Text(category.displayName)
                    .font(.body)
                    .fontWeight(.medium)
            }
            .frame(height: 80)
            .padding()
        }
    }
    
    private var categoryIcon: String {
        switch category {
        case .fashion: return "tshirt"
        case .beauty: return "sparkles"
        case .tech: return "laptopcomputer"
        case .home: return "house"
        case .other: return "ellipsis.circle"
        }
    }
}

struct NearbySellerCard: View {
    let seller: Seller
    
    var body: some View {
        FrostedCardView {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(seller.name)
                            .font(.body)
                            .fontWeight(.medium)
                        
                        Text(seller.location.city ?? "Ville inconnue")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    if seller.isVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(Color("AccentGreen"))
                    }
                }
                
                HStack {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundColor(.yellow)
                    
                    Text(String(format: "%.1f", seller.rating))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("(\(seller.reviewCount))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .frame(width: 200)
        }
    }
}

// MARK: - Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AuthManager())
            .environmentObject(ProductManager())
            .environmentObject(LocationManager())
    }
} 