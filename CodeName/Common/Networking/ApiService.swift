protocol IApiService: AnyObject
{
    func searchRepositories(text: String, maxItems: Int, page: Int, completion: @escaping ((Result<RepoSearch, HTTPClient.RequestError>) -> Void))
    func downloadReadme(login: String, repoName: String, repoBranch: String, completion: @escaping ((Result<String, HTTPClient.RequestError>) -> Void))

    func logout()
}

final class ApiService
{
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
}

extension ApiService: IApiService
{
    func searchRepositories(text: String, maxItems: Int, page: Int, completion: @escaping ((Result<RepoSearch, HTTPClient.RequestError>) -> Void)) {
        guard let url = URL(string: "https://api.github.com/search/repositories") else { return }
        
        let params = SearchRepositoriesParams(text: text, maxItems: maxItems, page: page)

        let httpRequest = HttpRequest(baseUrl: url,
                                      method: .get,
                                      params: params,
                                      headers: [:])
        self.httpClient.performRequest(request: httpRequest, completion: completion)
    }
        
    func downloadReadme(login: String, repoName: String, repoBranch: String, completion: @escaping ((Result<String, HTTPClient.RequestError>) -> Void)) {
        guard let url = URL(string: "https://raw.githubusercontent.com/\(login)/\(repoName)/\(repoBranch)/README.md") else { return }

        let httpRequest = HttpRequest(baseUrl: url,
                                      method: .get,
                                      params: [String](),
                                      headers: [:])
        self.httpClient.performRequest(request: httpRequest, completion: completion)
    }
    
    func logout() {
        self.httpClient.cleanupSession()
    }
}
