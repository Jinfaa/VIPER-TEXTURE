final class SearchWireframe: BaseWireframe<SearchViewController>
{
    init(apiService: IApiService, logoutHandler: @escaping (() -> Void)) {
        let interactor = SearchInteractor(apiService: apiService)
        let presenter = SearchPresenter(interactor: interactor, logoutHandler: logoutHandler)
        let moduleViewController = SearchViewController(presenter: presenter)
        
        super.init(viewController: moduleViewController)
        
        presenter.detailsHandler = { 
            let details = DetailsWireframe(apiService: apiService, repo: $0)
            moduleViewController.navigationController?.pushWireframe(details)
        }
    }
}
