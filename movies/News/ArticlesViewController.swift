import UIKit

final class ArticlesViewController: UITableViewController {
    
    let articleService = ArticlesService()
    
    var activity: UIActivityIndicatorView = .init()
    var articles: [Article] = []
    
    // MARK: - UI and Life Cycle
    
    private lazy var table: UITableView = {
        let element = UITableView()
        element.translatesAutoresizingMaskIntoConstraints = false
        element.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        element.dataSource = self
        element.delegate = self
        return element
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        
        setView()
        setupConstraints()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activity)
        loadNews()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let article = articles[indexPath.row]
        var config = cell.defaultContentConfiguration()
        config.text = article.title
        config.secondaryText = article.description
        cell.contentConfiguration = config
        return cell
    }

    func loadNews() {
        activity.startAnimating()
        articleService.fetchArticles { [weak self] result in
            DispatchQueue.main.async {
                self?.activity.stopAnimating()
                switch result {
                case .success(let articles):
                    self?.articles = articles
                    self?.table.reloadData()
                case .failure(let error):
                    let title: String
                    if let networkError = error as? NetworkError {
                        switch networkError {
                        case .unknown:
                            title = "Неизвестная ошибка"
                        case .invalidMimeType, .invalidStatusCode, .client, .server, .emptyData, .invalidURL:
                            title = "Неверный контент"
                        }
                    } else {
                        title = error.localizedDescription
                    }
                    self?.showAlert(title: title)
                }
            }
        }
    }

    func showAlert(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    private func setView() {
        view.addSubview(table)
    }
}

// MARK: - Constraints

extension ArticlesViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            table.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}
