import AsyncDisplayKit

class BaseNode: ASDisplayNode
{
    override init() {
        super.init()
        self.backgroundColor = .white
        self.automaticallyManagesSubnodes = true
    }
}
