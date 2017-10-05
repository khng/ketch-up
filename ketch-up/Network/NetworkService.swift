import UIKit
import Firebase

protocol NetworkServiceProtocol {
    func generateUserID() -> User
}

class NetworkService: NetworkServiceProtocol {
    var ref: DatabaseReference = Database.database().reference()
    
    func generateUserID() -> User {
        let autoID = ref.child("users").childByAutoId().key
        ref.child("users/\(autoID)").setValue("")
        return autoID
    }
}
