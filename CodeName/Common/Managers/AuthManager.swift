import Foundation
import KeychainAccess

class AuthManager
{
    fileprivate let tokenKey = "TokenKey"
    fileprivate let keychain = Keychain(service: "CodeName")

    func setToken(_ token: String) {
        self.keychain[tokenKey] = token
    }
    
    func getToken() -> String? {
        self.keychain[tokenKey]
    }
    
    func isTokenExist() -> Bool {
        self.keychain[tokenKey] != nil
    }

    func removeToken() {
        self.keychain[tokenKey] = nil
    }
}
