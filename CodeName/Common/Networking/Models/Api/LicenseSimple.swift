struct LicenseSimple: Decodable {
    let htmlURL: String?
    let key, name, nodeID: String
    let spdxID, url: String?

    enum CodingKeys: String, CodingKey {
        case htmlURL = "html_url"
        case key, name
        case nodeID = "node_id"
        case spdxID = "spdx_id"
        case url
    }
}
