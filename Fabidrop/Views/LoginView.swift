import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var showingSignUp = false
    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    @State private var isSignUp = false
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color.blue.opacity(0.3),
                    Color.purple.opacity(0.3),
                    Color("AccentGreen").opacity(0.2)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    // Logo and title
                    VStack(spacing: 16) {
                        Image(systemName: "bag.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(Color("AccentGreen"))
                        
                        Text("Fabidrop")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("Découvrez et achetez les produits tendance de vos réseaux sociaux")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.top, 60)
                    
                    // Login form
                    FrostedCardView {
                        VStack(spacing: 20) {
                            if isSignUp {
                                Text("Créer un compte")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .padding(.top)
                            } else {
                                Text("Se connecter")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .padding(.top)
                            }
                            
                            if isSignUp {
                                GlassmorphicTextField(
                                    placeholder: "Nom complet",
                                    text: $name
                                )
                            }
                            
                            GlassmorphicTextField(
                                placeholder: "Email",
                                text: $email
                            )
                            
                            GlassmorphicTextField(
                                placeholder: "Mot de passe",
                                text: $password,
                                isSecure: true
                            )
                            
                            if authManager.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .scaleEffect(1.2)
                            } else {
                                GlassmorphicButton(title: isSignUp ? "Créer un compte" : "Se connecter") {
                                    if isSignUp {
                                        authManager.signUpWithEmail(name: name, email: email, password: password)
                                    } else {
                                        authManager.signInWithEmail(email: email, password: password)
                                    }
                                }
                            }
                            
                            if let errorMessage = authManager.errorMessage {
                                Text(errorMessage)
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.center)
                            }
                            
                            // Apple Sign In
                            if !isSignUp {
                                SignInWithAppleButton(
                                    onRequest: { request in
                                        request.requestedScopes = [.fullName, .email]
                                    },
                                    onCompletion: { result in
                                        switch result {
                                        case .success(let authResults):
                                            print("Authorization successful")
                                            authManager.signInWithApple()
                                        case .failure(let error):
                                            print("Authorization failed: \(error.localizedDescription)")
                                        }
                                    }
                                )
                                .signInWithAppleButtonStyle(.white)
                                .frame(height: 50)
                                .cornerRadius(12)
                            }
                            
                            // Toggle between login and signup
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isSignUp.toggle()
                                    email = ""
                                    password = ""
                                    name = ""
                                    authManager.errorMessage = nil
                                }
                            }) {
                                Text(isSignUp ? "Déjà un compte ? Se connecter" : "Pas de compte ? Créer un compte")
                                    .font(.body)
                                    .foregroundColor(Color("AccentGreen"))
                            }
                            .padding(.bottom)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.horizontal)
                    
                    // Features preview
                    VStack(spacing: 16) {
                        Text("Fonctionnalités principales")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        HStack(spacing: 20) {
                            FeatureCard(
                                icon: "magnifyingglass",
                                title: "Recherche",
                                description: "Par mot-clé ou image"
                            )
                            
                            FeatureCard(
                                icon: "location.circle",
                                title: "Local",
                                description: "Vendeurs à proximité"
                            )
                            
                            FeatureCard(
                                icon: "creditcard",
                                title: "Paiement",
                                description: "Sécurisé et rapide"
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 50)
                }
            }
        }
        .preferredColorScheme(.light)
    }
}

struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        FrostedCardView {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(Color("AccentGreen"))
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
    }
}

// MARK: - Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthManager())
    }
} 