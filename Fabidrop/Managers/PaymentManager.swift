import Foundation
import SwiftUI
import PassKit

class PaymentManager: NSObject, ObservableObject {
    @Published var isApplePayAvailable = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var paymentSuccess = false
    
    private let paymentHandler = PKPaymentAuthorizationController()
    
    override init() {
        super.init()
        checkApplePayAvailability()
    }
    
    // MARK: - Apple Pay
    private func checkApplePayAvailability() {
        isApplePayAvailable = PKPaymentAuthorizationController.canMakePayments()
    }
    
    func processApplePayPayment(for order: Order, amount: Double) {
        guard isApplePayAvailable else {
            errorMessage = "Apple Pay is not available on this device"
            return
        }
        
        let request = PKPaymentRequest()
        request.merchantIdentifier = "merchant.com.fabidrop.ios"
        request.supportedNetworks = [.visa, .masterCard, .amex]
        request.merchantCapabilities = .capability3DS
        request.countryCode = "SN"
        request.currencyCode = "XOF"
        
        let paymentItem = PKPaymentSummaryItem(
            label: "Fabidrop",
            amount: NSDecimalNumber(value: amount)
        )
        request.paymentSummaryItems = [paymentItem]
        
        paymentHandler.delegate = self
        paymentHandler.present { presented in
            if presented {
                print("Apple Pay presented")
            } else {
                self.errorMessage = "Failed to present Apple Pay"
            }
        }
    }
    
    // MARK: - Local Payment Gateways
    func processLocalPayment(method: PaymentMethod, amount: Double, orderId: String) {
        isLoading = true
        errorMessage = nil
        
        // Simulate payment processing
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            DispatchQueue.main.async {
                self.isLoading = false
                
                // Simulate success (in real app, this would check actual payment status)
                if Bool.random() {
                    self.paymentSuccess = true
                    print("Payment successful via \(method.displayName)")
                } else {
                    self.errorMessage = "Payment failed. Please try again."
                }
            }
        }
    }
    
    // MARK: - Payment Validation
    func validatePaymentDetails(_ details: PaymentDetails) -> Bool {
        guard details.amount > 0 else {
            errorMessage = "Invalid payment amount"
            return false
        }
        
        guard !details.orderId.isEmpty else {
            errorMessage = "Invalid order ID"
            return false
        }
        
        return true
    }
    
    // MARK: - Payment History
    func getPaymentHistory(for userId: String) -> [PaymentDetails] {
        // In a real app, this would fetch from backend
        return []
    }
    
    // MARK: - Refund Processing
    func processRefund(orderId: String, amount: Double) {
        isLoading = true
        
        // Simulate refund processing
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            DispatchQueue.main.async {
                self.isLoading = false
                self.paymentSuccess = true
                print("Refund processed for order: \(orderId)")
            }
        }
    }
}

// MARK: - PKPaymentAuthorizationControllerDelegate
extension PaymentManager: PKPaymentAuthorizationControllerDelegate {
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        // Process the payment with your payment processor
        // For demo purposes, we'll simulate success
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
            self.paymentSuccess = true
        }
    }
    
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss()
    }
}

// MARK: - Payment Views
struct PaymentMethodView: View {
    let amount: Double
    let orderId: String
    @ObservedObject var paymentManager: PaymentManager
    @State private var selectedMethod: PaymentMethod = .applePay
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Choisir le mode de paiement")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(spacing: 12) {
                ForEach(PaymentMethod.allCases, id: \.self) { method in
                    PaymentMethodRow(
                        method: method,
                        isSelected: selectedMethod == method,
                        isAvailable: method == .applePay ? paymentManager.isApplePayAvailable : true
                    ) {
                        selectedMethod = method
                    }
                }
            }
            
            VStack(spacing: 8) {
                HStack {
                    Text("Montant total:")
                        .font(.body)
                    Spacer()
                    Text("\(Int(amount)) XOF")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color("AccentGreen"))
                }
                
                HStack {
                    Text("Numéro de commande:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(orderId)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
            )
            
            GlassmorphicButton(title: "Payer maintenant") {
                processPayment()
            }
            .disabled(paymentManager.isLoading)
            
            if paymentManager.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
            
            if let errorMessage = paymentManager.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
    }
    
    private func processPayment() {
        switch selectedMethod {
        case .applePay:
            // Create a dummy order for Apple Pay
            let dummyOrder = Order(
                id: orderId,
                userId: "user123",
                productId: "prod123",
                sellerId: "seller123",
                deliveryDetails: DeliveryDetails(
                    type: .standard,
                    address: "Dakar, Sénégal",
                    phoneNumber: "+221 77 123 4567"
                )
            )
            paymentManager.processApplePayPayment(for: dummyOrder, amount: amount)
        case .orangeMoney, .wave:
            paymentManager.processLocalPayment(
                method: selectedMethod,
                amount: amount,
                orderId: orderId
            )
        }
    }
}

struct PaymentMethodRow: View {
    let method: PaymentMethod
    let isSelected: Bool
    let isAvailable: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: iconName)
                    .font(.title2)
                    .foregroundColor(isAvailable ? Color("AccentGreen") : .gray)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(method.displayName)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(isAvailable ? .primary : .gray)
                    
                    if !isAvailable {
                        Text("Non disponible")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                
                Spacer()
                
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
        .disabled(!isAvailable)
        .opacity(isAvailable ? 1.0 : 0.6)
    }
    
    private var iconName: String {
        switch method {
        case .applePay: return "applelogo"
        case .orangeMoney: return "creditcard.fill"
        case .wave: return "wave.3.right"
        }
    }
} 