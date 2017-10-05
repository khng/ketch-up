import UIKit

protocol UserDefaultsProtocol {    
    func set(_ value: Any?, forKey defaultName: String)
    
    func string(forKey defaultName: String) -> String?
}

extension UserDefaults: UserDefaultsProtocol { }
