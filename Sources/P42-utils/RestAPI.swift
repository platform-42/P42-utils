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
    public static func getRequest(
        components: URLComponents,
        secret: String,
        meta: Meta,
        handler: @escaping (Data, Meta) -> Void
    ) {
        guard let url = components.url else {
            return
        }
        var request = URLRequest(url: url)
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
    public static func postRequest(
        url: String,
        secret: String,
        meta: Meta,
        jsonBody: [String: Any],
        handler: @escaping (Data, Meta) -> Void
    ) {
        guard let url = URL(string: url) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = RequestType.post.rawValue
        request.addValue("Bearer \(secret)", forHTTPHeaderField: HTTPHeader.authorization.rawValue)
        request.addValue("application/json", forHTTPHeaderField: HTTPHeader.contentType.rawValue)
        request.httpBody = try? JSONSerialization.data(withJSONObject: jsonBody)
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
        }.resume()
    }
    
}
