protocol ISearchDataPresenter: AnyObject
{
    var totalItems: Int { get }
    var count: Int { get }
    
    func loadNext(completion: @escaping (Int, Error?) -> ())
    func getRepo(index: Int) -> RepoSearchResultItem?
    func setSearch(text: String)
    func showDetails(index: Int)
    func getImageUrl(repo: RepoSearchResultItem, completion: @escaping ((URL?) -> Void))
    
    func logout()
}

final class SearchPresenter
{
    var detailsHandler: ((RepoSearchResultItem) -> Void)?

    private var incompleteResults: Bool?
    private var items: [RepoSearchResultItem]?
    private var totalCount: Int?
    
    private var text: String?
    private var currentPage = 0

    private let interactor: ISearchInteractor
    private let logoutHandler: (() -> Void)

    init(interactor: ISearchInteractor, logoutHandler: @escaping (() -> Void)) {
        self.interactor = interactor
        self.logoutHandler = logoutHandler
    }
}

extension SearchPresenter
{
    func setSearch(text: String) {
        self.text = text
        self.items = []
        self.incompleteResults = true
        self.currentPage = 0
    }
}

extension SearchPresenter: ISearchDataPresenter
{
    var totalItems: Int { self.totalCount ?? 0 }
    var count: Int { self.items?.count ?? 0 }
    
    func loadNext(completion: @escaping (Int, Error?) -> ()) {
        guard (self.incompleteResults ?? true) == true, let text = self.text else {
            completion(0, nil)
            return
        }
        
        self.interactor.searchRepositories(text: text, page: self.currentPage) { result in
            switch result {
            case .success(let output):
                self.items?.append(contentsOf: output.items)
                self.totalCount = output.totalCount
                self.incompleteResults = output.incompleteResults

                completion(output.items.count, nil)
            case .failure(let error):
                completion(0, error)
            }
        }
        self.currentPage += 1
    }

    func getRepo(index: Int) -> RepoSearchResultItem? {
        self.items?[index]
    }

    func getImageUrl(repo: RepoSearchResultItem, completion: @escaping ((URL?) -> Void)) {
        self.interactor.fetchImageUrl(repo: repo, completion: completion)
    }
    
    func showDetails(index: Int) {
        guard let repo = self.items?[index] else { return }
        self.detailsHandler?(repo)
    }
    
    func logout() {
        self.interactor.logout()
        self.logoutHandler()
    }
}
