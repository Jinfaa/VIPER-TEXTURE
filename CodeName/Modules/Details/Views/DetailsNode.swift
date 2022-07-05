import AsyncDisplayKit
import SwiftyMarkdown

protocol IDetailsNode: AnyObject
{
    func setup(title: String, description: String, starsCount: Int, language: String?, readme: String, url: String)
}

final class DetailsNode: BaseNode
{
    private let branchNameNode = ASTextNode()
    private let descriptionNode = ASTextNode()
    private let starsCountNode = ASTextNode()
    private let languageNode = ASTextNode()
    private let urlNode = ASTextNode()
    private let readmeNode = ASTextNode()

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let layout = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 4,
            justifyContent: .start,
            alignItems: .start,
            children: [self.branchNameNode, self.descriptionNode, self.footer, self.urlNode, self.readmeNode])

        return ASInsetLayoutSpec(insets: .init(horizontal: 16), child: layout)
    }
}

extension DetailsNode: IDetailsNode
{
    func setup(title: String, description: String, starsCount: Int, language: String?, readme: String, url: String) {
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
        
        self.descriptionNode.maximumNumberOfLines = 1
        
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
        
        let md = SwiftyMarkdown(string: readme)
        self.readmeNode.attributedText = md.attributedString()
        
        self.urlNode.attributedText = NSAttributedString(
            string: "🎈 \(url)",
            attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 9),
                         NSAttributedString.Key.foregroundColor: UIColor.black]
        )
    }
}

private extension DetailsNode
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
