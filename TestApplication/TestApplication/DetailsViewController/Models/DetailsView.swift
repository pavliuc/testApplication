import UIKit
import Kingfisher
import NVActivityIndicatorView

final class DetailsView: UIView, NibLoadableView {
    
    //MARK: -IBOutlets
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var characterAvatarImageView: UIImageView!
    @IBOutlet private weak var lastKnownLocationLabel: UILabel!
    @IBOutlet private weak var firstSeenLabel: UILabel!
    @IBOutlet private weak var statusIndicatorImageView: UIImageView!
    @IBOutlet private weak var characterStatusLabel: UILabel!
    @IBOutlet private weak var loadingIndicator: NVActivityIndicatorView!
    
    //MARK: -Variables
    private var character: Character?
    
    //MARK: -Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    //MARK: -Functions
    private func commonInit() {
        Bundle.main.loadNibNamed("DetailsView", owner: self, options: nil)
        contentView.fixInView(self)
    }
    
    private func initUI() {
        setLabelsTexts()
        setStatusIndicator()
        setAvatarImage()
    }
    
    private func setLabelsTexts() {
        guard let selectedCharacter = self.character else { return }
        
        lastKnownLocationLabel.text = selectedCharacter.location.name
        API.shared.getEpisodeName(episodeURL: selectedCharacter.episodeURL, completion: { text in
            self.firstSeenLabel.text = text
        })
        characterStatusLabel.text = selectedCharacter.status
    }
    
    private func setStatusIndicator() {
        guard let selectedCharacter = self.character else { return }
        
        statusIndicatorImageView.backgroundColor = selectedCharacter.status == "Alive" ? .green : .red
        statusIndicatorImageView.cornerRadius = statusIndicatorImageView.frame.height / 2
    }
    
    private func setAvatarImage() {
        guard let selectedCharacter = self.character else { return }
        
        characterAvatarImageView.cornerRadius = characterAvatarImageView.frame.height * 0.0625
        let imageURL = URL(string: selectedCharacter.image)
        characterAvatarImageView.kf.setImage(with: imageURL) { result in
            switch result {
            case .success(_):
                self.loadingIndicator.stopAnimating()
            case .failure(_):
                print(#function)
            }
            
        }
    }
    
    private func initLoadingIndicator() {
        loadingIndicator.setup()
        loadingIndicator.startAnimating()
    }
    
    func setCharacter(characterModel: Character) {
        self.character = characterModel
        initUI()
    }
    
}
