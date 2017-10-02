import Quick
import Nimble

@testable import ketch_up

class LandingViewControllerSpec: QuickSpec {
    override func spec() {
        var subject: LandingViewController!
        
        beforeEach {
            subject = LandingViewController()
        }
        
        describe("LandingViewController loaded") {
            context("When user has pressed start for the first time") {
                it("An UID is generated and saved to user default") {
                    //check user defaults for key
                    expect(UserDefaults.object("UID")).toEqual(expectedUID)
                }
            }
            context("When user has pressed start before") {
                it("No network call is made to fetch UID") {
                    
                }
            }
        }
    }
}
