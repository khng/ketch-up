import UIKit
import Firebase

protocol NetworkServiceProtocol {
    func generateUserID() -> User
}

class NetworkService: NetworkServiceProtocol {
    var ref: DatabaseReference = Database.database().reference()
    
    func generateUserID() -> User {
        let autoID = ref.child("user").childByAutoId()
        return autoID.key
    }
}
