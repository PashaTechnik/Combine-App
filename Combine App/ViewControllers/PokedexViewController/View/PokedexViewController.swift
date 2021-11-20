import UIKit

final class PokedexViewController: CollectionViewController {
    

    private let interactor: PokedexInteractable
    private let viewModel: ViewModel


    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    

    init(interactor: PokedexInteractable, viewModel: ViewModel = ViewModel()) {
        self.interactor = interactor
        self.viewModel = viewModel
        super.init(layout: UICollectionViewFlowLayout.pokedexLayout)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.title
        
        collectionView.backgroundColor = .darkGrey
        navigationItem.backButtonTitle = ""
        
        requestData()
    }
    

    private func requestData() {
        startSpinner()
        
        viewModel.requestData { [weak self] result in
            self?.spinner.stopAnimating()
            
            switch result {
            case let .success(dataSource): self?.collectionData = dataSource
            case let .failure(error): print(error.localizedDescription)
            }
        }
    }
    
    private func startSpinner() {
        collectionView.backgroundView = collectionData.hasData ? nil : spinner
        spinner.startAnimating()
    }
    

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        interactor.selectPokemon(at: indexPath, in: collectionView)
    }
}


extension PokedexViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .cellSize(from: collectionView)
    }
}


extension PokedexViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.hasScrolledToBottom else { return }
        
        spinner.startAnimating()
        requestData()
    }
}

