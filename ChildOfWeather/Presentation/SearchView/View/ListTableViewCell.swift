import UIKit

class ListTableViewCell: UITableViewCell {
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.text = "name"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let cityIdLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .caption1)
        label.text = "weather"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureCell(city: City) {
        self.nameLabel.text = city.name
        self.cityIdLabel.text = city.id.description
    }
    
    private func configureLayout() {
        self.contentView.addSubview(stackView)
        self.stackView.addArrangedSubview(nameLabel)
        self.stackView.addArrangedSubview(cityIdLabel)
        
        let stackViewLayout: [NSLayoutConstraint] = [
            stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ]
        NSLayoutConstraint.activate(stackViewLayout)
    }
}
