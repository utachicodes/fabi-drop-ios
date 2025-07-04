import SwiftUI

struct SearchResultsView: View {
    let searchResults: [Product]
    @EnvironmentObject var productManager: ProductManager
    @EnvironmentObject var locationManager: LocationManager
    @State private var selectedSortOption: SortOption = .relevance
    @State private var selectedCategory: ProductCategory?
    @State private var showingFilters = false
    @State private var showingProductDetail = false
    @State private var selectedProduct: Product?
    
    enum SortOption: String, CaseIterable {
        case relevance = "relevance"
        case priceLowToHigh = "price_low"
        case priceHighToLow = "price_high"
        case distance = "distance"
        case rating = "rating"
        
        var displayName: String {
            switch self {
            case .relevance: return "Pertinence"
            case .priceLowToHigh: return "Prix croissant"
            case .priceHighToLow: return "Prix décroissant"
            case .distance: return "Distance"
            case .rating: return "Note"
            }
        }
    }
    
    var filteredAndSortedResults: [Product] {
        var results = searchResults
        
        // Apply category filter
        if let category = selectedCategory {
            results = results.filter { $0.category == category }
        }
        
        // Apply sorting
        switch selectedSortOption {
        case .relevance:
            // Keep original order
            break
        case .priceLowToHigh:
            results.sort { $0.price < $1.price }
        case .priceHighToLow:
            results.sort { $0.price > $1.price }
        case .distance:
            if let userLocation = locationManager.location {
                results.sort { product1, product2 in
                    guard let seller1 = productManager.getSeller(by: product1.sellerId),
                          let seller2 = productManager.getSeller(by: product2.sellerId) else {
                        return false
                    }
                    
                    let distance1 = locationManager.calculateDistance(to: seller1.location) ?? Double.infinity
                    let distance2 = locationManager.calculateDistance(to: seller2.location) ?? Double.infinity
                    return distance1 < distance2
                }
            }
        case .rating:
            results.sort { product1, product2 in
                guard let seller1 = productManager.getSeller(by: product1.sellerId),
                      let seller2 = productManager.getSeller(by: product2.sellerId) else {
                    return false
                }
                return seller1.rating > seller2.rating
            }
        }
        
        return results
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
                
                VStack(spacing: 0) {
                    // Filters and sort bar
                    FrostedCardView {
                        VStack(spacing: 12) {
                            HStack {
                                Text("\(filteredAndSortedResults.count) résultat(s)")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Button("Filtres") {
                                    showingFilters = true
                                }
                                .font(.body)
                                .foregroundColor(Color("AccentGreen"))
                            }
                            
                            // Sort options
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(SortOption.allCases, id: \.self) { option in
                                        SortOptionButton(
                                            option: option,
                                            isSelected: selectedSortOption == option
                                        ) {
                                            selectedSortOption = option
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding()
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Results
                    if filteredAndSortedResults.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                            
                            Text("Aucun produit trouvé")
                                .font(.title3)
                                .fontWeight(.medium)
                            
                            Text("Essayez de modifier vos critères de recherche ou utilisez une demande personnalisée")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            
                            GlassmorphicButton(title: "Demande personnalisée", isPrimary: false) {
                                // Navigate to custom request
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ScrollView {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                                ForEach(filteredAndSortedResults) { product in
                                    ProductCard(product: product) {
                                        selectedProduct = product
                                        showingProductDetail = true
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("Résultats de recherche")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") {
                        // Dismiss view
                    }
                    .foregroundColor(Color("AccentGreen"))
                }
            }
        }
        .sheet(isPresented: $showingFilters) {
            FilterView(
                selectedCategory: $selectedCategory,
                selectedSortOption: $selectedSortOption
            )
        }
        .sheet(isPresented: $showingProductDetail) {
            if let product = selectedProduct {
                ProductDetailView(product: product)
            }
        }
    }
}

struct SortOptionButton: View {
    let option: SearchResultsView.SortOption
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(option.displayName)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isSelected ? Color("AccentGreen") : Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color("AccentGreen"), lineWidth: isSelected ? 0 : 1)
                        )
                )
                .foregroundColor(isSelected ? .white : Color("AccentGreen"))
        }
    }
}

struct ProductCard: View {
    let product: Product
    let onTap: () -> Void
    @EnvironmentObject var productManager: ProductManager
    @EnvironmentObject var locationManager: LocationManager
    
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
                    
                    Text(product.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    
                    HStack {
                        Text("\(Int(product.price)) XOF")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(Color("AccentGreen"))
                        
                        Spacer()
                        
                        if let seller = productManager.getSeller(by: product.sellerId) {
                            HStack(spacing: 2) {
                                Image(systemName: "star.fill")
                                    .font(.caption2)
                                    .foregroundColor(.yellow)
                                
                                Text(String(format: "%.1f", seller.rating))
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    // Seller info
                    if let seller = productManager.getSeller(by: product.sellerId) {
                        HStack {
                            Text(seller.name)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            if let userLocation = locationManager.location,
                               let distance = locationManager.calculateDistance(to: seller.location) {
                                Text(locationManager.formatDistance(distance))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    // Stock status
                    HStack {
                        Circle()
                            .fill(product.isAvailable ? Color.green : Color.red)
                            .frame(width: 8, height: 8)
                        
                        Text(product.isAvailable ? "En stock" : "Rupture")
                            .font(.caption)
                            .foregroundColor(product.isAvailable ? .green : .red)
                        
                        Spacer()
                        
                        if product.isAvailable {
                            Text("\(product.stock) restant(s)")
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

struct FilterView: View {
    @Binding var selectedCategory: ProductCategory?
    @Binding var selectedSortOption: SearchResultsView.SortOption
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
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Category filter
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Catégorie")
                                .font(.title3)
                                .fontWeight(.bold)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                                ForEach(ProductCategory.allCases, id: \.self) { category in
                                    FilterOptionButton(
                                        title: category.displayName,
                                        isSelected: selectedCategory == category
                                    ) {
                                        if selectedCategory == category {
                                            selectedCategory = nil
                                        } else {
                                            selectedCategory = category
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Sort options
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Trier par")
                                .font(.title3)
                                .fontWeight(.bold)
                            
                            VStack(spacing: 8) {
                                ForEach(SearchResultsView.SortOption.allCases, id: \.self) { option in
                                    FilterOptionButton(
                                        title: option.displayName,
                                        isSelected: selectedSortOption == option
                                    ) {
                                        selectedSortOption = option
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.top)
                }
            }
            .navigationTitle("Filtres")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Réinitialiser") {
                        selectedCategory = nil
                        selectedSortOption = .relevance
                    }
                    .foregroundColor(.red)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Appliquer") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(Color("AccentGreen"))
                }
            }
        }
    }
}

struct FilterOptionButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(Color("AccentGreen"))
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isSelected ? Color("AccentGreen") : Color.clear,
                                lineWidth: 2
                            )
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview
struct SearchResultsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsView(searchResults: [])
            .environmentObject(ProductManager())
            .environmentObject(LocationManager())
    }
} 