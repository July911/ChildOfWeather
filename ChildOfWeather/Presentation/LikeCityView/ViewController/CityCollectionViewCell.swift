import UIKit

class CityCollectionViewCell: UICollectionViewCell {
    
    private let cityImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let cityNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption2)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let highTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let lowTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let temperatureStackView: UIStackView = {
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addViewsToStackView()
        self.addStackViewToView()
        self.configureLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(cellViewModel: CityCellViewModel) {
        self.cityNameLabel.text = cellViewModel.cityName
    }
    
    private func addViewsToStackView() {
        self.temperatureStackView.addArrangedSubview(highTemperatureLabel)
        self.temperatureStackView.addArrangedSubview(lowTemperatureLabel)
        
        self.entireStackView.addArrangedSubview(cityNameLabel)
        self.entireStackView.addArrangedSubview(cityImageView)
        self.entireStackView.addArrangedSubview(temperatureStackView)
    }
    
    private func addStackViewToView() {
        self.addSubview(entireStackView)
    }
    
    private func configureLayout() {
        let cellView = self.contentView
        
        let stackViewLayout: [NSLayoutConstraint] = [
            self.entireStackView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor),
            self.entireStackView.trailingAnchor.constraint(equalTo: cellView.trailingAnchor),
            self.entireStackView.topAnchor.constraint(equalTo: cellView.topAnchor),
            self.entireStackView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(stackViewLayout)
    }
}
