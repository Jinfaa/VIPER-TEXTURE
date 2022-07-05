extension UIEdgeInsets
{
    init(vertical: CGFloat) {
        self = UIEdgeInsets(top: vertical, left: 0, bottom: vertical, right: 0)
    }
    
    init(horizontal: CGFloat) {
        self = UIEdgeInsets(top: 0, left: horizontal, bottom: 0, right: horizontal)
    }
    
    init(all: CGFloat) {
        self = UIEdgeInsets(top: all, left: all, bottom: all, right: all)
    }
    
    init(vertical: CGFloat, horizontal: CGFloat) {
        self = UIEdgeInsets(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
}
