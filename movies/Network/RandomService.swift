import UIKit


class RandomService {
    
    private let client = RestApiClient()
    
    func fetchRandom(completion: @escaping (Result<Data, Error>) -> Void) {
        do {
            let request = try ArticlesEndpoint.articles.asRequest()
            client.performRequest(request) { result in
                switch result {
                case .success(let data):
                    let json = try! JSONSerialization.jsonObject(with: data) as! [String: Any]
                    let results = json["items"] as! [[String: Any]]
                    
                    var articles = [Article]()
                    
                    for result in results {
                        let title = result["title"] as! String
                        let description = result["description"] as! String
                        let imageURL = result["imageUrl"] as! String
                        let url = result["url"] as! String
                        
                        let article = Article(title: title, description: description, imageURL: URL(string: imageURL)!, url: URL(string: url)!)
                        articles.append(article)
                        
                    }
                    
                    DispatchQueue.main.async {
                        completion(.success(articles))
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
}
