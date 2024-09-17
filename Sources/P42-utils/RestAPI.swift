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
        request.addValue(secret, forHTTPHeaderField: ShopifyHeader.access_token.rawValue)
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
    
}
