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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(cellViewModel: CityCellViewModel) {
        self.cityNameLabel.text = cellViewModel.cityName
        self.cityImageView.image = cellViewModel.image
    }
    
    private func configureLayout() {
        
    }
}
