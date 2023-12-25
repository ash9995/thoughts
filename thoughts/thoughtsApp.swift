import SwiftUI

@main
struct ThoughtsApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate

    var body: some Scene {
        WindowGroup {
            SplashScreen()
        }
        .modelContainer(for: TaskModel.self)
        .environment(\.locale, .init(identifier: "ar"))
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // Add other UIApplicationDelegate methods if needed
}


