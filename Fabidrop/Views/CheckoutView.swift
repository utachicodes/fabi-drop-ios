import SwiftUI

struct CheckoutView: View {
    let product: Product
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var paymentManager: PaymentManager
    @EnvironmentObject var notificationManager: NotificationManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var quantity = 1
    @State private var selectedDeliveryType: DeliveryType = .standard
    @State private var deliveryAddress = ""
    @State private var phoneNumber = ""
    @State private var showingPayment = false
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var orderPlaced = false
    
    private var subtotal: Double {
        return product.price * Double(quantity)
    }
    
    private var deliveryFee: Double {
        switch selectedDeliveryType {
        case .standard: return 1000
        case .express: return 2500
        }
    }
    
    private var total: Double {
        return subtotal + deliveryFee
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
                        // Product summary
                        FrostedCardView {
                            VStack(spacing: 16) {
                                HStack {
                                    // Product image
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 80, height: 80)
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
                                        
                                        Text("Stock: \(product.stock)")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                }
                                
                                // Quantity selector
                                HStack {
                                    Text("Quantité:")
                                        .font(.body)
                                        .fontWeight(.medium)
                                    
                                    Spacer()
                                    
                                    HStack(spacing: 0) {
                                        Button(action: {
                                            if quantity > 1 {
                                                quantity -= 1
                                            }
                                        }) {
                                            Image(systemName: "minus.circle.fill")
                                                .font(.title2)
                                                .foregroundColor(Color("AccentGreen"))
                                        }
                                        
                                        Text("\(quantity)")
                                            .font(.body)
                                            .fontWeight(.medium)
                                            .frame(minWidth: 40)
                                            .padding(.horizontal, 8)
                                        
                                        Button(action: {
                                            if quantity < product.stock {
                                                quantity += 1
                                            }
                                        }) {
                                            Image(systemName: "plus.circle.fill")
                                                .font(.title2)
                                                .foregroundColor(Color("AccentGreen"))
                                        }
                                    }
                                }
                            }
                            .padding()
                        }
                        .padding(.horizontal)
                        
                        // Delivery options
                        FrostedCardView {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Options de livraison")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                
                                VStack(spacing: 12) {
                                    ForEach(DeliveryType.allCases, id: \.self) { deliveryType in
                                        DeliveryOptionRow(
                                            deliveryType: deliveryType,
                                            isSelected: selectedDeliveryType == deliveryType,
                                            fee: deliveryType == .standard ? 1000 : 2500
                                        ) {
                                            selectedDeliveryType = deliveryType
                                        }
                                    }
                                }
                            }
                            .padding()
                        }
                        .padding(.horizontal)
                        
                        // Delivery details
                        FrostedCardView {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Détails de livraison")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                
                                VStack(spacing: 12) {
                                    GlassmorphicTextField(
                                        placeholder: "Adresse de livraison",
                                        text: $deliveryAddress
                                    )
                                    
                                    GlassmorphicTextField(
                                        placeholder: "Numéro de téléphone",
                                        text: $phoneNumber
                                    )
                                }
                            }
                            .padding()
                        }
                        .padding(.horizontal)
                        
                        // Order summary
                        FrostedCardView {
                            VStack(spacing: 16) {
                                Text("Résumé de la commande")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                
                                VStack(spacing: 8) {
                                    HStack {
                                        Text("Sous-total")
                                        Spacer()
                                        Text("\(Int(subtotal)) XOF")
                                    }
                                    
                                    HStack {
                                        Text("Frais de livraison (\(selectedDeliveryType.displayName))")
                                        Spacer()
                                        Text("\(Int(deliveryFee)) XOF")
                                    }
                                    
                                    Divider()
                                    
                                    HStack {
                                        Text("Total")
                                            .font(.body)
                                            .fontWeight(.bold)
                                        Spacer()
                                        Text("\(Int(total)) XOF")
                                            .font(.body)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color("AccentGreen"))
                                    }
                                }
                            }
                            .padding()
                        }
                        .padding(.horizontal)
                        
                        // Checkout button
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .scaleEffect(1.2)
                        } else {
                            GlassmorphicButton(title: "Procéder au paiement") {
                                proceedToPayment()
                            }
                            .disabled(!isFormValid)
                        }
                        
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.top)
                }
            }
            .navigationTitle("Commander")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.secondary)
                }
            }
        }
        .sheet(isPresented: $showingPayment) {
            PaymentMethodView(
                amount: total,
                orderId: UUID().uuidString,
                paymentManager: paymentManager
            )
        }
        .alert("Commande confirmée !", isPresented: $orderPlaced) {
            Button("OK") {
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Votre commande a été confirmée. Vous recevrez des notifications sur l'état de votre commande.")
        }
    }
    
    private var isFormValid: Bool {
        return !deliveryAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               !phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               quantity > 0 &&
               quantity <= product.stock
    }
    
    private func proceedToPayment() {
        guard isFormValid else {
            errorMessage = "Veuillez remplir tous les champs requis"
            return
        }
        
        showingPayment = true
    }
}

struct DeliveryOptionRow: View {
    let deliveryType: DeliveryType
    let isSelected: Bool
    let fee: Double
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(deliveryType.displayName)
                            .font(.body)
                            .fontWeight(.medium)
                        
                        if deliveryType == .express {
                            Text("RAPIDE")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                        }
                    }
                    
                    Text(deliveryType.deliveryTime)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(Int(fee)) XOF")
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(Color("AccentGreen"))
                }
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color("AccentGreen"))
                        .font(.title2)
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
struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleProduct = Product(
            id: "prod1",
            name: "Robe Rouge Élégante",
            description: "Robe rouge élégante parfaite pour les occasions spéciales",
            price: 25000,
            stock: 5,
            sellerId: "seller1",
            category: .fashion
        )
        
        CheckoutView(product: sampleProduct)
            .environmentObject(AuthManager())
            .environmentObject(PaymentManager())
            .environmentObject(NotificationManager())
    }
} 