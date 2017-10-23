import Quick
import Nimble

@testable import ketch_up

class QuestionGraphSpec: QuickSpec {
    override func spec() {
        var nodeA: Node!
        var nodeB: Node!
        var nodeC: Node!
        var nodeD: Node!
        var nodeE: Node!
        var nodeF: Node!
        
        beforeEach {
            nodeA = Node(id: "123", question: "", answered: true)
            nodeB = Node(id: "234", question: "", answered: true)
            nodeC = Node(id: "345", question: "", answered: true)
            nodeD = Node(id: "456", question: "", answered: false)
            nodeE = Node(id: "567", question: "", answered: false)
            nodeF = Node(id: "678", question: "", answered: false)
        }
        describe("QuestionGraph") {
            //context - if graph looks like this, should return this
            //it - what is returned, edgemap has what? etc
            var rootNodes: [Node]!
            var subject: QuestionGraph!
            // D
            context("if graph has only one node and the node (nodeD) is unanswered, and is a root node") {
                beforeEach {
                    rootNodes = [nodeD]
                    let nodes: [Node] = [nodeD]
                    let edges: [Edge] = []

                    subject = QuestionGraph(nodes: nodes, edges: edges)
                }
                it("should return an array of nodeD") {
                    expect(subject.findListOfNextPossibleQuestions(with: rootNodes)).to(equal([nodeD]))
                }
                it("should return an empty edgeMap"){
                    expect(subject.edgeMap.isEmpty).to(beTrue())
                }
            }
            // A
            context("if graph has only one node and the node (nodeA) is answered, and is a root node") {
                beforeEach {
                    rootNodes = [nodeA]
                    let nodes: [Node] = [nodeA]
                    let edges: [Edge] = []
                    
                    subject = QuestionGraph(nodes: nodes, edges: edges)
                }
                it("should return an empty array") {
                    expect(subject.findListOfNextPossibleQuestions(with: rootNodes)).to(equal([]))
                }
                it("should return an empty edgeMap") {
                    expect(subject.edgeMap.isEmpty).to(beTrue())
                }
            }
            // D    E    F
            context("if graph has three nodes and the nodes (nodeD, nodeE, nodeF) are unanswered, not connected to each other, and are all root nodes") {
                beforeEach {
                    rootNodes = [nodeD, nodeE, nodeF]
                    let nodes: [Node] = [nodeD, nodeE, nodeF]
                    let edges: [Edge] = []
                    
                    subject = QuestionGraph(nodes: nodes, edges: edges)
                }
                it("should return an array of nodeD, node E, and nodeF") {
                    expect(subject.findListOfNextPossibleQuestions(with: rootNodes)).to(equal([nodeD, nodeE, nodeF]))
                }
                it("should return an empty edgeMap") {
                    expect(subject.edgeMap.isEmpty).to(beTrue())
                }
            }
            // A    B    C
            context("if graph has three nodes and the nodes (nodeA, nodeB, nodeC) are answered, not connected to each other, and are all root nodes") {
                beforeEach {
                    rootNodes = [nodeA, nodeB, nodeC]
                    let nodes: [Node] = [nodeA, nodeB, nodeC]
                    let edges: [Edge] = []
                    
                    subject = QuestionGraph(nodes: nodes, edges: edges)
                }
                it("should return an empty array") {
                    expect(subject.findListOfNextPossibleQuestions(with: rootNodes)).to(equal([]))
                }
                it("should return an empty edgeMap") {
                    expect(subject.edgeMap.isEmpty).to(beTrue())
                }
            }
            // A
            //  \
            //   D
            context("if graph has two nodes (nodeA, nodeD), and the rootNode (nodeA) connects to nodeD where nodeA is answered and nodeD is not answered") {
                beforeEach {
                    let edgeAD = Edge(from: nodeA, to: nodeD)
                    
                    rootNodes = [nodeA]
                    let nodes: [Node] = [nodeA, nodeD]
                    let edges: [Edge] = [edgeAD]
                    
                    subject = QuestionGraph(nodes: nodes, edges: edges)
                }
                it("should return an array of nodeD") {
                    expect(subject.findListOfNextPossibleQuestions(with: rootNodes)).to(equal([nodeD]))
                }
                it("should return the correct edgeMap") {
                    expect(subject.edgeMap.count).to(equal(1))
                    expect(subject.edgeMap[nodeA]).to(equal([nodeD]))
                }
            }
            // A     D
            //  \   /
            //    E
            context("if graph has three nodes (nodeA, nodeD, nodeE), and the root nodes (nodeA, nodeD) connects to nodeE where nodeA is answered, and nodeD and nodeE are not answered") {
                beforeEach {
                    let edgeAE = Edge(from: nodeA, to: nodeE)
                    let edgeDE = Edge(from: nodeD, to: nodeE)
                    rootNodes = [nodeA, nodeD]
                    let nodes: [Node] = [nodeA, nodeD, nodeE]
                    let edges: [Edge] = [edgeAE, edgeDE]
                    
                    subject = QuestionGraph(nodes: nodes, edges: edges)
                }
                it("should return an array of nodeD ") {
                    expect(subject.findListOfNextPossibleQuestions(with: rootNodes)).to(equal([nodeD]))
                }
                it("should return the correct edgeMap") {
                    expect(subject.edgeMap.count).to(equal(2))
                    expect(subject.edgeMap[nodeA]).to(equal([nodeE]))
                    expect(subject.edgeMap[nodeD]).to(equal([nodeE]))
                }
            }
            // A     B    D
            //  \   /
            //    E
            context("if graph has four nodes (nodeA, nodeB, nodeD, nodeE), and the root nodes are nodeA, nodeB, and nodeD. nodeA and nodeB are connected to nodeE. nodeA, and nodeB are answered while nodeD, and nodeE are not answered.") {
                beforeEach {
                    let edgeAE = Edge(from: nodeA, to: nodeE)
                    let edgeBE = Edge(from: nodeB, to: nodeE)
                    rootNodes = [nodeA, nodeB, nodeD]
                    let nodes: [Node] = [nodeA, nodeB, nodeD, nodeE]
                    let edges: [Edge] = [edgeAE, edgeBE]
                    
                    subject = QuestionGraph(nodes: nodes, edges: edges)
                }
                it("should return an array of nodeD and nodeE") {
                    expect(subject.findListOfNextPossibleQuestions(with: rootNodes)).to(equal([nodeD, nodeE]))
                }
                it("should return the correct edgeMap") {
                    expect(subject.edgeMap.count).to(equal(2))
                    expect(subject.edgeMap[nodeA]).to(equal([nodeE]))
                    expect(subject.edgeMap[nodeB]).to(equal([nodeE]))
                }
            }
            // A  B  D
            // |\/| /
            // |/\|/
            // C  E
            context("if graph has five nodes (nodeA, nodeB, nodeC, nodeD, nodeE), and the root nodes are nodeA, nodeB, nodeD. nodeA is connected to nodeC, and nodeE. nodeB is connected to nodeC, and nodeE. node D is connected to nodeE. nodeA, nodeB, and nodeC are answered while nodeD, and nodeE are not answered.") {
                beforeEach {
                    let edgeAC = Edge(from: nodeA, to: nodeC)
                    let edgeBC = Edge(from: nodeB, to: nodeC)
                    let edgeAE = Edge(from: nodeA, to: nodeE)
                    let edgeBE = Edge(from: nodeB, to: nodeE)
                    let edgeDE = Edge(from: nodeD, to: nodeE)
                    rootNodes = [nodeA, nodeB, nodeD]
                    let nodes: [Node] = [nodeA, nodeB, nodeC, nodeD, nodeE]
                    let edges: [Edge] = [edgeAC, edgeBC, edgeAE, edgeBE, edgeDE]
                    
                    subject = QuestionGraph(nodes: nodes, edges: edges)
                }
                it("should return an array of nodeD") {
                    expect(subject.findListOfNextPossibleQuestions(with: rootNodes)).to(equal([nodeD]))
                }
                it("should return the correct edgeMap") {
                    expect(subject.edgeMap.count).to(equal(3))
                    expect(subject.edgeMap[nodeA]).to(equal([nodeC, nodeE]))
                    expect(subject.edgeMap[nodeB]).to(equal([nodeC, nodeE]))
                    expect(subject.edgeMap[nodeD]).to(equal([nodeE]))
                }
            }
            // A     B     C
            //  \   / \   /
            //    D     E
            //     \   /
            //       F
            context("if graph has six nodes (nodeA, nodeB, nodeC, nodeD, nodeE, nodeF), and the root nodes are nodeA, nodeB, and nodeC. nodeA is connected to nodeD. nodeB is conencted to nodeD, and nodeE. nodeC is connected to nodeE. node D is connected to nodeF. nodeE is connected to nodeF. nodeA, nodeB, and nodeC are answered while nodeD, nodeE, and nodeF are not answered.") {
                beforeEach {
                    let edgeAD = Edge(from: nodeA, to: nodeD)
                    let edgeBD = Edge(from: nodeB, to: nodeD)
                    let edgeBE = Edge(from: nodeB, to: nodeE)
                    let edgeCE = Edge(from: nodeC, to: nodeE)
                    let edgeDF = Edge(from: nodeD, to: nodeF)
                    let edgeEF = Edge(from: nodeE, to: nodeF)
                    rootNodes = [nodeA, nodeB, nodeC]
                    let nodes: [Node] = [nodeA, nodeB, nodeC, nodeD, nodeE, nodeF]
                    let edges: [Edge] = [edgeAD, edgeBD, edgeBE, edgeCE, edgeDF, edgeEF]
                    
                    subject = QuestionGraph(nodes: nodes, edges: edges)
                }
                it("should return an array of nodeD and nodeE") {
                    expect(subject.findListOfNextPossibleQuestions(with: rootNodes)).to(equal([nodeD, nodeE]))
                }
                it("should return the correct edgeMap") {
                    expect(subject.edgeMap.count).to(equal(5))
                    expect(subject.edgeMap[nodeA]).to(equal([nodeD]))
                    expect(subject.edgeMap[nodeB]).to(equal([nodeD, nodeE]))
                    expect(subject.edgeMap[nodeC]).to(equal([nodeE]))
                    expect(subject.edgeMap[nodeD]).to(equal([nodeF]))
                    expect(subject.edgeMap[nodeE]).to(equal([nodeF]))
                }
            }
            // A     B
            //  \     \
            //   C     D
            //    \   / \
            //      E    F
            context("if graph has six nodes (nodeA, nodeB, nodeC, nodeD, nodeE, nodeF), and the root nodes are nodeA, and nodeB. nodeA is connected to nodeC. node B is connected to nodeD. nodeC is connected to nodeE. node D is conected to nodeE, and nodeF. nodeA, nodeB, and nodeC are answered while nodeD, nodeE, and nodeF are not answered.") {
                beforeEach {
                    let edgeAC = Edge(from: nodeA, to: nodeC)
                    let edgeBD = Edge(from: nodeB, to: nodeD)
                    let edgeCE = Edge(from: nodeC, to: nodeE)
                    let edgeDE = Edge(from: nodeD, to: nodeE)
                    let edgeDF = Edge(from: nodeD, to: nodeF)
                    rootNodes = [nodeA, nodeB]
                    let nodes: [Node] = [nodeA, nodeB, nodeC, nodeD, nodeE, nodeF]
                    let edges: [Edge] = [edgeAC, edgeBD, edgeCE, edgeDE, edgeDF]
                    
                    subject = QuestionGraph(nodes: nodes, edges: edges)
                }
                it("should return an array of nodeD") {
                    expect(subject.findListOfNextPossibleQuestions(with: rootNodes)).to(equal([nodeD]))
                }
                it("should return the correct edgeMap") {
                    expect(subject.edgeMap.count).to(equal(4))
                    expect(subject.edgeMap[nodeA]).to(equal([nodeC]))
                    expect(subject.edgeMap[nodeB]).to(equal([nodeD]))
                    expect(subject.edgeMap[nodeC]).to(equal([nodeE]))
                    expect(subject.edgeMap[nodeD]).to(equal([nodeE, nodeF]))
                }
            }
            // A     B     C
            //  \     \     \
            //   D     E     F
            context("if graph has six nodes (nodeA, nodeB, nodeC, nodeD, nodeE, nodeF), and the root nodes are nodeA, nodeB, and nodeC. nodeA is connected to nodeD. nodeB is connected to nodeE. nodeC is connected to nodeF. nodeA, nodeB, and nodeC are answered while nodeD, nodeE, and nodeF are not answered.") {
                beforeEach {
                    let edgeAD = Edge(from: nodeA, to: nodeD)
                    let edgeBE = Edge(from: nodeB, to: nodeE)
                    let edgeCF = Edge(from: nodeC, to: nodeF)
                    rootNodes = [nodeA, nodeB, nodeC]
                    let nodes: [Node] = [nodeA, nodeB, nodeC, nodeD, nodeE, nodeF]
                    let edges: [Edge] = [edgeAD, edgeBE, edgeCF]
                    
                 subject = QuestionGraph(nodes: nodes, edges: edges)
                }
                it("should return an array of nodeD, nodeE, nodeF") {
                    expect(subject.findListOfNextPossibleQuestions(with: rootNodes)).to(equal([nodeD, nodeE, nodeF]))
                }
                it("should return the correct edgeMap") {
                    expect(subject.edgeMap.count).to(equal(3))
                    expect(subject.edgeMap[nodeA]).to(equal([nodeD]))
                    expect(subject.edgeMap[nodeB]).to(equal([nodeE]))
                    expect(subject.edgeMap[nodeC]).to(equal([nodeF]))
                }
            }
            //    A   C  D
            //  / | \ | /
            // B  E   F
            context("if graph has six nodes (nodeA, nodeB, nodeC, nodeD, nodeE, nodeF), and the root nodes are nodeA, nodeC, and nodeD. nodeA is connected to nodeB, nodeE, and nodeF. nodeC is connected to nodeF. nodeD is connected to nodeF. nodeA, nodeB, and nodeC are answered while nodeD, nodeE, and nodeF are not answered.") {
                beforeEach {
                    let edgeAB = Edge(from: nodeA, to: nodeB)
                    let edgeAE = Edge(from: nodeA, to: nodeE)
                    let edgeAF = Edge(from: nodeA, to: nodeF)
                    let edgeCF = Edge(from: nodeC, to: nodeF)
                    let edgeDF = Edge(from: nodeD, to: nodeF)
                    rootNodes = [nodeA, nodeC, nodeD]
                    let nodes: [Node] = [nodeA, nodeB, nodeC, nodeD, nodeE, nodeF]
                    let edges: [Edge] = [edgeAB, edgeAE, edgeAF, edgeCF, edgeDF]
                    
                    subject = QuestionGraph(nodes: nodes, edges: edges)
                }
                it("should return an array of nodeD, and nodeE") {
                    expect(subject.findListOfNextPossibleQuestions(with: rootNodes)).to(equal([nodeD, nodeE]))
                }
                it("should return the correct edgeMap") {
                    expect(subject.edgeMap.count).to(equal(3))
                    expect(subject.edgeMap[nodeA]).to(equal([nodeB, nodeE, nodeF]))
                    expect(subject.edgeMap[nodeC]).to(equal([nodeF]))
                    expect(subject.edgeMap[nodeD]).to(equal([nodeF]))
                }
            }
            //   A
            //  / \
            // B   C
            // |\ /|\
            // | | | |
            // |/ \| |
            // D   E F
            context("if graph has six nodes (nodeA, nodeB, nodeC, nodeD, nodeE, nodeF), and the root node is nodeA. nodeA is connected to nodeB, and nodeC. nodeB is connected is nodeD, and nodeE. node C is connected to nodeD, nodeE, and nodeF. nodeA, nodeB, and nodeC are answered while nodeD, nodeE, and nodeF are not answered.") {
                beforeEach {
                    let edgeAB = Edge(from: nodeA, to: nodeB)
                    let edgeAC = Edge(from: nodeA, to: nodeC)
                    let edgeBD = Edge(from: nodeB, to: nodeD)
                    let edgeBE = Edge(from: nodeB, to: nodeE)
                    let edgeCD = Edge(from: nodeC, to: nodeD)
                    let edgeCE = Edge(from: nodeC, to: nodeE)
                    let edgeCF = Edge(from: nodeC, to: nodeF)
                    rootNodes = [nodeA]
                    let nodes: [Node] = [nodeA, nodeB, nodeC, nodeD, nodeE, nodeF]
                    let edges: [Edge] = [edgeAB, edgeAC, edgeBD, edgeBE, edgeCD, edgeCE, edgeCF]
                    
                    subject = QuestionGraph(nodes: nodes, edges: edges)
                }
                it("should return an array of nodeD, nodeE, and nodeF") {
                    expect(subject.findListOfNextPossibleQuestions(with: rootNodes)).to(equal([nodeD, nodeE, nodeF]))
                }
                it("should return the correct edgeMap") {
                    expect(subject.edgeMap.count).to(equal(3))
                    expect(subject.edgeMap[nodeA]).to(equal([nodeB, nodeC]))
                    expect(subject.edgeMap[nodeB]).to(equal([nodeD, nodeE]))
                    expect(subject.edgeMap[nodeC]).to(equal([nodeD, nodeE, nodeF]))
                }
            }
        }
    }
}
