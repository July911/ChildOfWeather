import UIKit

class LikeCityViewController: UIViewController {
    
    typealias diffableDataSource = UICollectionViewDiffableDataSource<Int,CityCellViewModel>
    typealias snapshot = NSDiffableDataSourceSnapshot<Int,CityCellViewModel>
    
    private let snapShot = snapshot()
    var viewModel: LikeCityViewModel?
    var dataSource: diffableDataSource?
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: configureLayout()
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func configureDataSource() -> diffableDataSource {
        return diffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CityCollectionViewCell.self), for: indexPath) as? CityCollectionViewCell
            //TODO: cell configure
            
            return cell
        }
    }
    
    static func configureLayout() -> UICollectionViewCompositionalLayout {
        
        //item
        
        //row
        
        //section
    }
    
    private func applySnapShot() {
        
    }
}
