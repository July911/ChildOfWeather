import UIKit

class SearchViewController: UIViewController {
    
    var viewModel: SearchViewModel?
    weak var delegate: SearchViewControllerDelegate?
    
    private let listTableView: UITableView = {
        let tableview = UITableView(frame: .zero)
        tableview.register(ListTableViewCell.self, forCellReuseIdentifier: String(describing: ListTableViewCell.self))
        tableview.translatesAutoresizingMaskIntoConstraints = false
        
        return tableview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureLayout()
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
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel?.listUp().count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: listTableView.self), for: indexPath) as? ListTableViewCell
        else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = self.viewModel?.listUp().first!
        // TODO: indexPath 로 데이터 받아오기 
        delegate?.SearchViewController(self, didSelectCell: city!)
    }
}




