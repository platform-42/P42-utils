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
        components: URLComponents,
        secret: String?,
        meta: Meta,
        handler: @escaping (Data, Meta) -> Void
    ) {
        guard let url = URL(string: url) else {
            let urlError = NSError(domain: "P42.postRequest", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            handler(.failure((urlError, meta)))
            return
        }
        var request = URLRequest(url: url)
        if let secret = secret {
            request.addValue("Bearer \(secret)", forHTTPHeaderField: HTTPHeader.authorization.rawValue)
        }
        request.addValue("application/json", forHTTPHeaderField: HTTPHeader.contentType.rawValue)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                handler(.failure(error, meta))
            }
            guard let data = data else {
                let noDataError = NSError(domain: "P42.postRequest", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                DispatchQueue.main.async {
                    handler(.failure((noDataError, meta)))
                }
                return
            }
            DispatchQueue.main.async {
                handler(data, meta)
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
        handler: @escaping (Result<(Data, Meta), (Error, Meta)>) -> Void
    ) {
        guard let url = URL(string: url) else {
            let urlError = NSError(domain: "P42.postRequest", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            handler(.failure((urlError, meta)))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = RequestType.post.rawValue
        if let secret = secret {
            request.addValue("Bearer \(secret)", forHTTPHeaderField: HTTPHeader.authorization.rawValue)
        }
        request.addValue("application/json", forHTTPHeaderField: HTTPHeader.contentType.rawValue)
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: jsonBody)
        } catch {
            DispatchQueue.main.async {
                handler(.failure((error, meta)))
            }
            return
        }
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                handler(.failure(error, meta))
            }
            guard let data = data else {
                let noDataError = NSError(domain: "P42.postRequest", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                DispatchQueue.main.async {
                    handler(.failure((noDataError, meta)))
                }
                return
            }
            DispatchQueue.main.async {
                handler(.success(data, meta))
            }
        }.resume()
    }
    
}
