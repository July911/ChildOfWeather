import UIKit
import RxSwift
import RxCocoa

final class LikeCityViewController: UIViewController {
    
    typealias diffableDataSource = UICollectionViewDiffableDataSource<Int,CityCellViewModel>
    typealias snapshot = NSDiffableDataSourceSnapshot<Int,CityCellViewModel>

    private let bag = DisposeBag()
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
        self.configureView()
        self.configureNavigationController()
        self.configureCollectionViewDataSource()
        self.configureLayout()
        self.bindToViewModel()
    }
    
    private func configureView() {
        self.view.backgroundColor = .white
    }
    
    private func configureNavigationController() {
        self.navigationItem.title = "캐싱된 날씨"
    }
    
    private func configureCollectionViewDataSource() {
        self.dataSource = extractDataSource()
        self.cityCollectionView.register(
            CityCollectionViewCell.self,
            forCellWithReuseIdentifier: String(describing: CityCollectionViewCell.self)
        )
    }
    
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        self.view.addSubview(self.cityCollectionView)
        
        let collectionViewLayout: [NSLayoutConstraint] = [
            self.cityCollectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.cityCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            self.cityCollectionView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            self.cityCollectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(collectionViewLayout)
    }
    
    private func extractDataSource() -> diffableDataSource {
        return diffableDataSource(collectionView: cityCollectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: CityCollectionViewCell.self),
                for: indexPath
            ) as? CityCollectionViewCell
            
            DispatchQueue.main.async {
                
                guard let cell = cell
                else {
                    return
                }
                
                if indexPath == self.cityCollectionView.indexPath(for: cell) {
                    cell.configure(cellViewModel: itemIdentifier)
                }
            }
            
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
        
        guard let dataSource = dataSource else {
            return
        }

        let input = LikeCityViewModel.Input(
            viewWillApeear: self.rx.viewWillAppear.asObservable(),
            didTappedCell: self.cityCollectionView.rx.itemSelected.asObservable()
        )
        
        let output = viewModel?.transform(input: input)
        
        output?.likedCities.asDriver(onErrorJustReturn: [])
            .drive(onNext: { cities in
                var snapshot = snapshot()
                snapshot.appendSections([0])
                snapshot.appendItems(cities)
                dataSource.apply(snapshot)
            })
            .disposed(by: self.bag)
    }
}


