import Foundation
import Alamofire
import AlamofireObjectMapper

class API {
    
    static let shared = API()
    
    func getCharacters(URL: String, completion: @escaping(_ result: CharactersResult) -> Void){
        
        AF.request(URL, method: .get).validate().responseObject { (response: DataResponse<CharactersResult, AFError>) in

            switch response.result {
            case .success(let response):
                completion(response.self)
            case .failure(_):
                print(#function)
            }
        }
    }
    
    func getEpisodeName(episodeURL: String, completion: @escaping(_ result: String) -> Void) {
        AF.request(episodeURL, method: .get).validate().responseJSON(completionHandler: { response in
            switch response.result {
            case .success(let dictionary):
                if let json = dictionary as? [String : Any] {
                    if let name = json["name"] as? String {
                        completion(name)
                    }
                }
            case .failure(_):
                print(#function)
            }
        })
    }
    
    func getLocationResidents(locationURL: String, completion: @escaping(_ result: [String]) -> Void) {
        AF.request(locationURL, method: .get).validate().responseJSON(completionHandler: { result in
            switch result.result {
            case .success(let dictionary):
                if let json = dictionary as? [String : Any] {
                    if let residentsArray = json["residents"] as? [String] {
                        completion(residentsArray)
                    }
                 }
            case .failure(_):
                print(#function)
            }
            
        })
    }
    
    func getCharacter(URL: String, completion: @escaping(_ result: Character) -> Void) {
        AF.request(URL, method: .get).validate().responseObject(completionHandler: { (response: DataResponse<Character, AFError>) in
            switch response.result {
            case .success(let character):
                completion(character)
            case .failure(let error):
                print(#function)
            }
        })
    }
}
