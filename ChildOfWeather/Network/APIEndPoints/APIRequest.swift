import Foundation

protocol APIRequest {
    
    associatedtype ResponseType: Decodable
    
    var method: HTTPMethod { get }
    var params: QueryParameters { get }
    var URLString: String { get }
    var HTTPBody: Data? { get }
    var HTTPHeader: [String: String] { get }
}

extension APIRequest {
                        
    var url: URL? {
        return URL(string: self.URLString)
    }
    
    var urlRequest: URLRequest? {
        var urlComponents = URLComponents(string: self.URLString)
        let urlQueries = self.params.queryParam.map { URLQueryItem(name: $0.key, value: $0.value) }
        urlComponents?.queryItems = urlQueries
        
        if let url = urlComponents?.url {
            var request = URLRequest(url: url)
            request.httpMethod = self.method.rawValue
            request.allHTTPHeaderFields = self.HTTPHeader
            
            return request
        }
        return nil
    }
}
