import Foundation
import SwiftUI
import UserNotifications

class NotificationManager: NSObject, ObservableObject {
    @Published var isAuthorized = false
    @Published var notifications: [LocalNotification] = []
    
    override init() {
        super.init()
        checkAuthorizationStatus()
    }
    
    // MARK: - Authorization
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                self.isAuthorized = granted
                if let error = error {
                    print("Notification authorization error: \(error)")
                }
            }
        }
    }
    
    private func checkAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isAuthorized = settings.authorizationStatus == .authorized
            }
        }
    }
    
    // MARK: - Local Notifications
    func scheduleOrderUpdateNotification(orderId: String, status: OrderStatus) {
        let content = UNMutableNotificationContent()
        content.title = "Mise à jour de commande"
        content.body = getOrderStatusMessage(status)
        content.sound = .default
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "order-\(orderId)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
        
        // Add to local notifications list
        let notification = LocalNotification(
            id: "order-\(orderId)",
            title: "Mise à jour de commande",
            body: getOrderStatusMessage(status),
            type: .orderUpdate,
            date: Date()
        )
        
        DispatchQueue.main.async {
            self.notifications.insert(notification, at: 0)
        }
    }
    
    func scheduleCustomRequestNotification(requestId: String, response: String) {
        let content = UNMutableNotificationContent()
        content.title = "Réponse à votre demande"
        content.body = "Un vendeur a répondu à votre demande personnalisée"
        content.sound = .default
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "request-\(requestId)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
        
        // Add to local notifications list
        let notification = LocalNotification(
            id: "request-\(requestId)",
            title: "Réponse à votre demande",
            body: "Un vendeur a répondu à votre demande personnalisée",
            type: .customRequest,
            date: Date()
        )
        
        DispatchQueue.main.async {
            self.notifications.insert(notification, at: 0)
        }
    }
    
    func scheduleNewDealNotification(dealTitle: String) {
        let content = UNMutableNotificationContent()
        content.title = "Nouvelle offre locale"
        content.body = "Découvrez: \(dealTitle)"
        content.sound = .default
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "deal-\(UUID().uuidString)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
        
        // Add to local notifications list
        let notification = LocalNotification(
            id: "deal-\(UUID().uuidString)",
            title: "Nouvelle offre locale",
            body: "Découvrez: \(dealTitle)",
            type: .newDeal,
            date: Date()
        )
        
        DispatchQueue.main.async {
            self.notifications.insert(notification, at: 0)
        }
    }
    
    // MARK: - Helper Methods
    private func getOrderStatusMessage(_ status: OrderStatus) -> String {
        switch status {
        case .processing:
            return "Votre commande est en cours de traitement"
        case .shipped:
            return "Votre commande a été expédiée"
        case .delivered:
            return "Votre commande a été livrée"
        case .cancelled:
            return "Votre commande a été annulée"
        }
    }
    
    // MARK: - Notification Management
    func clearAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        
        DispatchQueue.main.async {
            self.notifications.removeAll()
        }
    }
    
    func markNotificationAsRead(_ notificationId: String) {
        DispatchQueue.main.async {
            if let index = self.notifications.firstIndex(where: { $0.id == notificationId }) {
                self.notifications[index].isRead = true
            }
        }
    }
    
    func getUnreadCount() -> Int {
        return notifications.filter { !$0.isRead }.count
    }
}

// MARK: - Local Notification Model
struct LocalNotification: Identifiable {
    let id: String
    let title: String
    let body: String
    let type: NotificationType
    let date: Date
    var isRead: Bool = false
}

enum NotificationType {
    case orderUpdate
    case customRequest
    case newDeal
    
    var iconName: String {
        switch self {
        case .orderUpdate: return "shippingbox.fill"
        case .customRequest: return "questionmark.circle.fill"
        case .newDeal: return "tag.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .orderUpdate: return Color("AccentGreen")
        case .customRequest: return .blue
        case .newDeal: return .orange
        }
    }
}

// MARK: - Notification Views
struct NotificationListView: View {
    @ObservedObject var notificationManager: NotificationManager
    
    var body: some View {
        List {
            if notificationManager.notifications.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "bell.slash")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    
                    Text("Aucune notification")
                        .font(.title3)
                        .fontWeight(.medium)
                    
                    Text("Vous recevrez des notifications pour les mises à jour de commandes et les réponses à vos demandes")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .listRowBackground(Color.clear)
            } else {
                ForEach(notificationManager.notifications) { notification in
                    NotificationRow(notification: notification) {
                        notificationManager.markNotificationAsRead(notification.id)
                    }
                }
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Effacer tout") {
                    notificationManager.clearAllNotifications()
                }
                .foregroundColor(Color("AccentGreen"))
            }
        }
    }
}

struct NotificationRow: View {
    let notification: LocalNotification
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Image(systemName: notification.type.iconName)
                    .font(.title2)
                    .foregroundColor(notification.type.color)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(notification.title)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(notification.body)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    
                    Text(formatDate(notification.date))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if !notification.isRead {
                    Circle()
                        .fill(Color("AccentGreen"))
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
        .opacity(notification.isRead ? 0.7 : 1.0)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle notification tap
        let identifier = response.notification.request.identifier
        print("Notification tapped: \(identifier)")
        
        // Mark as read
        markNotificationAsRead(identifier)
        
        completionHandler()
    }
} 