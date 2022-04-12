import UIKit

final class SearchViewController: UIViewController {
    
    var viewModel: SearchViewModel?
    
    private let listTableView: UITableView = {
        let tableview = UITableView(frame: .zero)
        tableview.register(ListTableViewCell.self, forCellReuseIdentifier: String(describing: ListTableViewCell.self))
        tableview.estimatedRowHeight = 70
        tableview.rowHeight = 60
        tableview.translatesAutoresizingMaskIntoConstraints = false
        
        return tableview
    }()
    
    private var isfiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        
        return isActive && isSearchBarHasText
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureLayout()
        self.configureTableView()
        self.configureSearchController()
        self.configureViewModelDelegate()
        self.viewModel?.configureLoactionLists()
    }
    
    private func configureTableView() {
        self.listTableView.dataSource = self
        self.listTableView.delegate = self
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
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
        self.navigationController?.navigationBar.backgroundColor = .white
    }
    
    private func configureViewModelDelegate() {
        self.viewModel?.delegate = self
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.filterdResults?.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ListTableViewCell.self), for: indexPath) as? ListTableViewCell
        else {
            return UITableViewCell()
        }
        
        let cities = self.viewModel?.filterdResults
        cell.configureCell(city: cities?[indexPath.row] ?? City.EMPTY)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let city = self.viewModel?.filterdResults?[indexPath.row] ?? City.EMPTY
        self.viewModel?.coordinator.occuredViewEvent(with: .presentDetailShowUIViewController(cityName: city))
    }
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text
        else {
            return
        }
        
        if isfiltering {
            self.viewModel?.configureLoactionLists(text)
        } else {
            self.viewModel?.configureLoactionLists()
        }
    }
}
    
extension SearchViewController: SearchViewModelDelegate {
    
    func didSearchData() {
        self.listTableView.reloadData()
    }
}




