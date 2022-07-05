final class LoginWireframe: BaseWireframe<LoginViewController>
{
    init(oAuthService: OAuthService, loginHandler: @escaping (() -> Void)) {
        let interactor = LoginInteractor(oAuthService: oAuthService)
        let presenter = LoginPresenter(interactor: interactor, loginHandler: loginHandler)
        let moduleViewController = LoginViewController(presenter: presenter)

        super.init(viewController: moduleViewController)
    }
}
