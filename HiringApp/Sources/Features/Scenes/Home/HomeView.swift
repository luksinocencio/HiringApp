import UIKit

class HomeView: UIView {
    // MARK: - Property(ies).
    
    let labelHome: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "home"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private function(s).
    
    private func setupUI() {
        addSubview(labelHome)
        
        NSLayoutConstraint.activate([
            labelHome.centerXAnchor.constraint(equalTo: centerXAnchor),
            labelHome.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
