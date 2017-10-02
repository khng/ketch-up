import UIKit

class LandingViewController: UIViewController {

    @IBOutlet weak var landingStartButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        landingStartButton.setTitle(NSLocalizedString("landing_start_button", comment: "Start button title on landing page"), for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
