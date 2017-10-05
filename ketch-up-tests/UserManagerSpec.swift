import Quick
import Nimble

@testable import ketch_up

class UserManagerSpec: QuickSpec {
    override func spec() {
        var subject: UserManager!
        var fakePersistentStoreManager: FakePersistentStoreManager!
        var fakeNetworkService: FakeNetworkService!
        beforeEach {
            fakePersistentStoreManager = FakePersistentStoreManager()
            fakeNetworkService = FakeNetworkService()
            subject = UserManager.init(persistentStoreManager: fakePersistentStoreManager, networkService: fakeNetworkService)
        }
        describe("UserManager") {
            it("should return true when user is created") {
                expect(subject.userAlreadyCreated()).to(beTrue())
            }
            it("should not access currentUser more than once") {
                _ = subject.userAlreadyCreated()
                expect(fakePersistentStoreManager.count).to(equal(1))
            }
            it("should store user when creating user") {
                subject.createUser()
                expect(fakePersistentStoreManager.user).to(equal("Expected Stored User"))
            }
        }
    }
}

class FakePersistentStoreManager: PersistentStoreManagerProtocol {
    var count = 0
    var user: User = ""
    
    func storeCurrent(user: User) {
        self.user = user
    }
    
    func currentUser() -> User {
        count += 1
        return "user"
    }
}

class FakeNetworkService: NetworkServiceProtocol {
    func generateUserID() -> User {
        return "Expected Stored User"
    }
}
