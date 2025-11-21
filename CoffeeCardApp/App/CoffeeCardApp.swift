import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        
        #if DEBUG
        Task {
            do {
                try await SeedService().seedMenuIfEmpty()
                print("✅ Menu seed finished")
            } catch {
                print("❌ Menu seed failed:", error)
            }
        }
        #endif
        
        return true
    }
}

@main
struct CoffeeCardApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    init() {
        let MB = 1024 * 1024
        URLCache.shared.memoryCapacity = 50 * MB
        URLCache.shared.diskCapacity   = 200 * MB
    }
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
