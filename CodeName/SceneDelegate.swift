import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    let dependencyContainer = AppDependencyContainer()
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

        self.dependencyContainer.setInitialWireframeFor(window)
        self.window = window
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let urlContext = URLContexts.first {
            let url = urlContext.url
            if let deepLink = DeepLink(url: url) {
                self.dependencyContainer.deepLinkHandler.handleDeepLinkIfPossible(deepLink: deepLink)
            }
        }
    }
}
