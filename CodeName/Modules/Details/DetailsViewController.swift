import AsyncDisplayKit

final class DetailsViewController: ASDKViewController<ASScrollNode>
{
    private let presenter: IDetailsPresenter

    private let detailsNode: DetailsNode
    
    private let rootNode: ASScrollNode = {
        let rootNode = ASScrollNode()
        rootNode.backgroundColor = .white
        rootNode.automaticallyManagesContentSize = true
        rootNode.scrollableDirections = [.up,.down]
        return rootNode
    }()
    
    init(presenter: IDetailsPresenter) {
        self.presenter = presenter
                
        self.detailsNode = DetailsNode()
        
        super.init(node: self.rootNode)

        self.node.addSubnode(self.detailsNode)
        self.node.layoutSpecBlock = { [weak self] (node, constrainedSize) in
            return ASInsetLayoutSpec(insets: .zero, child: self?.detailsNode ?? ASDisplayNode())
        }
    }
    
    override func viewDidLoad() {
        self.presenter.didLoad(detailsNode: self.detailsNode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
