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
            // D
            it("should return nodeD if nodeD is the only node and is unanswered") {
                let rootNodes: [Node] = [nodeD]
                let nodes: [Node] = [nodeD]
                let edges: [Edge] = []
                
                let subject = QuestionGraph(nodes: nodes, edges: edges)
                expect(subject.findListOfNextPossibleQuestions(with: rootNodes)).to(equal([nodeD]))
            }
            // A
            it("should return an empty array if nodeA is the only node and is the answered") {
                let rootNodes: [Node] = [nodeA]
                let nodes: [Node] = [nodeA]
                let edges: [Edge] = []
                
                let subject = QuestionGraph(nodes: nodes, edges: edges)
                expect(subject.findListOfNextPossibleQuestions(with: rootNodes)).to(equal([]))
            }
            // D    E    F
            it("should return an array of nodeD, node E, and nodeF if they are the root nodes and are unanswered") {
                let rootNodes: [Node] = [nodeD, nodeE, nodeF]
                let nodes: [Node] = [nodeD, nodeE, nodeF]
                let edges: [Edge] = []
                
                let subject = QuestionGraph(nodes: nodes, edges: edges)
                expect(subject.findListOfNextPossibleQuestions(with: rootNodes)).to(equal([nodeD, nodeE, nodeF]))
            }
            // A    B    C
            it("should return an empty array if nodeA, nodeB, and nodeC are the root nodes and are answered") {
                let rootNodes: [Node] = [nodeA, nodeB, nodeC]
                let nodes: [Node] = [nodeA, nodeB, nodeC]
                let edges: [Edge] = []
                
                let subject = QuestionGraph(nodes: nodes, edges: edges)
                expect(subject.findListOfNextPossibleQuestions(with: rootNodes)).to(equal([]))
            }
            // A
            //  \
            //   D
            it("should return an array of nodeD if nodeA is a root node, is answered and has an edge to nodeD") {
                let edgeAD = Edge(from: nodeA, to: nodeD)
                let rootNodes: [Node] = [nodeA]
                let nodes: [Node] = [nodeA, nodeD]
                let edges: [Edge] = [edgeAD]
                
                let subject = QuestionGraph(nodes: nodes, edges: edges)
                expect(subject.findListOfNextPossibleQuestions(with: rootNodes)).to(equal([nodeD]))
            }
            // A     D
            //  \   /
            //    E
            it("should return nodeD if nodeA and nodeD are root nodes, and nodeA is answered and nodeA and nodeD are edges to nodeE") {
                let edgeAE = Edge(from: nodeA, to: nodeE)
                let edgeDE = Edge(from: nodeD, to: nodeE)
                let rootNodes: [Node] = [nodeA, nodeD]
                let nodes: [Node] = [nodeA, nodeD, nodeE]
                let edges: [Edge] = [edgeAE, edgeDE]
                
                let subject = QuestionGraph(nodes: nodes, edges: edges)
                expect(subject.findListOfNextPossibleQuestions(with: rootNodes)).to(equal([nodeD]))
            }
            // A     B    D
            //  \   /
            //    E
            it("should return an array of nodeD and nodeE if nodeA, nodeB, and nodeD are root nodes, nodeA and nodeB are answered and nodeA and nodeB are edges to nodeE") {
                let edgeAE = Edge(from: nodeA, to: nodeE)
                let edgeBE = Edge(from: nodeB, to: nodeE)
                let rootNodes: [Node] = [nodeA, nodeB, nodeD]
                let nodes: [Node] = [nodeA, nodeB, nodeD, nodeE]
                let edges: [Edge] = [edgeAE, edgeBE]
                
                let subject = QuestionGraph(nodes: nodes, edges: edges)
                expect(subject.findListOfNextPossibleQuestions(with: rootNodes)).to(equal([nodeD, nodeE]))
            }
            // A   B  D
            // \\ // /
            //  C E
            it("should return an array of nodeD if nodeA, nodeB, and nodeD are root nodes, nodeA, nodeB, nodeC are answered and nodeA and nodeB are edges to nodeC, and nodeE, and nodeD is an edge to nodeE") {
                let edgeAC = Edge(from: nodeA, to: nodeC)
                let edgeBC = Edge(from: nodeB, to: nodeC)
                let edgeAE = Edge(from: nodeA, to: nodeE)
                let edgeBE = Edge(from: nodeB, to: nodeE)
                let edgeDE = Edge(from: nodeD, to: nodeE)
                let rootNodes: [Node] = [nodeA, nodeB, nodeD]
                let nodes: [Node] = [nodeA, nodeB, nodeC, nodeD, nodeE]
                let edges: [Edge] = [edgeAC, edgeBC, edgeAE, edgeBE, edgeDE]
                
                let subject = QuestionGraph(nodes: nodes, edges: edges)
                expect(subject.findListOfNextPossibleQuestions(with: rootNodes)).to(equal([nodeD]))
            }
            // A     B     C
            //  \   / \   /
            //    D     E
            //     \   /
            //       F
            it("should return an array of nodeD and nodeE if nodeA, nodeB, and nodeC are root nodes, nodeA, nodeB, nodeC are answered and nodeA and nodeB is an edge to nodeD, and nodeB and nodeC is an edge to nodeE, and nodeD, and nodeE is an edge to nodeF") {
                let edgeAD = Edge(from: nodeA, to: nodeD)
                let edgeBD = Edge(from: nodeB, to: nodeD)
                let edgeBE = Edge(from: nodeB, to: nodeE)
                let edgeCE = Edge(from: nodeC, to: nodeE)
                let edgeDF = Edge(from: nodeD, to: nodeF)
                let edgeEF = Edge(from: nodeE, to: nodeF)
                let rootNodes: [Node] = [nodeA, nodeB, nodeC]
                let nodes: [Node] = [nodeA, nodeB, nodeC, nodeD, nodeE, nodeF]
                let edges: [Edge] = [edgeAD, edgeBD, edgeBE, edgeCE, edgeDF, edgeEF]
                
                let subject = QuestionGraph(nodes: nodes, edges: edges)
                expect(subject.findListOfNextPossibleQuestions(with: rootNodes)).to(equal([nodeD, nodeE]))
            }
            // A     B
            //  \     \
            //   C     D
            //    \   / \
            //      E    F
            it("should return an array of nodeD if nodeA, and nodeB are root nodes, nodeA, nodeB, nodeC are answered and nodeA is an edge to nodeC, nodeB is an edge to nodeD, and nodeC and nodeD are edges to nodeE and nodeD is also an edge to nodeF") {
                let edgeAC = Edge(from: nodeA, to: nodeC)
                let edgeBD = Edge(from: nodeB, to: nodeD)
                let edgeCE = Edge(from: nodeC, to: nodeE)
                let edgeDE = Edge(from: nodeD, to: nodeE)
                let edgeDF = Edge(from: nodeD, to: nodeF)
                let rootNodes: [Node] = [nodeA, nodeB]
                let nodes: [Node] = [nodeA, nodeB, nodeC, nodeD, nodeE, nodeF]
                let edges: [Edge] = [edgeAC, edgeBD, edgeCE, edgeDE, edgeDF]
                
                let subject = QuestionGraph(nodes: nodes, edges: edges)
                expect(subject.findListOfNextPossibleQuestions(with: rootNodes)).to(equal([nodeD]))
            }
            // A     B     C
            //  \     \     \
            //   D     E     F
            it("should return an array of nodeD, nodeE, nodeF if nodeA, nodeB, and nodeC are root nodes, nodeA, nodeB, nodeC are answered and nodeA is an edge to nodeD, nodeB is an edge to nodeE, and nodeC is an edge to nodeF") {
                let edgeAD = Edge(from: nodeA, to: nodeD)
                let edgeBE = Edge(from: nodeB, to: nodeE)
                let edgeCF = Edge(from: nodeC, to: nodeF)
                let rootNodes: [Node] = [nodeA, nodeB, nodeC]
                let nodes: [Node] = [nodeA, nodeB, nodeC, nodeD, nodeE, nodeF]
                let edges: [Edge] = [edgeAD, edgeBE, edgeCF]
                
                let subject = QuestionGraph(nodes: nodes, edges: edges)
                expect(subject.findListOfNextPossibleQuestions(with: rootNodes)).to(equal([nodeD, nodeE, nodeF]))
            }
            //    A   C  D
            //  / | \ | /
            // B  E   F
            it("should return an array of nodeD, and nodeE if nodeA, nodeC, and nodeD are root nodes, nodeA, nodeB, nodeC are answered and nodeA is an edge to nodeB, nodeE, and nodeF, nodeC is an edge to nodeF, and nodeD is an edge to nodeF") {
                let edgeAB = Edge(from: nodeA, to: nodeB)
                let edgeAE = Edge(from: nodeA, to: nodeE)
                let edgeAF = Edge(from: nodeA, to: nodeF)
                let edgeCF = Edge(from: nodeC, to: nodeF)
                let edgeDF = Edge(from: nodeD, to: nodeF)
                let rootNodes: [Node] = [nodeA, nodeC, nodeD]
                let nodes: [Node] = [nodeA, nodeB, nodeC, nodeD, nodeE, nodeF]
                let edges: [Edge] = [edgeAB, edgeAE, edgeAF, edgeCF, edgeDF]
                
                let subject = QuestionGraph(nodes: nodes, edges: edges)
                expect(subject.findListOfNextPossibleQuestions(with: rootNodes)).to(equal([nodeD, nodeE]))
            }
            //   A
            //  / \
            // B   C
            // \\ //\
            //  D E  F
            it("should return an array of nodeD, nodeE, and nodeF if nodeA is the root node, nodeA, nodeB and nodeC are answered, and nodeA is an edge to nodeB and nodeC, nodeB and nodeC are edges to nodeD and nodeE, and nodeC is also an edge to nodeF") {
                let edgeAB = Edge(from: nodeA, to: nodeB)
                let edgeAC = Edge(from: nodeA, to: nodeC)
                let edgeBD = Edge(from: nodeB, to: nodeD)
                let edgeBE = Edge(from: nodeB, to: nodeE)
                let edgeCD = Edge(from: nodeC, to: nodeD)
                let edgeCE = Edge(from: nodeC, to: nodeE)
                let edgeCF = Edge(from: nodeC, to: nodeF)
                let rootNodes: [Node] = [nodeA]
                let nodes: [Node] = [nodeA, nodeB, nodeC, nodeD, nodeE, nodeF]
                let edges: [Edge] = [edgeAB, edgeAC, edgeBD, edgeBE, edgeCD, edgeCE, edgeCF]
                
                let subject = QuestionGraph(nodes: nodes, edges: edges)
                expect(subject.findListOfNextPossibleQuestions(with: rootNodes)).to(equal([nodeD, nodeE, nodeF]))
            }
        }
    }
}
