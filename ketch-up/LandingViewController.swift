import UIKit

class LandingViewController: UIViewController {
    @IBOutlet weak var landingStartButton: UIButton!
    
    var userManager: UserManagerProtocol!
    
    func configure(userManager: UserManagerProtocol) {
        self.userManager = userManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        landingStartButton.setTitle(NSLocalizedString("landing_start_button", comment: "Start button title on landing page"), for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didTapLandingStartButton(_ sender: Any) {
        if !userManager.userAlreadyCreated() {
            userManager.createUser()
        }
        self.present(QuestionViewController(), animated: true, completion: nil)
    }
}
