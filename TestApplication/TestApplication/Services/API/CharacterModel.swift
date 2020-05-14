import Foundation
import ObjectMapper

class Character: Mappable {
    
    var name: String = ""
    var image: String = ""
    var location: Location = Location()
    var episodeURL: String = ""
    var status: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        image <- map["image"]
        location <- map["location"]
        episodeURL <- map["episode.0"]
        status <- map["status"]
    }
    
}
