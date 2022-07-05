import Foundation

protocol ILoginPresenter: AnyObject
{
    var oAuthUrl: URL? { get }

    func set(vc: LoginViewController, loginNode: LoginNode)
}

final class LoginPresenter
{
    private let interactor: ILoginInteractor
    private weak var vc: ILoginViewController?
    private let loginHandler: (() -> Void)

    init(interactor: ILoginInteractor, loginHandler: @escaping (() -> Void)) {
        self.interactor = interactor
        self.loginHandler = loginHandler
    }
}

extension LoginPresenter: ILoginPresenter
{
    var oAuthUrl: URL? { self.interactor.oAuthUrl }

    func set(vc: LoginViewController, loginNode: LoginNode) {
        self.vc = vc
        loginNode.logInCompletion = { [weak self] in self?.logInHandler() }
        self.interactor.authenticationCallback = { [weak self] in self?.onAuthenticationResult(result: $0) }
    }
}

private extension LoginPresenter
{
    func onAuthenticationResult(result: Result<TokenBag, Error>) {
        switch result {
        case .failure(let error):
            print(error)
        case .success(let token):
            print("success with \(token.accessToken)")
        }

        self.vc?.closeAuth { [weak self] in self?.loginHandler() }
    }
    
    func logInHandler() {
        self.vc?.showAuth()
    }
}
