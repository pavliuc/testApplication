import UIKit
import NVActivityIndicatorView

protocol CharactersViewProtocol {
    func characterSelected(character: Character?)
}

final class CharactersView: UIView, NibLoadableView {
    
    //MARK: IBOutlets
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var charactersCollectionView: UICollectionView!
    @IBOutlet private weak var loadingIndicator: NVActivityIndicatorView!
    
    //MARK: -Variables
    private var charactersArray: [Character] = []
    private var bottomInset: CGFloat = 0
    private var nextPageURL: String? = nil
    var delegate: CharactersViewProtocol?
    
    //MARK: -Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        registerCell()
        loadingIndicator.setup()
        loadingIndicator.startAnimating()
    }
    
    //MARK: -Functions
    private func commonInit() {
        Bundle.main.loadNibNamed("CharactersView", owner: self, options: nil)
        contentView.fixInView(self)
    }
    
    private func registerCell() {
        charactersCollectionView.register(CharactersCollectionViewCell.self)
    }
    
    private func populateCollectionView() {
        charactersCollectionView.delegate = self
        charactersCollectionView.dataSource = self
        charactersCollectionView.reloadData()
    }
    
    private func loadNextPage() {
        if let nextPage = self.nextPageURL {
            API.shared.getCharacters(URL: nextPage, completion: { result in
                result.results.forEach({ character in
                    self.charactersArray.append(character)
                })
                if let nextPage = result.info["next"] as? String {
                    self.nextPageURL = nextPage
                }
                else
                {
                    self.nextPageURL = nil
                }
                self.charactersCollectionView.reloadData()
            })
        }
    }
    
    func setCharactersResult(result: CharactersResult) {
        self.charactersArray = result.results
        self.populateCollectionView()
        self.loadingIndicator.stopAnimating()
        
        if let nextPage = result.info["next"] as? String {
            self.nextPageURL = nextPage
        }
    }
    
    func setCharactersArray(array: [Character]) {
        self.charactersArray = array
        self.populateCollectionView()
        self.loadingIndicator.stopAnimating()
    }
    
    func setBottomInset(inset: CGFloat) {
        self.bottomInset = inset
    }
}

//MARK: -Extensions
extension CharactersView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return charactersArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width
        let cellHeight = cellWidth * 0.25
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: bottomInset + 20, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CharactersCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        
        cell.setup(character: charactersArray[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == charactersArray.count - 2 {
            loadNextPage()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedCell = collectionView.cellForItem(at: indexPath) as? CharactersCollectionViewCell else { return }
        delegate?.characterSelected(character: selectedCell.getCharacter())
    }
}
