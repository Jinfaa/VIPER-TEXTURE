final class DetailsWireframe: BaseWireframe<DetailsViewController>
{
    init(apiService: IApiService, repo: RepoSearchResultItem) {
        let interactor = DetailsInteractor(apiService: apiService)
        let presenter = DetailsPresenter(interactor: interactor, repo: repo)
        let moduleViewController = DetailsViewController(presenter: presenter)

        super.init(viewController: moduleViewController)
    }
}
