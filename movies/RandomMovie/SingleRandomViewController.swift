import UIKit

final class SingleRandomViewController: UIViewController {
    
    // MARK: - UI and Lyfe Cycle
    
    private lazy var mainStackView: UIStackView = {
        let element = UIStackView()
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var posterImage: UIImageView = {
        let element = UIImageView()
        element.image = UIImage(named: "poster2")
        element.contentMode = .scaleToFill
        
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var gradientImage: UIImageView = {
        let element = UIImageView()
        element.image = UIImage(named: "gradient")
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var titleMovie: UILabel = {
        let element = UILabel()
        element.font = .systemFont(ofSize: 42, weight: .bold)
        element.textColor = .white
        element.text = "Во всё тяжкое"
        element.textAlignment = .center
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var discriptionMovie: UILabel = {
        let element = UILabel()
        element.font = .systemFont(ofSize: 16)
        element.textColor = .black
        element.text = "Умирающий от рака профессор начинает жить на всю катушку. Комедийная драма с нарушающим правила Джонни Деппом"
        element.textAlignment = .left
        element.numberOfLines = 0
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .accentLight
        
        setView()
        setupConstraints()
    }
    private func setView() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(posterImage)
        view.addSubview(gradientImage)
        view.addSubview(titleMovie)
        view.addSubview(discriptionMovie)
    }
    
    // MARK: - Actions
    
}

// MARK: - Constraints

extension SingleRandomViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            posterImage.topAnchor.constraint(equalTo: mainStackView.topAnchor),
            posterImage.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            posterImage.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            posterImage.widthAnchor.constraint(equalTo: posterImage.heightAnchor, multiplier: 2.0 / 3.0),
            
            gradientImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            gradientImage.bottomAnchor.constraint(equalTo: posterImage.bottomAnchor),
            
            titleMovie.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleMovie.bottomAnchor.constraint(equalTo: gradientImage.bottomAnchor, constant: -50),
            
            discriptionMovie.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 16),
            discriptionMovie.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -16),
            discriptionMovie.topAnchor.constraint(equalTo: gradientImage.bottomAnchor, constant: 25)
        ])
    }
}

