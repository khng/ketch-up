import UIKit
import Firebase

typealias NodeCLosure = (Dictionary<String, String>) -> Void
typealias EdgeClosure = (Array<Edge>) -> Void

protocol NetworkServiceProtocol {
    func generateUserID() -> User
    
    func fetchQuestionAndId(closure: @escaping NodeCLosure)
    
    func fetchEdges(with nodes: Array<Node>, closure: @escaping EdgeClosure)
    
    func fetchAnswered(autoId: String, closure: @escaping NodeCLosure)

}

class NetworkService: NetworkServiceProtocol {
    var ref: DatabaseReference = Database.database().reference()
    
    func generateUserID() -> User {
        let autoID = ref.child("users").childByAutoId().key
        ref.child("users/\(autoID)").setValue("")
        return autoID
    }
    
    //TODO: set answered question to false on user create
    
    func fetchQuestionAndId(closure: @escaping NodeCLosure) {
        var dictionary: Dictionary<String, String> = [:]
        ref.child("questions").observeSingleEvent(of: DataEventType.value) { (dataSnapshot) in
            dataSnapshot.children.allObjects.forEach { question in
                let questionSnapshot = question as! DataSnapshot
                dictionary[questionSnapshot.key] = questionSnapshot.value as? String
            }
            closure(dictionary)
        }
    }
    
    func fetchEdges(with nodes: Array<Node>, closure: @escaping EdgeClosure) {
        var dictionary: Dictionary<String, Node> = [:]
        nodes.forEach { node in
            dictionary[node.id] = node
        }
        ref.child("relationships").observeSingleEvent(of: DataEventType.value) { (dataSnapshot) in
            var array: Array<Edge> = []
            dataSnapshot.children.allObjects.forEach { relationship in
                let relationshipSnapshot = relationship as! DataSnapshot
                let relationshipArray = relationshipSnapshot.value as! Array<Int>
                let fromId = "\(relationshipArray.first!)"
                let toId = "\(relationshipArray.last!)"
                let fromNode = dictionary[fromId]!
                let toNode = dictionary[toId]!
                let edge = Edge(from: fromNode, to: toNode)
                array.append(edge)
            }
            closure(array)
        }
    }
    
    func fetchAnswered(autoId: String, closure: @escaping NodeCLosure) {
        var dictionary: Dictionary<String, String> = [:]
        ref.child("users").child(autoId).observeSingleEvent(of: DataEventType.value) { (dataSnapshot) in
            dataSnapshot.children.allObjects.forEach { answer in
                let answerSnapshot = answer as! DataSnapshot
                dictionary[answerSnapshot.key] = String(describing: answerSnapshot.value)
            }
            closure(dictionary)
        }
    }
}
