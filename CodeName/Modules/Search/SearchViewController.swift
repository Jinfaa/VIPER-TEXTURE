import AsyncDisplayKit

final class SearchViewController: ASDKViewController<BaseNode>
{
    private let presenter: ISearchDataPresenter

    private let searchNode: SearchNode
    
    init(presenter: ISearchDataPresenter) {
        self.presenter = presenter
                
        self.searchNode = SearchNode(presenter: presenter)
        
        super.init(node: BaseNode())

        self.node.addSubnode(searchNode)
        self.node.layoutSpecBlock = { [weak self] (node, constrainedSize) in
            return ASInsetLayoutSpec(insets: .zero, child: self?.searchNode ?? ASDisplayNode())
        }
    }
    
    override func viewDidLoad() {
        self.navigationItem.title = "Repositories"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(self.logout))
    }
    
    @objc
    func logout() {
        self.presenter.logout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

