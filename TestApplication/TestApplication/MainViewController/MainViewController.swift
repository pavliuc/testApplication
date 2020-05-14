import UIKit

final class MainViewController: UIViewController, StoryboardInstantiable {
    
    static let storyboardName: String = "MainViewController"

    //MARK: -IBOutlets
    @IBOutlet private weak var charactersView: CharactersView!
    
    //MARK: -Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setStatusBarColor(color: .white)
        charactersView.delegate = self
        charactersView.setBottomInset(inset: self.view.safeAreaInsets.bottom)
        API.shared.getCharacters(URL: URLs.getCharactersURL, completion: { result in
            self.charactersView.setCharactersResult(result: result)
        })
    }
}

//MARK: -Extensions
extension MainViewController: CharactersViewProtocol {
    func characterSelected(character: Character?) {
        if let selectedCharacter = character {
            let detailsViewController = DetailsViewController.instantiate()
            detailsViewController.setCharacter(selectedCharacter: selectedCharacter)
            self.navigationController?.pushViewController(detailsViewController, animated: true)
        }
    }
}
