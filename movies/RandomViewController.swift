import UIKit

final class RandomViewController: UIViewController {
    
    // MARK: - UI and Lyfe Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        
        setView()
        setupConstraints()
    }
    private func setView() {
        // Здесь добавляются новые элементы для отображения на экране
    }
    
    // MARK: - Actions
    
}

// MARK: - Constraints

extension RandomViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Здесь прописываются констрейнты для элементов
        ])
    }
}

