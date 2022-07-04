import Foundation

protocol APIRequest {
    
    associatedtype ResponseType: Decodable
    
    var method: HTTPMethod { get }
    var params: QueryParameters { get }
    var urlString: String { get }
    var httpBody: Data? { get }
    var httpHeader: [String: String] { get }
}

extension APIRequest {
                        
    var url: URL? {
        return URL(string: self.urlString)
    }
    
    var urlRequest: URLRequest? {
        var urlComponents = URLComponents(string: self.urlString)
        let urlQueries = self.params.queryParam.map { URLQueryItem(name: $0.key, value: $0.value) }
        urlComponents?.queryItems = urlQueries
        
        if let url = urlComponents?.url {
            var request = URLRequest(url: url)
            request.httpMethod = self.method.rawValue
            request.allHTTPHeaderFields = self.httpHeader
            
            return request
        }
        return nil
    }
}
