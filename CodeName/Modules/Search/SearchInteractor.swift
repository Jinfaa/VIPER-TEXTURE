protocol ISearchInteractor: AnyObject
{
    func searchRepositories(text: String, page: Int, completion: @escaping ((Result<RepoSearch, HTTPClient.RequestError>) -> Void))
    func fetchImageUrl(repo: RepoSearchResultItem, completion: @escaping ((URL?) -> Void))
    func logout()
}

final class SearchInteractor
{
    private enum Constrains
    {
        static let maxItems: Int = 10
    }
    
    private let apiService: IApiService

    init(apiService: IApiService) {
        self.apiService = apiService
    }
}

extension SearchInteractor: ISearchInteractor
{
    func searchRepositories(text: String, page: Int, completion: @escaping ((Result<RepoSearch, HTTPClient.RequestError>) -> Void)) {
        self.apiService.searchRepositories(text: text, maxItems: Constrains.maxItems, page: page, completion: completion)
    }
    
    func downloadReadme(repo: RepoSearchResultItem, completion: @escaping ((Result<String, HTTPClient.RequestError>) -> Void)) {
        self.apiService.downloadReadme(login: repo.owner?.login ?? "",
                                       repoName: repo.name,
                                       repoBranch: repo.defaultBranch) { result in
            switch result {
            case .success(let content):
                completion(.success(content))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchImageUrl(repo: RepoSearchResultItem, completion: @escaping ((URL?) -> Void)) {
        self.downloadReadme(repo: repo) { result in
            switch result {
            case .success(let content):
                completion(content.getGithubImageUrl())
            case .failure:
                completion(nil)
            }
        }
    }
    
    func logout() {
        self.apiService.logout()
    }
}
