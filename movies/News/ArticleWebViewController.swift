import UIKit
import WebKit

class ArticleWebViewController: UIViewController, WKNavigationDelegate {
    
    var url: URL?
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = .buttons
        return progressView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupWebView()
        setupConstraints()
        
        if let url = url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }
    
    private func setupNavigationBar() {
        let backButton = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .buttons
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupWebView() {
        view.addSubview(webView)
        view.addSubview(progressView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            progressView.progress = Float(webView.estimatedProgress)
            progressView.isHidden = webView.estimatedProgress == 1
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // Скрытие таб-бара при появлении контроллера
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    // Показ таб-бара при исчезновении контроллера
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
}
