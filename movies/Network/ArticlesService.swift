import UIKit


class ArticlesService {
    
    private let client = RestApiClient()
    
    func fetchArticles(completion: @escaping (Result<[Article], Error>) -> Void) {
        do {
            let request = try ArticlesEndpoint.articles.asRequest()
            client.performRequest(request) { result in
                switch result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let response = try decoder.decode(ArticlesResponse.self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(response.items))
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
    
    enum ArticlesEndpoint: URLRequestConvertible {
        case articles
        
        var path: String {
            switch self {
            case .articles:
                return "/api/v1/media_posts"
            }
        }
        
        var method: HTTPMethod {
            switch self {
            case .articles:
                return .get
            }
        }
    }
}
