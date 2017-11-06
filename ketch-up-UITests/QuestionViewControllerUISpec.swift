import XCTest
import EarlGrey

@testable import ketch_up

class QuestionViewControllerUISpec: XCTestCase {
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    func testQuestionViewIsDisplayedAfterSelectingStartButton() {
        EarlGrey.select(elementWithMatcher: grey_accessibilityLabel("LandingStartButton"))
            .perform(grey_tap())
        
        EarlGrey.select(elementWithMatcher: grey_accessibilityLabel("QuestionLabel"))
            .assert(grey_sufficientlyVisible())
        EarlGrey.select(elementWithMatcher: grey_accessibilityLabel("CloseButton"))
            .assert(grey_sufficientlyVisible())
    }
}
