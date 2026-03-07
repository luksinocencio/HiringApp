import UIKit

class SplashView: UIView {
    // MARK: - Propert(ies).
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .label
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        return activityIndicator
    }()
    
    let loadingText: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.textColor = .label
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 20
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
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
        hStack.addArrangedSubview(activityIndicator)
        hStack.addArrangedSubview(loadingText)
        setupConstraints()
    }
    
    private func setupConstraints() {
        addSubview(hStack)
        
        NSLayoutConstraint.activate([
            hStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            hStack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
