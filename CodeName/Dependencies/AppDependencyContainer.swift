import AsyncDisplayKit

class AppDependencyContainer
{
    let deepLinkHandler = DeepLinkHandler()

    private let initialViewController = UINavigationController()
    private let authManager = AuthManager()
    private let oAuthService: OAuthService
    private let apiService: IApiService
    private let httpClient: HTTPClient

    init() {
        let redirectUri = URL(string: "codename://authentication")!
        let oAuthConfig = OAuthConfig(authorizationUrl: URL(string: "https://github.com/login/oauth/authorize")!,
                                      tokenUrl: URL(string: "https://github.com/login/oauth/access_token")!,
                                      clientId: "<CLIENT_ID>",
                                      clientSecret: "<SECRET>",
                                      redirectUri: redirectUri,
                                      scopes: ["repo", "user"])
        
        self.httpClient = HTTPClient(authManager: self.authManager)
        let oAuthClient = RemoteOAuthClient(config: oAuthConfig, httpClient: self.httpClient)
        self.oAuthService = OAuthService(oauthClient: oAuthClient, authManager: self.authManager)
        self.apiService = ApiService(httpClient: self.httpClient)
        
        let deepLinkCallback: (DeepLink) -> Void = { deepLink in
            if case .oAuth(let url) = deepLink {
                self.oAuthService.exchangeCodeForToken(url: url)
            }
        }
        self.deepLinkHandler.addCallback(deepLinkCallback, forDeepLink: DeepLink(url: redirectUri)!)
    }
}

extension AppDependencyContainer
{
    var loginWireframe: LoginWireframe {
        LoginWireframe(oAuthService: self.oAuthService) { [weak self] in
            self?.setSearchWireframe()
        }
    }
    
    var searchWireframe: SearchWireframe {
        SearchWireframe(apiService: self.apiService) { [weak self] in
            self?.setLoginWireframe()
        }
    }
}

extension AppDependencyContainer
{
    func setInitialWireframeFor(_ window: UIWindow) {
        self.initialViewController.navigationBar.prefersLargeTitles = true

        if self.authManager.isTokenExist() {
            self.initialViewController.setRootWireframe(self.searchWireframe)
        } else {
            self.initialViewController.setRootWireframe(self.loginWireframe)
        }
        
        window.rootViewController = initialViewController
        window.makeKeyAndVisible()
    }
}

private extension AppDependencyContainer
{
    func setLoginWireframe() {
        self.initialViewController.setRootWireframe(self.loginWireframe)
    }
    
    func setSearchWireframe() {
        self.initialViewController.setRootWireframe(self.searchWireframe)
    }
}
