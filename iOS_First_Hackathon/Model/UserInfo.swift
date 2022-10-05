import Foundation

class UserInfo {
    
    static let FirstRunCheckKey = "FirstRunCheckKey"
    
    static var shared = UserInfo()
    var longitude:Double!
    var latitude:Double!
}
