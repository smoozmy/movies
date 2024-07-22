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
        element.backgroundColor = .black
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
        element.text = "..."
        element.font = .systemFont(ofSize: 42, weight: .bold)
        element.textColor = .white
        element.textAlignment = .center
        element.numberOfLines = 0
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var movieInfoStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.alignment = .center
        element.distribution = .fill
        element.spacing = 10
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var rating: UILabel = {
        let element = UILabel()
        element.text = ".."
        element.font = .systemFont(ofSize: 14, weight: .bold)
        element.textColor = .systemGreen
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var originalName: UILabel = {
        let element = UILabel()
        element.text = "..."
        element.font = .systemFont(ofSize: 14)
        element.textColor = .white
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var moreInfo: UILabel = {
        let element = UILabel()
        element.text = "..."
        element.font = .systemFont(ofSize: 13)
        element.textAlignment = .center
        element.textColor = .lightGray
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var country: UILabel = {
        let element = UILabel()
        element.font = .systemFont(ofSize: 13)
        element.textAlignment = .center
        element.textColor = .lightGray
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
        view.addSubview(movieInfoStackView)
        movieInfoStackView.addArrangedSubview(rating)
        movieInfoStackView.addArrangedSubview(originalName)
        view.addSubview(moreInfo)
        view.addSubview(country)
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
        rating.text = String(format: "%.1f", film.ratingKinopoisk ?? 0.0)
        moreInfo.text = "\(film.year ?? 0), \(film.genres?.map { $0.genre }.joined(separator: ", ") ?? "")"
        country.text = film.countries?.map { $0.country }.joined(separator: ", ")
        originalName.text = film.nameOriginal
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
            
            movieInfoStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            movieInfoStackView.bottomAnchor.constraint(equalTo: moreInfo.topAnchor, constant: -4),
            
            moreInfo.bottomAnchor.constraint(equalTo: country.topAnchor, constant: -4),
            moreInfo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            country.bottomAnchor.constraint(equalTo: gradientImage.bottomAnchor, constant: -20),
            country.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            titleMovie.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleMovie.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleMovie.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleMovie.bottomAnchor.constraint(equalTo: movieInfoStackView.topAnchor, constant: -8),
            
            descriptionMovie.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 16),
            descriptionMovie.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -16),
            descriptionMovie.topAnchor.constraint(equalTo: gradientImage.bottomAnchor, constant: 25)
        ])
    }
}
