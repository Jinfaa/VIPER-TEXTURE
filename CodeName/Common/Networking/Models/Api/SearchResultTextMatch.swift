struct SearchResultTextMatch: Decodable {
    let fragment: String?
    let matches: [Match]?
    let objectType: String?
    let objectURL, property: String?

    enum CodingKeys: String, CodingKey {
        case fragment, matches
        case objectType = "object_type"
        case objectURL = "object_url"
        case property
    }
}

struct Match: Decodable {
    let indices: [Int]?
    let text: String?
}
