protocol IDetailsInteractor: AnyObject
{
    func downloadReadme(repo: RepoSearchResultItem, completion: @escaping ((Result<String, HTTPClient.RequestError>) -> Void))
}

final class DetailsInteractor
{
    private let apiService: IApiService

    init(apiService: IApiService) {
        self.apiService = apiService
    }
}

extension DetailsInteractor: IDetailsInteractor
{
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
}
