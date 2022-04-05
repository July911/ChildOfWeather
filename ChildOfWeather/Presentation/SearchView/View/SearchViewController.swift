import UIKit

class SearchViewController: UIViewController {
    
    var viewModel: SearchViewModel?
    
    private let listTableView: UITableView = {
        let tableview = UITableView(frame: .zero)
        tableview.register(ListTableViewCell.self, forCellReuseIdentifier: String(describing: ListTableViewCell.self))
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
        self.navigationItem.searchController = searchController
        self.navigationController?.navigationBar.backgroundColor = .gray
    }
    
    private func configureViewModelDelegate() {
        self.viewModel?.delegate = self
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isfiltering {
            return self.viewModel?.filterdResults?.count ?? .zero
        } else {
            return self.viewModel?.listUp().count ?? .zero
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ListTableViewCell.self), for: indexPath) as? ListTableViewCell
        else {
            return UITableViewCell()
        }
        
        if self.isfiltering {
            let cities = self.viewModel?.filterdResults
            cell.configureCell(city: cities?[indexPath.row] ?? City.EMPTY)
        } else {
            let cities = self.viewModel?.listUp()
            cell.configureCell(city: cities?[indexPath.row] ?? City.EMPTY)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = self.viewModel?.listUp().first
        // TODO: indexPath 로 데이터 받아오기 
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text
        else {
            return
        }
    }
}
    
extension SearchViewController: SearchViewModelDelegate {
    
}




