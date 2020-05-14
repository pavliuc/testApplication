import Foundation
import ObjectMapper

class Location: Mappable {
    var name: String = ""
    var url: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        url <- map["url"]
    }
}
