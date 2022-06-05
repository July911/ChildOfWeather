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
        stackView.distribution = .fillEqually
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(cellViewModel: CityCellViewModel) {
        self.cityNameLabel.text = cellViewModel.cityName
        self.lowTemperatureLabel.text = cellViewModel.lowTemperature.description
        self.highTemperatureLabel.text = cellViewModel.highTemperature.description
        self.cityImageView.image = cellViewModel.image.value.resized(
            for: CGSize(
                width: self.contentView.frame.width,
                height: self.contentView.frame.height * 0.5)
        )
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
        
        let temperatureStackViewLayout: [NSLayoutConstraint] = [
            self.temperatureStackView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor),
            self.temperatureStackView.trailingAnchor.constraint(equalTo: cellView.trailingAnchor)
        ]
        
        let cityNameLabelLayout: [NSLayoutConstraint] = [
            self.cityNameLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor),
            self.cityNameLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor)
        ]
        
        let imageViewLayout: [NSLayoutConstraint] = [
            self.cityImageView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor),
            self.cityImageView.trailingAnchor.constraint(equalTo: cellView.trailingAnchor),
            self.cityImageView.topAnchor.constraint(equalTo: self.cityNameLabel.topAnchor),
            self.cityImageView.bottomAnchor.constraint(equalTo: self.temperatureStackView.bottomAnchor)
        ]
        
        let stackViewLayout: [NSLayoutConstraint] = [
            self.entireStackView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor),
            self.entireStackView.trailingAnchor.constraint(equalTo: cellView.trailingAnchor),
            self.entireStackView.topAnchor.constraint(equalTo: cellView.topAnchor),
            self.entireStackView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(temperatureStackViewLayout)
        NSLayoutConstraint.activate(cityNameLabelLayout)
        NSLayoutConstraint.activate(imageViewLayout)
        NSLayoutConstraint.activate(stackViewLayout)
    }
}
