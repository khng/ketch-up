import XCTest
import EarlGrey

class LandingViewControllerUISpec: XCTestCase {
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    func testStartButtonIsVisible() {
        EarlGrey.select(elementWithMatcher: grey_accessibilityLabel("LandingStartButton"))
            .assert(grey_sufficientlyVisible())
        EarlGrey.select(elementWithMatcher: grey_buttonTitle("Start"))
            .assert(grey_sufficientlyVisible())
    }
}
