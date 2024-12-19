//
//  File.swift
//  
//
//  Created by Diederick de Buck on 19/12/2024.
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
    case unauthorized
}
