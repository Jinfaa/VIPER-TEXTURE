import AsyncDisplayKit
import SafariServices

protocol ILoginViewController: AnyObject
{
    func showAuth()
    func closeAuth(completion: @escaping (() -> Void))
}

final class LoginViewController: ASDKViewController<BaseNode> {
    private let presenter: ILoginPresenter

    private let loginNode = LoginNode()
    
    init(presenter: ILoginPresenter) {
        self.presenter = presenter

        super.init(node: BaseNode())

        self.node.addSubnode(self.loginNode)
        self.node.layoutSpecBlock = { [weak self] (node, constrainedSize) in
            return ASInsetLayoutSpec(insets: .zero, child: self?.loginNode ?? ASDisplayNode())
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.set(vc: self, loginNode: self.loginNode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LoginViewController: ILoginViewController
{
    func showAuth() {
        guard let url = self.presenter.oAuthUrl else { return }
        
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .fullScreen
        self.present(safariVC, animated: true, completion: nil)
    }
    
    func closeAuth(completion: @escaping (() -> Void)) {
        DispatchQueue.main.async { self.presentedViewController?.dismiss(animated: false, completion: completion) }
    }
}
