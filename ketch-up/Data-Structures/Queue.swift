import UIKit

class Queue<T: Equatable> {
    var queue: [T]
    
    init(queue: [T]) {
        self.queue = queue
    }
    
    func enqueue(value: T) {
        if !self.queue.contains(value) {
            self.queue.append(value)
        }
    }
    
    // allows ppl who use the func to just not use the return value
    @discardableResult func dequeue() -> T? {
        let firstValue = self.queue.first
        if count() > 0 {
            self.queue.remove(at: 0)
        }
        return firstValue
    }
    
    func count() -> Int {
        return self.queue.count
    }
}
