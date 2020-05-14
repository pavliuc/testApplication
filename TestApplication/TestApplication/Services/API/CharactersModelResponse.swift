import Foundation
import ObjectMapper

class CharactersResult: Mappable {
    
    var info: [String : Any] = [:]
    var results: [Character] = []
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        info <- map["info"]
        results <- map["results"]
    }
    
}
