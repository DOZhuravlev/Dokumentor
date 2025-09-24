import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // Если хочешь без SceneDelegate, можно здесь создать window —
        // но мы используем сцену, поэтому оставим пусто.
        return true
    }
}
