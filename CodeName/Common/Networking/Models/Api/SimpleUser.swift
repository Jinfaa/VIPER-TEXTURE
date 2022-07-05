struct SimpleUser: Decodable {
    let avatarURL: String
    let email: String?
    let eventsURL, followersURL, followingURL, gistsURL: String
    let gravatarID: String?
    let htmlURL: String
    let id: Int
    let login: String
    let name: String?
    let nodeID, organizationsURL, receivedEventsURL, reposURL: String
    let siteAdmin: Bool
    let starredAt: String?
    let starredURL, subscriptionsURL, type, url: String

    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
        case email
        case eventsURL = "events_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case gistsURL = "gists_url"
        case gravatarID = "gravatar_id"
        case htmlURL = "html_url"
        case id, login, name
        case nodeID = "node_id"
        case organizationsURL = "organizations_url"
        case receivedEventsURL = "received_events_url"
        case reposURL = "repos_url"
        case siteAdmin = "site_admin"
        case starredAt = "starred_at"
        case starredURL = "starred_url"
        case subscriptionsURL = "subscriptions_url"
        case type, url
    }
}
