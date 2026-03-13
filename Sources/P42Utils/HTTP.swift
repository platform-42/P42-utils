//
//  File.swift
//  
//
//  Created by Diederick de Buck on 19/12/2024.
//

import Foundation


public enum HTTPHeader: String {
    case shopify_authorization = "Shopify-Authorization"
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

public func isExpiredHTTPError(
    _ error: Error
) -> Bool {
    if let httpError = error as? RequestError {
        switch httpError {
        case .httpError(401), .httpError(403):
            return true
        default:
            return false
        }
    }
    return false
}


public enum AuthKind {
    case bearer
    case shopify
}
