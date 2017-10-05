import UIKit

typealias User = String?

protocol PersistentStoreManagerProtocol {
    func storeCurrent(user: User)
    
    func currentUser() -> User
}

class PersistentStoreManager: PersistentStoreManagerProtocol {
    var userDefaults: UserDefaultsProtocol
    
    init(userDefaults: UserDefaultsProtocol) {
        self.userDefaults = userDefaults
    }
    
    func storeCurrent(user: User) {
        userDefaults.set(user, forKey: "user")
    }
    
    func currentUser() -> User {
        return userDefaults.string(forKey: "user")
    }
}
