import Quick
import Nimble

@testable import ketch_up

class QueueSpec: QuickSpec {
    override func spec() {
        describe("Queue") {
            context("when queue is empty") {
                var queue: Queue<Int>!
                beforeEach {
                    queue = Queue(queue: [])
                }
                it("should return a count of 0 if queue is empty") {
                    expect(queue.count()).to(equal(0))
                }
                it("should return a count of 1 if enqueuing an unique element") {
                    queue.enqueue(value: 1)
                    expect(queue.count()).to(equal(1))
                }
                it("should return a count of 0 and return nil if dequeuing an empty queue") {
                    expect(queue.dequeue()).to(beNil())
                    expect(queue.count()).to(equal(0))
                }
            }
            context("when queue has an element") {
                var queue: Queue<Int>!
                beforeEach {
                    queue = Queue(queue: [1])
                }
                it("should return a count of 1") {
                    expect(queue.count()).to(equal(1))
                }
                it("should return a count of 2 if enqueuing an unique element") {
                    queue.enqueue(value: 2)
                    expect(queue.count()).to(equal(2))
                }
                it("should return a count of 1 if enqueuing an element that exisits in the queue") {
                    queue.enqueue(value: 1)
                    expect(queue.count()).to(equal(1))
                }
                it("should return a count of 0 and return a value of 1 if an element is dequeued") {
                    expect(queue.dequeue()).to(equal(1))
                    expect(queue.count()).to(equal(0))
                }
            }
            context("when queue has multiple (2) elements") {
                var queue: Queue<Int>!
                beforeEach {
                    queue = Queue(queue: [1, 2])
                }
                it("should return a count of 2") {
                    expect(queue.count()).to(equal(2))
                }
                it("should return a count of 3 if enqueuing an unique element") {
                    queue.enqueue(value: 3)
                    expect(queue.count()).to(equal(3))
                }
                it("should return a count of 2 if enqueuing an element that exisits in the queue") {
                    queue.enqueue(value: 1)
                    expect(queue.count()).to(equal(2))
                }
                it("should return a count of 1 and return a value of 1 if an element is dequeued") {
                    expect(queue.dequeue()).to(equal(1))
                    expect(queue.count()).to(equal(1))
                }
            }
        }
    }
}
