import UIKit

typealias User = String?

protocol PersistentStoreManagerProtocol {
    func storeCurrent(user: User)
    
    func currentUser() -> User
}

class PersistentStoreManager {
    
    func storeCurrent(user: User) {
        UserDefaults.standard.set(user, forKey: "user")
    }
    
    func currentUser() -> User {
        return UserDefaults.standard.value(forKey: "user") as! User
    }
    
}
