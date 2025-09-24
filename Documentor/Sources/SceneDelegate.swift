import UIKit
import SnapKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let win = UIWindow(windowScene: windowScene)

        // Пример использования SnapKit — просто чтобы проверить линковку
        let vc = UIViewController()
        vc.view.backgroundColor = .systemBackground
        let label = UILabel()
        label.text = "Documentor (UIKit + SnapKit)"
        label.numberOfLines = 0
        vc.view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.greaterThanOrEqualTo(vc.view.layoutMarginsGuide).offset(0)
            make.trailing.lessThanOrEqualTo(vc.view.layoutMarginsGuide).offset(0)
        }

        win.rootViewController = UINavigationController(rootViewController: vc)
        win.makeKeyAndVisible()
        window = win
    }
}
