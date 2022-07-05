import AsyncDisplayKit

final class RepoCell: BaseCellNode
{
    private let imageNode = ASNetworkImageNode()
    private let branchNameNode = ASTextNode()
    private let descriptionNode = ASTextNode()

    private let starsCountNode = ASTextNode()
    private let languageNode = ASTextNode()

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.imageNode.backgroundColor = .lightText
        self.imageNode.cornerRadius = 50/2
        self.imageNode.style.preferredSize = CGSize(width: 50, height: 50)
        self.imageNode.shouldRenderProgressImages = true
        self.descriptionNode.maximumNumberOfLines = 1
        self.descriptionNode.style.flexShrink = 1
        
        let vStack = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 4,
            justifyContent: .spaceBetween,
            alignItems: .start,
            children: [self.branchNameNode, self.descriptionNode, self.footer])
        vStack.style.flexShrink = 1

        let hStack = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 8,
            justifyContent: .start,
            alignItems: .start,
            children: [self.imageNode, vStack])
                
        let backgroundNode = ASDisplayNode()
        backgroundNode.backgroundColor = .systemGroupedBackground
        backgroundNode.cornerRadius = 8
        
        return ASBackgroundLayoutSpec(child: ASInsetLayoutSpec(insets: .init(vertical: 12, horizontal: 18),
                                                               child: ASCenterLayoutSpec(centeringOptions: .Y, child: hStack)),
                                      background: ASInsetLayoutSpec(insets: .init(vertical: 4, horizontal: 8),
                                                                    child: backgroundNode))
    }
}

extension RepoCell
{
    func setup(title: String, description: String, starsCount: Int, language: String?) {
        self.branchNameNode.attributedText = NSAttributedString(
            string: title,
            attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12),
                         NSAttributedString.Key.foregroundColor: UIColor.label]
        )
        
        self.descriptionNode.attributedText = NSAttributedString(
            string: description,
            attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 9),
                         NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
                
        self.starsCountNode.attributedText = NSAttributedString(
            string: "⭐️ \(starsCount)",
            attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 9),
                         NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        
        if let language = language {
            self.languageNode.attributedText = NSAttributedString(
                string: "👨🏻‍💻 \(language)",
                attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 9),
                             NSAttributedString.Key.foregroundColor: UIColor.gray]
            )
        }
    }
    
    func updateImage(url: URL) {
        self.imageNode.setURL(url, resetToDefault: true) // TODO: Need fix for SVG
    }
}

private extension RepoCell
{
    var footer: ASStackLayoutSpec {
        ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 16,
            justifyContent: .start,
            alignItems: .stretch,
            children: [self.starsCountNode, self.languageNode])
    }
}
