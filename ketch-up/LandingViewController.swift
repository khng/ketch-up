import UIKit
import FirebaseDatabase

class LandingViewController: UIViewController {

    @IBOutlet weak var landingStartButton: UIButton!
    
    var userManager: UserManagerProtocol!
    
    func configure(userManager: UserManagerProtocol) {
        self.userManager = userManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        landingStartButton.setTitle(NSLocalizedString("landing_start_button", comment: "Start button title on landing page"), for: .normal)
        
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        ref.child("users").setValue(["username": "username"])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didTapLandingStartButton(_ sender: Any) {
        if !userManager.userAlreadyCreated() {
            userManager.createUser()
        }
    }
}
