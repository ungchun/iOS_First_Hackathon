import Foundation
import CoreLocation

final class UserInfo {
    
    static let FirstRunCheckKey = "FirstRunCheckKey"
    
    static var shared = UserInfo()
    var longitude:Double!
    var latitude:Double!
    var locationAuthStatus = CLLocationManager().authorizationStatus
}
