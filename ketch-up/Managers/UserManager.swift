import UIKit
import FirebaseDatabase

protocol UserManagerProtocol {
    func createUser()
    
    func userAlreadyCreated() -> Bool
}

class UserManager: UserManagerProtocol {
    var ref: DatabaseReference = Database.database().reference()
    var persistentStoreManager: PersistentStoreManagerProtocol
    var networkService: NetworkServiceProtocol
    
    init(persistentStoreManager: PersistentStoreManagerProtocol, networkService: NetworkServiceProtocol) {
        self.persistentStoreManager = persistentStoreManager
        self.networkService = networkService
    }
    
    func createUser() {
        persistentStoreManager.storeCurrent(user: networkService.generateUserID())
    }
    
    func userAlreadyCreated() -> Bool {
        return persistentStoreManager.currentUser() != nil
    }
}
