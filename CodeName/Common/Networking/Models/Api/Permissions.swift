struct Permissions: Decodable {
    let admin: Bool
    let maintain: Bool?
    let pull, push: Bool
    let triage: Bool?
}
