protocol ILoginInteractor: AnyObject
{
    var authenticationCallback: ((Result<TokenBag, Error>) -> Void)? { get set }
    var oAuthUrl: URL? { get }
}

final class LoginInteractor
{
    var authenticationCallback: ((Result<TokenBag, Error>) -> Void)?

    private let oAuthService: OAuthService

    init(oAuthService: OAuthService) {
        self.oAuthService = oAuthService
        
        self.oAuthService.onAuthenticationResult = { [weak self] in self?.authenticationCallback?($0) }
    }
}

extension LoginInteractor: ILoginInteractor
{
    var oAuthUrl: URL? {
        self.oAuthService.getAuthPageUrl(state: "state")
    }
}
