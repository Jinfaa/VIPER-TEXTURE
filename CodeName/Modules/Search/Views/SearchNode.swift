import AsyncDisplayKit

final class SearchNode: BaseNode
{
    private enum Constants
    {
        static let cellHeight: CGFloat = 86
        static let delay: CGFloat = 0.75
    }
    
    private lazy var searchNodeTextField = SearchNodeTextField(height: 50.0, delegate: self)
    
    private let tableNode = ASTableNode(style: .grouped)
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
        
    private let presenter: ISearchDataPresenter
    private var searchTask: DispatchWorkItem?
    
    init(presenter: ISearchDataPresenter) {
        self.presenter = presenter
        
        super.init()
        
        self.addSubnode(self.tableNode)
        
        self.tableNode.delegate = self
        self.tableNode.dataSource = self
        
        self.tableNode.view.showsVerticalScrollIndicator = false
        
        self.tableNode.backgroundColor = .white
        
        self.tableNode.view.separatorStyle = .none
        
        self.tableNode.leadingScreensForBatching = 1
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.setupActivityIndicator(constrainedSize: constrainedSize)
        return ASWrapperLayoutSpec(layoutElement: self.tableNode)
    }
    
    func setupActivityIndicator(constrainedSize: ASSizeRange) {
        var refreshRect = self.activityIndicator.frame
        refreshRect.origin = CGPoint(x: (constrainedSize.max.width - self.activityIndicator.frame.size.width) / 2.0,
                                     y: (constrainedSize.max.height - self.activityIndicator.frame.size.height) / 2.0)
        self.activityIndicator.frame = refreshRect
        self.view.addSubview(self.activityIndicator)
    }
}

extension SearchNode: ASTableDataSource
{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat  {
        return self.searchNodeTextField.style.height.value
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.searchNodeTextField.view
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.count
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        self.presenter.showDetails(index: indexPath.row)
        tableNode.deselectRow(at: indexPath, animated: false)
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return { () ->  ASCellNode in
            guard let repo = self.presenter.getRepo(index: indexPath.row) else {
                return ASCellNode()
            }
            
            let cellNode = RepoCell()
            cellNode.setup(title: repo.fullName,
                           description: repo.repoSearchResultItemDescription ?? "",
                           starsCount: repo.stargazersCount,
                           language: repo.language)
            
            self.presenter.getImageUrl(repo: repo) { url in
                guard let url = url else { return }
                cellNode.updateImage(url: url)
            }
            
            return cellNode
        }
    }
    
    func addRowsIntoTableNode(itemsCount: Int) {
        let count = self.presenter.count
        let indexRange = (count - itemsCount..<count)
        let indexPaths = indexRange.map { IndexPath(row: $0, section: 0) }
        self.tableNode.insertRows(at: indexPaths, with: .none)
    }
    
    func shouldBatchFetch(for tableNode: ASTableNode) -> Bool {
        true
    }
    
    func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
        self.fetchNewBatchWithContext(context)
    }
}

extension SearchNode: ASTableDelegate
{
    func tableNode(_ tableNode: ASTableNode, constrainedSizeForRowAt indexPath: IndexPath) -> ASSizeRange {
        let width = UIScreen.main.bounds.width
        return ASSizeRangeMake(CGSize(width: width, height: Constants.cellHeight))
    }
}

extension SearchNode: UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchTask?.cancel()

        let task = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.presenter.setSearch(text: searchText)
            self.tableNode.reloadData()
        }
        self.searchTask = task

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Constants.delay, execute: task)
    }
}

private extension SearchNode
{
    func fetchNewBatchWithContext(_ context: ASBatchContext?) {
        DispatchQueue.main.async { [weak self] in self?.showLoading(true) }
        
        self.presenter.loadNext { additions, error in
            let asyncBlock = { [weak self] in
                guard let self = self else { return }
                
                if let error = error {
                    print(error) // TODO: show alert
                    self.showLoading(false)
                    if context != nil {
                        context!.completeBatchFetching(true)
                    }
                }
                else {
                    self.showLoading(false)
                    self.addRowsIntoTableNode(itemsCount: additions)
                    context?.completeBatchFetching(true)
                }
            }
            DispatchQueue.main.async(execute: asyncBlock)
        }
    }
}

private extension SearchNode
{
    func showLoading(_ show: Bool) {
        if show {
            self.activityIndicator.startAnimating()
        }
        else {
            self.activityIndicator.stopAnimating()
        }
    }
}
