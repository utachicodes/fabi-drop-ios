import SwiftUI

struct FrostedCardView<Content: View>: View {
    let content: Content
    var cornerRadius: CGFloat = 12
    var shadowRadius: CGFloat = 5
    var shadowOffset: CGSize = CGSize(width: 0, height: 2)
    var backgroundColor: Color = .clear
    
    init(cornerRadius: CGFloat = 12, shadowRadius: CGFloat = 5, shadowOffset: CGSize = CGSize(width: 0, height: 2), backgroundColor: Color = .clear, @ViewBuilder content: () -> Content) {
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
        self.backgroundColor = backgroundColor
        self.content = content()
    }
    
    var body: some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
                    .background(backgroundColor)
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(
                color: Color.black.opacity(0.1),
                radius: shadowRadius,
                x: shadowOffset.width,
                y: shadowOffset.height
            )
    }
}

struct GlassmorphicButton: View {
    let title: String
    let action: () -> Void
    var isPrimary: Bool = true
    var isEnabled: Bool = true
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .medium, design: .default))
                .foregroundColor(isPrimary ? .white : Color("AccentGreen"))
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isPrimary ? Color("AccentGreen") : Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color("AccentGreen"), lineWidth: isPrimary ? 0 : 2)
                        )
                )
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.6)
    }
}

struct GlassmorphicTextField: View {
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        )
        .font(.system(size: 16, weight: .regular, design: .default))
    }
}

struct GlassmorphicSearchBar: View {
    let placeholder: String
    @Binding var text: String
    var onSearch: () -> Void = {}
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .font(.system(size: 16, weight: .medium))
            
            TextField(placeholder, text: $text)
                .font(.system(size: 16, weight: .regular, design: .default))
                .onSubmit {
                    onSearch()
                }
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 16, weight: .medium))
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct GlassmorphicImagePicker: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: "camera.fill")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(Color("AccentGreen"))
                
                Text(title)
                    .font(.system(size: 14, weight: .medium, design: .default))
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color("AccentGreen").opacity(0.3), lineWidth: 2, antialiased: true)
                    )
            )
        }
    }
}

// MARK: - Preview
struct FrostedCardView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            LinearGradient(
                colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                FrostedCardView {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Glassmorphic Card")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("This is a beautiful frosted glass card with vibrant green accents.")
                            .font(.body)
                    }
                    .padding()
                }
                
                GlassmorphicButton(title: "Primary Button") {
                    print("Button tapped")
                }
                
                GlassmorphicButton(title: "Secondary Button", isPrimary: false) {
                    print("Button tapped")
                }
                
                GlassmorphicTextField(placeholder: "Enter text...", text: .constant(""))
                    .padding(.horizontal)
                
                GlassmorphicSearchBar(placeholder: "Search products...", text: .constant(""))
                    .padding(.horizontal)
                
                GlassmorphicImagePicker(title: "Upload Image") {
                    print("Image picker tapped")
                }
                .padding(.horizontal)
            }
            .padding()
        }
    }
} 