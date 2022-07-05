import AsyncDisplayKit

class BaseCellNode: ASCellNode
{
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
}
