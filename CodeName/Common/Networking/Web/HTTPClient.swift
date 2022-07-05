struct HTTPClient
{
    enum Method: String
    {
        case get = "GET"
        case post = "POST"
    }
    
    enum RequestError: Error
    {
        case requestMalformed
        case httpError(raw: String)
        case responseDataEmpty
        case requestFailed
        case decodeFailed(raw: String)
    }
    
    private let session: URLSession
    private let authManager: AuthManager
    
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Formatter.iso8601)
        return decoder
    }()
    
    init(session: URLSession = URLSession.shared, authManager: AuthManager) {
        self.session = session
        self.authManager = authManager
    }
    
    func performRequest<RequestParams: Encodable, Response: Decodable>(request: HttpRequest<RequestParams>,
                                             completion: @escaping (_ result: Result<Response, RequestError>) -> Void) {
        guard let request = request.asURLRequest(authorizationValue: self.authorizationValue) else {
            completion(.failure(.requestMalformed))
            return
        }
        
        self.session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.requestFailed))
                return
            }

            guard let data = data else {
                completion(.failure(.responseDataEmpty))
                return
            }

            do {
                let decodedResponse = try self.jsonDecoder.decode(Response.self, from: data)
                
                if let httpUrlResponse = response as? HTTPURLResponse,
                   !(200...299).contains(httpUrlResponse.statusCode) {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    completion(.failure(.httpError(raw: json ?? "")))
        
                    return
                }
                
                completion(.success(decodedResponse))
            } catch {
                let json = String(data: data, encoding: String.Encoding.utf8)
                completion(.failure(.decodeFailed(raw: json ?? "")))
            }
        }.resume()

        self.session.finishTasksAndInvalidate()
    }
    
    func performRequest<RequestParams: Encodable>(request: HttpRequest<RequestParams>, completion: @escaping (_ result: Result<String, RequestError>) -> Void) {
        guard let request = request.asURLRequest(authorizationValue: self.authorizationValue) else {
            completion(.failure(.requestMalformed))
            return
        }
        
        self.session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.requestFailed))
                return
            }

            guard let data = data else {
                completion(.failure(.responseDataEmpty))
                return
            }

            if let httpUrlResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpUrlResponse.statusCode) {
                let json = String(data: data, encoding: String.Encoding.utf8)
                completion(.failure(.httpError(raw: json ?? "")))
                
                return
            }
            
            if let raw = String(data: data, encoding: String.Encoding.utf8) {
                completion(.success(raw))
                return
            }
            else {
                completion(.failure(.responseDataEmpty))
            }
        }.resume()

        self.session.finishTasksAndInvalidate()
    }
    
    func cleanupSession() {
        self.authManager.removeToken()
    }
}

private extension HTTPClient
{
    var authorizationValue: String? {
        guard let token = self.authManager.getToken() else { return nil }
        return "Token \(token)"
    }
}
