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
        accessToken: String?,
        kind: AuthKind,
        handler: @escaping (Data) -> Void,
        onError: ((Error) -> Void)?
    ) async
}


public extension RestAPILoadable {

    /*
     *  loadDataByGet had 2 escaping closures
     *  because the onError closure is an optional one, it is implicit escaping
     *  compiler prohibits to define it that way. why not emitting a warning is beyond me
     */
    func loadDataByGet(
        urlComponents: URLComponents,
        accessToken: String?,
        kind: AuthKind,
        handler: @escaping (Data) -> Void,
        onError: ((Error) -> Void)? = nil
    ) async {
        guard let url = urlComponents.url else {
            fatalError("Invalid URL components")
        }

        do {
            let response = try await RestAPIAsync.getRequest(
                url: url.absoluteString,
                secret: accessToken,
                kind: kind
            )

            handler(response)
        } catch {
            print("Unknown error: \(error.localizedDescription)")
            onError?(error)
        }
    }
}

