import AsyncDisplayKit

class SearchNodeTextField: ASDisplayNode
{
    var bar: UISearchBar? {
        return self.view as? UISearchBar
    }
    
    init(height: CGFloat, delegate: UISearchBarDelegate) {
        super.init()
        
        self.setViewBlock({
            let searchView = UISearchBar(frame: .zero)
            searchView.delegate = delegate
            searchView.placeholder = "Search..."
            searchView.backgroundImage = nil
            searchView.searchBarStyle = .minimal
            return searchView
        })
        
        self.style.height = .init(unit: .points, value: height)
        self.backgroundColor = .white
    }
}
