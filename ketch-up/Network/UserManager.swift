import UIKit
import FirebaseDatabase

protocol UserManagerProtocol {
    func createUser()
    
    func userAlreadyCreated() -> Bool
}

class UserManager: UserManagerProtocol {
    var ref: DatabaseReference = Database.database().reference()
    
    func createUser() {
        
    }
    
    func userAlreadyCreated() -> Bool {
        return PersistentStoreManager().currentUser() != nil
    }
}
