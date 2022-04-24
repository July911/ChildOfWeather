import UIKit

final class SearchViewController: UIViewController {
    
    var viewModel: SearchViewModel?
    
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
}


    





