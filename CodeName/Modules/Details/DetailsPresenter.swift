protocol IDetailsPresenter: AnyObject
{
    func didLoad(detailsNode: IDetailsNode)
}

final class DetailsPresenter
{
    private let interactor: IDetailsInteractor
    private let repo: RepoSearchResultItem

    init(interactor: IDetailsInteractor, repo: RepoSearchResultItem) {
        self.interactor = interactor
        self.repo = repo
    }
}

extension DetailsPresenter: IDetailsPresenter
{
    func didLoad(detailsNode: IDetailsNode) {
        let detailsRender: ((String?) -> Void) = { [weak self] content in
            guard let self = self else { return }
            
            detailsNode.setup(title: self.repo.fullName,
                              description: self.repo.repoSearchResultItemDescription ?? "",
                              starsCount: self.repo.stargazersCount,
                              language: self.repo.language,
                              readme: content ?? "",
                              url: self.repo.htmlURL)
        }
        self.interactor.downloadReadme(repo: self.repo) { result in
            guard case .success(let content) = result else {
                detailsRender(nil)
                return
            }
            detailsRender(content)
        }
    }
}
