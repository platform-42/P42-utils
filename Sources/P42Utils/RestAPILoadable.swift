//
//  RestAPILoadable.swift
//  P42Utils
//
//  Created by Diederick de Buck on 18/03/2026.
//

import Foundation


public protocol RestAPILoadable {
    func loadDataByGet(
        urlComponents: URLComponents,
        accessToken: String,
        handler: @escaping (Data) -> Void
    ) async
}


public extension RestAPILoadable {

    func loadDataByGet(
        urlComponents: URLComponents,
        accessToken: String,
        handler: @escaping (Data) -> Void
    ) async {
        guard let url = urlComponents.url else {
            fatalError("Invalid URL components")
        }
        do {
            let response = try await RestAPIAsync.getRequest(
                url: url.absoluteString,
                secret: accessToken,
                kind: .shopify
            )
            handler(response)
        } catch {
            print("Unknown error: \(error.localizedDescription)")
        }
    }
}
