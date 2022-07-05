struct RepoSearch: Decodable {
    let incompleteResults: Bool
    let items: [RepoSearchResultItem]
    let totalCount: Int

    enum CodingKeys: String, CodingKey {
        case incompleteResults = "incomplete_results"
        case items
        case totalCount = "total_count"
    }
}
