import Foundation

protocol OAuthClient
{
    func getAuthPageUrl(state: String) -> URL?
    func exchangeCodeForToken(code: String,
                              state: String,
                              completion: @escaping (Result<TokenBag, Error>) -> Void)
}

struct TokenBag
{
    let accessToken: String
}

class OAuthService
{
    enum OAthError: Error
    {
        case malformedLink
        case exchangeFailed
    }
    private let oauthClient: OAuthClient
    private let authManager: AuthManager
    private var state: String?
    
    var onAuthenticationResult: ((Result<TokenBag, Error>) -> Void)?

    init(oauthClient: OAuthClient, authManager: AuthManager) {
        self.oauthClient = oauthClient
        self.authManager = authManager
    }
    
    func getAuthPageUrl(state: String = UUID().uuidString) -> URL? {
        self.state = state
        return oauthClient.getAuthPageUrl(state: state)
    }
    
    
    func exchangeCodeForToken(url: URL) {
        guard let state = state, let code = getCodeFromUrl(url: url) else {
            onAuthenticationResult?(.failure(OAthError.malformedLink))
            return
        }
        
        self.oauthClient.exchangeCodeForToken(code: code, state: state) { [weak self] result in
            switch result {
            case .success(let tokenBag):
                self?.authManager.setToken(tokenBag.accessToken)
                self?.onAuthenticationResult?(.success(tokenBag))
            case .failure:
                self?.onAuthenticationResult?(.failure(OAthError.exchangeFailed))
            }
        }
    }
}

private extension OAuthService
{
    func getCodeFromUrl(url: URL) -> String? {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let code = components?.queryItems?.first(where: { $0.name == "code" })?.value
        let state = components?.queryItems?.first(where: { $0.name == "state" })?.value
        
        if let code = code, let state = state, state == self.state {
            return code
        } else {
            return nil
        }
    }
}
