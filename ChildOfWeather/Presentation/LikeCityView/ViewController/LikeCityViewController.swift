import UIKit

final class LikeCityViewController: UIViewController {
    
    typealias diffableDataSource = UICollectionViewDiffableDataSource<Int,CityCellViewModel>
    typealias snapshot = NSDiffableDataSourceSnapshot<Int,CityCellViewModel>
    
    private let snapShot = snapshot()
    var viewModel: LikeCityViewModel?
    var dataSource: diffableDataSource?
    
    private let cityCollectionView: UICollectionView = {
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
        return diffableDataSource(collectionView: cityCollectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CityCollectionViewCell.self), for: indexPath) as? CityCollectionViewCell
            cell?.configure(cellViewModel: itemIdentifier)
        
            return cell
        }
    }
    
    static func configureLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { section, _ in
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 5,
            leading: 5,
            bottom: 5,
            trailing: 5
        )
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
            
        return section
      }
    }
    
    private func bindToViewModel() {
        
    }
}
