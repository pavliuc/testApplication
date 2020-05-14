import UIKit

final class DetailsViewController: UIViewController, StoryboardInstantiable {
    
    static let storyboardName: String = "DetailsViewController"

    //MARK: -IBOutlets
    @IBOutlet private weak var alsoFromLabel: UILabel!
    @IBOutlet private weak var charactersView: CharactersView!
    @IBOutlet private weak var detailsView: DetailsView!
    
    //MARK: -Variables
    private var selectedCharacter: Character = Character()
    private var suggestedCharacters: [Character] = []
    
    //MARK: -Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = selectedCharacter.name
        charactersView.delegate = self
        setSuggestionLabelText()
        charactersView.setBottomInset(inset: self.view.safeAreaInsets.bottom)
        detailsView.setCharacter(characterModel: selectedCharacter)
        changeBackButtonAction()
    }
    
    //MARK: -Functions
    private func setSuggestionLabelText() {
        alsoFromLabel.text = "Also from \"\(selectedCharacter.location.name)\""
    }
    
    private func getSuggestions() {
        API.shared.getLocationResidents(locationURL: selectedCharacter.location.url, completion: { residents in
            for residentURL in residents {
                API.shared.getCharacter(URL: residentURL, completion: { result in
                    self.suggestedCharacters.append(result)

                    if self.suggestedCharacters.count == residents.count {
                        self.charactersView.setCharactersArray(array: self.suggestedCharacters.filter( { $0.name != self.selectedCharacter.name } ))
                    }
                })
            }
        })
    }
    
    private func changeBackButtonAction() {

        self.navigationItem.hidesBackButton = true
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 60))
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 10, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        let backArrow = UIImage(named: "backBarButton")
        imageView.image = backArrow
        
        let label = UILabel(frame: CGRect(x: 20, y: 10, width: 50, height: 20))
        label.text = "Back"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(back(sender:)))
        view.addGestureRecognizer(tapGesture)

        view.addSubview(imageView)
        view.addSubview(label)

        let leftBarButtonItem = UIBarButtonItem(customView: view)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc func back(sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func setCharacter(selectedCharacter: Character) {
        self.selectedCharacter = selectedCharacter
        getSuggestions()
    }
}

//MARK: -Extensions
extension DetailsViewController: CharactersViewProtocol {
    func characterSelected(character: Character?) {
        guard let selectedCharacter = character else { return }
        let detailsViewController = DetailsViewController.instantiate()
        detailsViewController.setCharacter(selectedCharacter: selectedCharacter)
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
}
