struct SearchRepositoriesParams: Codable
{
    let text: String
    let maxItems: Int
    let page: Int
    
    enum CodingKeys: String, CodingKey {
        case text = "q"
        case maxItems = "per_page"
        case page = "page"
    }
}
