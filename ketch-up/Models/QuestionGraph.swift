import UIKit

class QuestionGraph {
    let nodes: [Node]
    let edges: [Edge]

    init(nodes: [Node], edges: [Edge]) {
        self.nodes = nodes
        self.edges = edges
    }
    
    func findListOfNextPossibleQuestions(with rootNodes: [Node]) -> [Node] {
        
        let queue: Queue<Node> = Queue(queue: rootNodes)
        var unansweredNodes: Set<Node> = []
        var listOfToNodesFromUnansweredNodes: Set<Node> = []
        
        while queue.count() != 0 {
            let node = queue.dequeue()!
            
            if !node.answered {
                unansweredNodes.insert(node)
            } else {
                edges.forEach { edge in
                    if edge.fromNode == node {
                        queue.enqueue(value: edge.toNode)
                    }
                }
            }
        }
        
        unansweredNodes.forEach { node in
            edges.forEach { edge in
                if edge.fromNode == node {
                    listOfToNodesFromUnansweredNodes.insert(edge.toNode)
                }
            }
        }
        
        unansweredNodes.subtract(listOfToNodesFromUnansweredNodes)
        
        return Array(unansweredNodes)
    }
}

class Node {
    var id: String
    var question: String
    var answered: Bool
    
    init(id: String, question: String, answered: Bool) {
        self.id = id
        self.question = question
        self.answered = answered
    }
}

extension Node: Equatable {
    static func ==(lhs: Node, rhs: Node) -> Bool {
        return lhs.id == rhs.id && lhs.question == rhs.question && lhs.answered == rhs.answered
    }
}

extension Node: Hashable {
    var hashValue: Int {
        return id.hashValue ^ question.hashValue ^ answered.hashValue &* 16777619
    }   
}

class Edge {
    var fromNode: Node
    var toNode: Node
    
    init(from fromNode: Node, to toNode: Node) {
        self.fromNode = fromNode
        self.toNode = toNode
    }
}
