//
//  File.swift
//  
//
//  Created by Diederick de Buck on 19/12/2024.
//

import Foundation

public class RestAPIAsync {
    
    public static func getRequest(
        url: String,
        secret: String?
    ) async throws -> Data {
        guard let url = URL(string: url) else {
            throw RequestError.invalidURL
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
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw RequestError.noData
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw RequestError.httpError(httpResponse.statusCode)
        }
        return data
    }

    public static func postRequest(
        url: String,
        secret: String?,
        jsonBody: [String: Any]
    ) async throws -> Data {
        guard let url = URL(string: url) else {
            throw RequestError.invalidURL
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
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw RequestError.noData
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw RequestError.httpError(httpResponse.statusCode)
        }
        return data
    }
    
}

