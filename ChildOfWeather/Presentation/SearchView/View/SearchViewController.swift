import UIKit
import RxSwift
import RxCocoa

final class SearchViewController: UIViewController {
    
    var viewModel: SearchViewModel?
    private let bag = DisposeBag()
    
    private let listTableView: UITableView = {
        let tableview = UITableView(frame: .zero)
        tableview.register(
            ListTableViewCell.self,
            forCellReuseIdentifier: String(describing: ListTableViewCell.self)
        )
        tableview.estimatedRowHeight = 70
        tableview.rowHeight = 60
        tableview.translatesAutoresizingMaskIntoConstraints = false
        
        return tableview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureLayout()
        self.configureSearchController()
        self.bindViewModel()
    }
    
    private func configureLayout() {
        self.view.addSubview(listTableView)
        
        let tableViewLayout: [NSLayoutConstraint] = [
            self.listTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.listTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.listTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.listTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(tableViewLayout)
    }
    
    private func configureSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "please search the city that you want to get weather infomation"
        searchController.searchBar.tintColor = .white
        searchController.isActive = true
        self.navigationItem.searchController = searchController
        self.navigationController?.navigationBar.backgroundColor = .white
    }
    
    private func bindViewModel() {
        
        guard let text = self.navigationItem.searchController?.searchBar.rx.text.asObservable()
        else {
            return
        }
        
        self.navigationItem.searchController?.searchBar.rx.text
            .distinctUntilChanged()
            .subscribe(onNext: { event in
                self.listTableView.reloadData()
                print("리로드")
            }).disposed(by: self.bag)
        
        let input = SearchViewModel.Input(
            viewWillAppear: (self.rx.methodInvoked(#selector(UIViewController.viewWillAppear(_:))).map { _ in }),
            didSelectedCell: self.listTableView.rx.modelSelected(City.self).asObservable(),
            searchBarText: text
        )
        
        let output = self.viewModel?.transform(input: input)
        
        output?.initialCities.asDriver(onErrorJustReturn: [])
            .drive(self.listTableView.rx.items(
                cellIdentifier: String(describing: ListTableViewCell.self),
                cellType: ListTableViewCell.self)
            ) { index, item , cell in
                cell.configureCell(city: item)
            }.disposed(by: self.bag)
    }
}


    





