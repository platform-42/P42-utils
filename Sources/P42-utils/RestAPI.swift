//
//  RestAPI.swift
//  shops24
//
//  Created by Diederick de Buck on 18/04/2023.
//

import Foundation

public enum ShopifyHeader: String {
    case access_token = "X-Shopify-Access-Token"
}

public enum HTTPHeader: String {
    case contentType = "Content-Type"
    case authorization = "Authorization"
    case accept = "Accept"
    case userAgent = "User-Agent"
    case cacheControl = "Cache-Control"
}

public enum RequestType: String {
    case get
    case put
    case post
    case delete
}

public enum RequestError: Error {
    case invalidURL
    case noData
    case httpError(Int)
}

public class RestAPI {
    
    /*
     *  getRequest:
     *      components -> URL with querystring parameters
     *      secret -> keychain stored access token
     *      meta -> helper object that keeps track of outstanding/completed IO's
     *      handler -> invoked on completion, delegates IO completion to meta object
     */
    @MainActor
    public static func getRequestShopify(
        components: URLComponents,
        secret: String?,
        meta: Meta,
        handler: @escaping (Data, Meta) -> Void
    ) {
        guard let url = components.url else {
            return
        }
        var request = URLRequest(url: url)
        if let secret = secret {
            request.addValue(secret, forHTTPHeaderField: ShopifyHeader.access_token.rawValue)
        }
        request.addValue("application/json", forHTTPHeaderField: HTTPHeader.contentType.rawValue)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            DispatchQueue.main.async {
                handler(data, meta)
            }
        }
        .resume()
    }
    
    @MainActor
    public static func getRequest(
        url: String,
        secret: String?,
        meta: Meta,
        handler: @escaping (Result<Data, Error>, Meta) -> Void
    ) {
        guard let url = URL(string: url) else {
            handler(.failure(RequestError.invalidURL), meta)
            return
        }
        var request = URLRequest(url: url)
        if let secret = secret {
            request.addValue(
                "Bearer \(secret)",
                forHTTPHeaderField: HTTPHeader.authorization.rawValue
            )
        }
        request.addValue(
            "application/json",
            forHTTPHeaderField: HTTPHeader.contentType.rawValue
        )
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    handler(.failure(error), meta)
                }
                return
            }
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                DispatchQueue.main.async {
                    handler(.failure(RequestError.httpError(httpResponse.statusCode)), meta)
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    handler(.failure(RequestError.noData), meta)
                }
                return
            }
            DispatchQueue.main.async {
                handler(.success(data), meta)
            }
        }
        .resume()
    }
    
    
    @MainActor
    public static func postRequest(
        url: String,
        secret: String?,
        meta: Meta,
        jsonBody: [String: Any],
        handler: @escaping (Result<Data, Error>, Meta) -> Void
    ) {
        guard let url = URL(string: url) else {
            handler(.failure(RequestError.invalidURL), meta)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = RequestType.post.rawValue
        if let secret = secret {
            request.addValue(
                "Bearer \(secret)",
                forHTTPHeaderField: HTTPHeader.authorization.rawValue
            )
        }
        request.addValue(
            "application/json",
            forHTTPHeaderField: HTTPHeader.contentType.rawValue
        )
        request.httpBody = try? JSONSerialization.data(withJSONObject: jsonBody)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    handler(.failure(error), meta)
                }
                return
            }
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                DispatchQueue.main.async {
                    handler(.failure(RequestError.httpError(httpResponse.statusCode)), meta)
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    handler(.failure(RequestError.noData), meta)
                }
                return
            }
            DispatchQueue.main.async {
                handler(.success(data), meta)
            }
        }.resume()
    }
    
}
