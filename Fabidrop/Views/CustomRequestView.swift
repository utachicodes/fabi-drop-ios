import SwiftUI
import PhotosUI

struct CustomRequestView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var productManager: ProductManager
    @EnvironmentObject var notificationManager: NotificationManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var productDescription = ""
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var isLoading = false
    @State private var showingSuccess = false
    @State private var errorMessage: String?
    
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
                        // Header
                        VStack(spacing: 12) {
                            Image(systemName: "questionmark.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(Color("AccentGreen"))
                            
                            Text("Demande personnalisée")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("Vous ne trouvez pas le produit que vous cherchez ? Faites-nous part de votre demande et nous vous aiderons à le localiser.")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding(.top)
                        
                        // Request form
                        FrostedCardView {
                            VStack(spacing: 20) {
                                // Product description
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Description du produit")
                                        .font(.headline)
                                        .fontWeight(.medium)
                                    
                                    TextEditor(text: $productDescription)
                                        .frame(minHeight: 100)
                                        .padding(8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(.ultraThinMaterial)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                                )
                                        )
                                        .overlay(
                                            Group {
                                                if productDescription.isEmpty {
                                                    Text("Décrivez le produit que vous recherchez...")
                                                        .foregroundColor(.gray)
                                                        .padding(.horizontal, 12)
                                                        .padding(.vertical, 8)
                                                        .allowsHitTesting(false)
                                                }
                                            },
                                            alignment: .topLeading
                                        )
                                }
                                
                                // Image upload
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Photo du produit (optionnel)")
                                        .font(.headline)
                                        .fontWeight(.medium)
                                    
                                    if let selectedImage = selectedImage {
                                        VStack(spacing: 12) {
                                            Image(uiImage: selectedImage)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(maxHeight: 200)
                                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                            
                                            Button("Changer l'image") {
                                                showingImagePicker = true
                                            }
                                            .font(.body)
                                            .foregroundColor(Color("AccentGreen"))
                                        }
                                    } else {
                                        GlassmorphicImagePicker(title: "Ajouter une photo") {
                                            showingImagePicker = true
                                        }
                                    }
                                }
                                
                                // Tips section
                                FrostedCardView {
                                    VStack(alignment: .leading, spacing: 12) {
                                        Text("Conseils pour une meilleure recherche")
                                            .font(.headline)
                                            .fontWeight(.medium)
                                        
                                        VStack(alignment: .leading, spacing: 8) {
                                            TipRow(icon: "textformat", text: "Soyez précis dans votre description")
                                            TipRow(icon: "tag", text: "Mentionnez la marque si possible")
                                            TipRow(icon: "camera", text: "Une photo aide beaucoup")
                                            TipRow(icon: "clock", text: "Réponse sous 48h")
                                        }
                                    }
                                    .padding()
                                }
                                
                                // Submit button
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                        .scaleEffect(1.2)
                                } else {
                                    GlassmorphicButton(title: "Envoyer la demande") {
                                        submitRequest()
                                    }
                                    .disabled(productDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                                }
                                
                                if let errorMessage = errorMessage {
                                    Text(errorMessage)
                                        .font(.caption)
                                        .foregroundColor(.red)
                                        .multilineTextAlignment(.center)
                                }
                            }
                            .padding()
                        }
                        .padding(.horizontal)
                        
                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationTitle("Demande personnalisée")
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
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .alert("Demande envoyée !", isPresented: $showingSuccess) {
            Button("OK") {
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Votre demande a été envoyée avec succès. Nous vous répondrons dans les 48 heures.")
        }
    }
    
    private func submitRequest() {
        guard !productDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Veuillez décrire le produit que vous recherchez"
            return
        }
        
        guard let user = authManager.currentUser else {
            errorMessage = "Vous devez être connecté pour envoyer une demande"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        // Simulate image upload
        var imageURL: String?
        if let selectedImage = selectedImage {
            // In a real app, this would upload to Firebase Storage
            imageURL = "https://example.com/uploaded-image.jpg"
        }
        
        // Submit request
        let request = productManager.submitCustomRequest(
            productDetails: productDescription,
            imageURL: imageURL,
            userId: user.id
        )
        
        // Schedule notification for response
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.notificationManager.scheduleCustomRequestNotification(
                requestId: request.id,
                response: "Nous avons trouvé des vendeurs pour votre demande !"
            )
            
            DispatchQueue.main.async {
                self.isLoading = false
                self.showingSuccess = true
            }
        }
    }
}

struct TipRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(Color("AccentGreen"))
                .frame(width: 20)
            
            Text(text)
                .font(.body)
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
}

// MARK: - Preview
struct CustomRequestView_Previews: PreviewProvider {
    static var previews: some View {
        CustomRequestView()
            .environmentObject(AuthManager())
            .environmentObject(ProductManager())
            .environmentObject(NotificationManager())
    }
} 