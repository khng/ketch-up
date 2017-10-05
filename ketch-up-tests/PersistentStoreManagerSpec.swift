import Quick
import Nimble

@testable import ketch_up

class PersistentStoreManagerSpec: QuickSpec {
    override func spec() {
        var subject: PersistentStoreManager!
        var fakeUserDefaults: FakeUserDefaults!
        beforeEach {
            fakeUserDefaults = FakeUserDefaults()
            subject = PersistentStoreManager(userDefaults: fakeUserDefaults)
        }
        describe("PersistentStoreManager") {
            it("should set value for user key") {
                subject.storeCurrent(user: "User Value")
                expect(fakeUserDefaults.user).to(equal("User Value"))
            }
            it("should retrieve user from key") {
                _ = subject.currentUser()
                expect(fakeUserDefaults.user).to(equal("Stored User"))
            }
        }
    }
}

class FakeUserDefaults: UserDefaultsProtocol {
    var user: User = "Stored User"
    
    func set(_ value: Any?, forKey defaultName: String) {
        user = value as! User
    }
    
    func string(forKey defaultName: String) -> String? {
        return user
    }
}
