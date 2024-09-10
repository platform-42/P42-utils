//
//  Utils.swift
//  shops24 Watch App
//
//  Created by Diederick de Buck on 23/04/2023.
//

import Foundation
import SwiftUI


public class Utils {
    
    public static func iosVersion() -> String {
        let os = ProcessInfo.processInfo.operatingSystemVersion
        return "\(os.majorVersion).\(os.minorVersion).\(os.patchVersion)"
    }
    
    public static func showBadge(_ syncState: Bool) -> String? {
        return syncState ? "s" : nil
    }

    
    public static func formatDate(from isoDateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: isoDateString) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            return dateFormatter.string(from: date)
        } else {
            return "Invalid Date"
        }
    }
    
    public  static func autoscaleCurrency(_ numberString: String, currencyCode: String = "EUR") -> String {
        if let doubleValue = Double(numberString) {
            return Utils.autoscale(doubleValue, currencyCode: currencyCode)
        }
        return Utils.autoscale(0, currencyCode: currencyCode)
    }
    
    public static func autoscale(_ number: Double, currencyCode: String = "EUR") -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencyCode = currencyCode
        numberFormatter.maximumFractionDigits = 1
        
        var scaledNumber = number
        var suffix = ""
        
        switch abs(number) {
        case 1_000_000_000...:
            scaledNumber = number / 1_000_000_000
            suffix = "B"
        case 1_000_000...:
            scaledNumber = number / 1_000_000
            suffix = "M"
        case 1_000...:
            scaledNumber = number / 1_000
            suffix = "K"
        default:
            suffix = ""
        }
        
        if let formattedNumber = numberFormatter.string(from: NSNumber(value: scaledNumber)) {
            return formattedNumber + suffix
        }
        
        return "\(number)"
    }

}
