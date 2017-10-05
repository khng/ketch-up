import UIKit

class ViewControllerFactory {
    func landingViewController() -> LandingViewController {
        let userDefaults = UserDefaults.standard
        let persistentStoreManager = PersistentStoreManager(userDefaults: userDefaults)
        let networkService = NetworkService()
        let userManager = UserManager(persistentStoreManager: persistentStoreManager, networkService: networkService)
        let landingViewController = LandingViewController(nibName: "LandingViewController", bundle: Bundle.main)
        landingViewController.configure(userManager: userManager)
        return landingViewController
    }
}
