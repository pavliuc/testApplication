import UIKit
import NVActivityIndicatorView
import Kingfisher

final class CharactersCollectionViewCell: UICollectionViewCell, NibLoadableView, ReusableCell {
    
    static let identifier: String = "CharactersCollectionViewCell"
    
    //MARK: -IBOutlets
    @IBOutlet private weak var characterImageView: UIImageView!
    @IBOutlet private weak var characterNameLabel: UILabel!
    @IBOutlet private weak var lastKnownLocationLabel: UILabel!
    @IBOutlet private weak var characterFirstSeenLabel: UILabel!
    @IBOutlet private weak var loadingIndicator: NVActivityIndicatorView!
    
    //MARK: -Variables
    private var cellCharacter: Character?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        loadingIndicator.setup()
        loadingIndicator.startAnimating()
    }
    
    //MARK: -Functions
    func setup(character: Character) {
        self.cellCharacter = character
        initUI()
    }
    
    private func initUI() {
        self.layoutIfNeeded()
        self.cornerRadius = self.frame.height * 0.125
        self.characterImageView.roundCorners(corners: [.bottomLeft, .topLeft], radius: self.frame.height * 0.125)
        self.setCharacterAvatar()
        self.setupLabelsTexts()
        self.addShadow(radius: 4, color: .black, opacity: 0.1, offSet: .zero, maskToBouds: false)
    }
    
    private func setupLabelsTexts() {
        guard let character = cellCharacter else { return }
        self.characterNameLabel.text = character.name
        self.lastKnownLocationLabel.text = character.location.name
        API.shared.getEpisodeName(episodeURL: character.episodeURL, completion: { text in
            self.characterFirstSeenLabel.text = text
        })
    }
    
    private func setCharacterAvatar() {
        guard let character = cellCharacter else { return }
        let characterAvatarURL = URL(string: character.image)
        characterImageView.kf.setImage(with: characterAvatarURL) { result in
            switch result {
            case .success(_):
                self.loadingIndicator.stopAnimating()
            case .failure(_):
                break
            }
        }
    }
    
    func getCharacter() -> Character? {
        return self.cellCharacter
    }
}
