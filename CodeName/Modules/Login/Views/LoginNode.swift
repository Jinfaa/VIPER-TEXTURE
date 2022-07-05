import AsyncDisplayKit

protocol ILoginNode: AnyObject
{
    var logInCompletion: (() -> Void)? { get set }
}

final class LoginNode: BaseCellNode, ILoginNode
{
    var logInCompletion: (() -> Void)?

    private let submitButton = ASButtonNode()

    override init() {
        super.init()
        self.setup()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec
    {
        let children = [self.submitButton]
        let vStack = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 8,
            justifyContent: .center,
            alignItems: .stretch,
            children: children)
        
        return ASInsetLayoutSpec(insets: .init(top: 0, left: 18, bottom: 0, right: 18),
                                 child: ASCenterLayoutSpec(centeringOptions: .Y, sizingOptions: [],
                                                           child: vStack))
    }
}

private extension LoginNode
{
    func setup() {
        self.submitButton.setTitle("Log In", with: nil, with: .systemGray, for: .normal)
        self.submitButton.setTitle("Log In", with: nil, with: .systemBlue, for: .highlighted)

        self.submitButton.addTarget(self, action: #selector(self.logIn), forControlEvents: .touchUpInside)
    }
    
    @objc
    func logIn() {
        self.logInCompletion?()
    }
}
