import Quick
import Nimble

@testable import ketch_up

class LandingViewControllerSpec: QuickSpec {
    override func spec() {
        var window: UIWindow!
        var subject: LandingViewController!
        var userNeverCreatedFakeUserManager: UserNeverCreatedFakeUserManager!
        var userCreatedFakeUserManager: UserCreatedFakeUserManager!
        
        beforeEach {
            subject = LandingViewController()
            userNeverCreatedFakeUserManager = UserNeverCreatedFakeUserManager()
            userCreatedFakeUserManager = UserCreatedFakeUserManager()
            window = UIWindow(frame: UIScreen.main.bounds)
            window.rootViewController = subject
            window.makeKeyAndVisible()
        }
        
        describe("LandingViewController loaded") {
            context("When user has pressed start for the first time") {
                beforeEach {
                    subject.configure(userManager: userNeverCreatedFakeUserManager)
                    subject.landingStartButton.sendActions(for: .touchUpInside)
                }
                it("the UserManager should be asked to created a User") {
                    expect(userNeverCreatedFakeUserManager.count).to(equal(1))
                }
            }
            context("When user has pressed start before") {
                beforeEach {
                    subject.configure(userManager: userCreatedFakeUserManager)
                    subject.landingStartButton.sendActions(for: .touchUpInside)
                }
                it("the UserManager should be asked to check if already created") {
                    expect(userCreatedFakeUserManager.count).to(equal(1))
                }
            }
        }
    }
}

class UserNeverCreatedFakeUserManager: UserManagerProtocol {
    var count = 0
    
    func createUser() {
        count += 1
    }
    
    func userAlreadyCreated() -> Bool {
        return false
    }
}

class UserCreatedFakeUserManager: UserManagerProtocol {
    var count = 0
    
    func createUser() {
        // this should never be called. fake assumes user has already been created
        assert(0 == 1)
    }
    
    func userAlreadyCreated() -> Bool {
        count += 1
        return true
    }
}
