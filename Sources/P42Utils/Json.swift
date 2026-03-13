

//
//  Json.swift
//  shops24
//
//  Created by Diederick de Buck on 18/12/2022.
//

import Foundation

public class Json {
    
    public static func toJsonString<T: Codable>(request: T) -> String? {
        do {
            let jsonData = try JSONEncoder().encode(request)
            return String(data: jsonData, encoding: .utf8)!
        } catch {
            return nil
        }
    }
    
    public static func toJsonData<T: Codable>(request: T) -> Data? {
        do {
            return try JSONEncoder().encode(request)
        } catch {
            return nil
        }
    }
    
    public static func fromJsonData<T: Codable>(_ kind: T.Type, from response: Data) -> T? {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(kind.self, from: response)
        }
        catch {
            return nil
        }
    }
}
