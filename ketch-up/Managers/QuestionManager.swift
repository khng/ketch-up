import UIKit

class QuestionManager {
    var persistentStoreManager: PersistentStoreManagerProtocol
    var networkService: NetworkServiceProtocol
    
    init(persistentStoreManager: PersistentStoreManagerProtocol, networkService: NetworkServiceProtocol) {
        self.persistentStoreManager = persistentStoreManager
        self.networkService = networkService
    }
    
    func getAllNodes(closure: @escaping (Array<Node>)->Void) {
        let userId = persistentStoreManager.currentUser()!
        var nodes: [Node] = []
        var questionAndIdDictionary: Dictionary<String,String> = [:]
        var answeredDictionary: Dictionary<String,String> = [:]
        
        let group = DispatchGroup()
        
        group.enter()
        networkService.fetchQuestionAndId { (dictionary) in
            dictionary.forEach { (key, value) in
                questionAndIdDictionary[key] = value
            }
            group.leave()
        }
        
        group.enter()
        networkService.fetchAnswered(autoId: userId) { (dictionary) in
            dictionary.forEach({ (key, value) in
                answeredDictionary[key] = value
            })
            group.leave()
        }
        
        group.notify(queue: .main) {
            questionAndIdDictionary.forEach{ (key, value) in
                let answered = (Int(answeredDictionary[key]!) ?? 0) != 0
                let node = Node(id: key, question: value, answered: answered)
                nodes.append(node)
            }
            closure(nodes)
        }
    }
    
    func getEdges(closure: @escaping (Array<Edge>)->Void) {
        var edges: [Edge] = []
        getAllNodes { (nodes) in
            self.networkService.fetchEdges(with: nodes, closure: { (array) in
                array.forEach({ (edge) in
                    let edgeObject = Edge(from: edge.fromNode, to: edge.toNode)
                    edges.append(edgeObject)
                })
                closure(edges)
            })
        }
    }
    
    func getRootNodes(closure: @escaping (Array<Node>)->Void) {
        var toNodes: Set<Node> = []
        var rootNodes: Set<Node> = []
        
        getEdges { (edges) in
            edges.forEach { (edge) in
                toNodes.insert(edge.toNode)
            }
            self.getAllNodes { (nodes) in
                rootNodes.formUnion(nodes)
                nodes.forEach({ (node) in
                    toNodes.forEach({ (toNode) in
                        if node.id == toNode.id {
                            rootNodes.remove(node)
                        }
                    })
                })
                closure(Array(rootNodes))
            }
        }
    }
    
    func getUnansweredQuestions(closure: @escaping (Array<Node>)->Void) {
        var unansweredQuestions: Array<Node> = []
        getAllNodes { (nodes) in
            self.getEdges { (edges) in
                self.getRootNodes { (rootNodes) in
                    let questionGraph = QuestionGraph(nodes: nodes, edges: edges)
                    unansweredQuestions = questionGraph.findListOfNextPossibleQuestions(with: rootNodes)
                    closure(unansweredQuestions)
                }
            }
        }
    }
}
