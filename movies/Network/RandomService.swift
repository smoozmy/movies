import UIKit

class RandomService {
    
    private let client = RestApiClient()
    
    func fetchRandomFilm(completion: @escaping (Result<Film, Error>) -> Void) {
        loadRandomFilm(completion: completion)
    }
    
    private func loadRandomFilm(completion: @escaping (Result<Film, Error>) -> Void) {
        do {
            let request = try RandomFilmEndpoint.randomFilm.asRequest()
            client.performRequest(request) { [weak self] result in
                switch result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    do {
                        let film = try decoder.decode(Film.self, from: data)
                        if let shortDescription = film.shortDescription, !shortDescription.isEmpty {
                            DispatchQueue.main.async {
                                completion(.success(film))
                            }
                        } else {
                            self?.loadRandomFilm(completion: completion)
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    enum RandomFilmEndpoint: URLRequestConvertible {
        case randomFilm
        
        var path: String {
            switch self {
            case .randomFilm:
                return "/api/v2.2/films/\(Int.random(in: 300...4000))"
            }
        }
        
        var method: HTTPMethod {
            switch self {
            case .randomFilm:
                return .get
            }
        }
    }
}
