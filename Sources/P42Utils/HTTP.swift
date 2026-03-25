//
//  HTTP.swift
//  P42Utils
//
//  Created by Diederick de Buck on 19/12/2024.
//

import Foundation


public enum HTTPHeader: String {
    case shopify_authorization = "X-Shopify-Access-Token"
    case contentType = "Content-Type"
    case authorization = "Authorization"
    case accept = "Accept"
    case userAgent = "User-Agent"
    case cacheControl = "Cache-Control"
    case apiKey = "X-API-Key"
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
    case unauthorized(String?)
}


// P42Utils
extension RequestError: LocalizedError {
    public var errorDetails: String? {
        switch self {
        case .unauthorized(let body): return "Unauthorized: \(body ?? "")"
        case .httpError(let code): return "HTTP \(code))"
        case .invalidURL: return "Invalid URL"
        case .noData: return "No data received"
        }
    }
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
    case apiKey
    case none
}
