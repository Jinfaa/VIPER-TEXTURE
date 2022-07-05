import UIKit

class BaseWireframe<ViewController> where ViewController: UIViewController
{
    private unowned var _viewController: ViewController
    private var temporaryStoredViewController: ViewController?

    init(viewController: ViewController) {
        self.temporaryStoredViewController = viewController
        self._viewController = viewController
    }
}

extension BaseWireframe
{
    var viewController: ViewController
    {
        defer { self.temporaryStoredViewController = nil }
        return self._viewController
    }

    var navigationController: UINavigationController?
    {
        return self.viewController.navigationController
    }
}

extension UIViewController
{
    func presentWireframe<ViewController>(_ wireframe: BaseWireframe<ViewController>, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.present(wireframe.viewController, animated: animated, completion: completion)
    }
}

extension UINavigationController
{
    func pushWireframe<ViewController>(_ wireframe: BaseWireframe<ViewController>, animated: Bool = true) {
        self.pushViewController(wireframe.viewController, animated: animated)
    }
    
    func setRootWireframe<ViewController>(_ wireframe: BaseWireframe<ViewController>, animated: Bool = true) {
        self.setViewControllers([wireframe.viewController], animated: animated)
    }
}
