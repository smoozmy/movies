import UIKit

final class SingleRandomViewController: UIViewController {
    
    private let randomService = RandomService()
    
    // MARK: - UI and Life Cycle
    
    private lazy var mainStackView: UIStackView = {
        let element = UIStackView()
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var posterImage: UIImageView = {
        let element = UIImageView()
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
        element.textAlignment = .center
        element.numberOfLines = 0
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var descriptionMovie: UILabel = {
        let element = UILabel()
        element.font = .systemFont(ofSize: 16)
        element.textColor = .black
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
        fetchRandomFilm()
    }
    
    private func setView() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(posterImage)
        view.addSubview(gradientImage)
        view.addSubview(titleMovie)
        view.addSubview(descriptionMovie)
    }
    
    private func fetchRandomFilm() {
        randomService.fetchRandomFilm { [weak self] result in
            switch result {
            case .success(let film):
                self?.updateUI(with: film)
            case .failure(let error):
                print("Error fetching film: \(error)")
            }
        }
    }
    
    private func updateUI(with film: Film) {
        titleMovie.text = film.nameRu ?? film.nameOriginal
        descriptionMovie.text = film.description
        if let url = URL(string: film.posterUrl) {
            loadImage(from: url)
        }
    }
    
    private func loadImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self.posterImage.image = UIImage(data: data)
            }
        }
        task.resume()
    }
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
            titleMovie.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleMovie.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleMovie.bottomAnchor.constraint(equalTo: gradientImage.bottomAnchor, constant: -50),
            
            descriptionMovie.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 16),
            descriptionMovie.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -16),
            descriptionMovie.topAnchor.constraint(equalTo: gradientImage.bottomAnchor, constant: 25)
        ])
    }
}
