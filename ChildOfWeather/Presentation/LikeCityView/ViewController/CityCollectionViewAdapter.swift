import UIKit

final class CityCollectionAdapter: NSObject {
    
    private var dataSource: UICollectionViewDiffableDataSource<Int,CityCellViewModel>?
    let collectionView: UICollectionView
    private let snapshot = NSDiffableDataSourceSnapshot<Int,CityCellViewModel>()
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    func provideDataSource() -> UICollectionViewDiffableDataSource<Int,CityCellViewModel> {
        return UICollectionViewDiffableDataSource<Int,CityCellViewModel>(collectionView: self.collectionView) { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CityCollectionViewCell.self), for: indexPath) as? CityCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            
            
        }
    }
}
