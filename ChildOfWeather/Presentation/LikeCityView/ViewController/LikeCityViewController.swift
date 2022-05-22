import UIKit
import RxSwift
import RxCocoa

final class LikeCityViewController: UIViewController {
    // MARK: - TypeLias
    typealias diffableDataSource = UICollectionViewDiffableDataSource<Int,CityCellViewModel>
    typealias snapshot = NSDiffableDataSourceSnapshot<Int,CityCellViewModel>
    // MARK: - Properties
    private let bag = DisposeBag()
    var viewModel: LikeCityViewModel?
    var dataSource: diffableDataSource?
    // MARK: - UI Components
    private let cityCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: configureLayout()
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    
        return collectionView
    }()
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        self.configureNavigationController()
        self.configureCollectionViewDataSource()
        self.configureLayout()
        self.bindToViewModel()
    }
    // MARK: - Method
    private func configureView() {
        self.view.backgroundColor = .white
    }
    
    private func configureNavigationController() {
        self.navigationItem.title = "둘러본 날씨"
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
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.5)
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitem: item,
                count: 2
            )
            group.interItemSpacing = .fixed(5)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 5
            
            let layout = UICollectionViewCompositionalLayout(section: section)
        
            return layout
    }
    
    private func bindToViewModel() {
        
        guard let dataSource = dataSource else {
            return
        }

        let input = LikeCityViewModel.Input(
            viewDidLoad: self.rx.viewWillAppear.asObservable(),
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


