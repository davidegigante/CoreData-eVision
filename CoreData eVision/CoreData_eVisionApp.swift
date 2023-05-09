import SwiftUI
import AVFoundation
import CoreData
import UserNotifications

@main
struct CoreData_eVisionApp: App {
    let persistenceController = PersistenceController.shared
    @AppStorage("isDarkMode") private var isDarkModeOn = false

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(isDarkModeOn ? .dark : .light)
                .onAppear {
                    checkPerms { cameraGranted, notificationsGranted in
                        if !cameraGranted || !notificationsGranted {
                            print("Both permissions are required for the app to work correctly.")
                        }
                    }
                }
        }
    }

    func checkPerms(completion: @escaping (Bool, Bool) -> Void) {
        var cameraGranted: Bool?
        var notificationsGranted: Bool?

        let group = DispatchGroup()
        
        group.enter()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                notificationsGranted = granted
                group.leave()
            }
        }

        group.enter()
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            cameraGranted = true
            group.leave()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    cameraGranted = granted
                    group.leave()
                }
            }
        case .denied, .restricted:
            cameraGranted = false
            group.leave()
        default:
            cameraGranted = false
            group.leave()
        }

        group.notify(queue: .main) {
            if let camera = cameraGranted, let notifications = notificationsGranted {
                completion(camera, notifications)
            } else {
                completion(false, false)
            }
        }
    }
}
