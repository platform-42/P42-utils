//
//  File.swift
//  
//
//  Created by Diederick de Buck on 19/12/2024.
//

import Foundation

public class RestAPIAsync {
    
    static func authHeader(
        secret: String,
        kind: AuthKind
    ) -> (field: String, value: String) {
        switch kind {
        case .bearer:
            return (HTTPHeader.authorization.rawValue, "Bearer \(secret)")
        case .shopify:
            return (HTTPHeader.shopify_authorization.rawValue, secret)
        }
    }
    
    public static func getRequest(
        url: String,
        secret: String?,
        kind: AuthKind = .bearer
    ) async throws -> Data {
        guard let url = URL(string: url) else {
            throw RequestError.invalidURL
        }
        var request = URLRequest(url: url)
        if let secret = secret {
            let header = authHeader(secret: secret, kind: kind)
            request.addValue(header.value, forHTTPHeaderField: header.field)
        }
        request.addValue("application/json",forHTTPHeaderField: HTTPHeader.contentType.rawValue)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw RequestError.noData
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw RequestError.httpError(httpResponse.statusCode)
        }
        return data
    }

    
    /*
     *  2026-03-11 DDB:
     *      new postRequest with dynamic header and dynamic body
     */
    public static func postRequest(
        url: String,
        secret: String?,
        kind: AuthKind = .bearer,
        headers: [String: String] = [:],
        body: Data? = nil
    ) async throws -> Data {

        guard let url = URL(string: url) else {
            throw RequestError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = RequestType.post.rawValue

        if let secret = secret {
            let header = authHeader(secret: secret, kind: kind)
            request.setValue(header.value, forHTTPHeaderField: header.field)
        }

        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        request.httpBody = body

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw RequestError.noData
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw RequestError.httpError(httpResponse.statusCode)
        }

        return data
    }
    
    
    /*
     *  2026-03-11 DDB:
     *      legacy postRequest with static header and fixed body, made for transparency
     */
    public static func postRequest(
        url: String,
        secret: String?,
        kind: AuthKind = .bearer,
        jsonBody: [String: Any]
    ) async throws -> Data {

        let body = try JSONSerialization.data(withJSONObject: jsonBody)

        return try await postRequest(
            url: url,
            secret: secret,
            kind: kind,
            headers: [
                HTTPHeader.contentType.rawValue: "application/json"
            ],
            body: body
        )
    }
    
}

