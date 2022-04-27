import UIKit

class ListTableViewCell: UITableViewCell {
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let latLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let lonLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let locationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let entireStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
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
        self.latLabel.text = "위도: \(city.coord.lat.toInt.description)"
        self.lonLabel.text = "경도: \(city.coord.lon.toInt.description)"
        self.backgroundColor = .systemGray6
    }
    
    private func configureLayout() {
        self.locationStackView.addArrangedSubview(lonLabel)
        self.locationStackView.addArrangedSubview(latLabel)
        
        self.contentView.addSubview(entireStackView)
        self.entireStackView.addArrangedSubview(nameLabel)
        self.entireStackView.addArrangedSubview(locationStackView)
        
        let entireStackViewLayout: [NSLayoutConstraint] = [
            entireStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            entireStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            entireStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            entireStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ]
        NSLayoutConstraint.activate(entireStackViewLayout)
    }
}

private extension Double {
    
    var toInt: Int {
        Int(self)
    }
}
