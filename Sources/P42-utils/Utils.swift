//
//  Utils.swift
//  shops24 Watch App
//
//  Created by Diederick de Buck on 23/04/2023.
//

import Foundation
import SwiftUI
import P42_extensions

/*
 *  state model and colors
 */
public enum StateIndicator: String {
    case up = "arrowtriangle.up.fill"
    case down = "arrowtriangle.down.fill"
    case neutral = "arrowtriangle.right.fill"
    case none
}

public enum StateLogic: String {
    case up
    case down
    case neutral
    case none
}

public enum StateColor: Int {
    case up = 0x008E00
    case down = 0xFF2500
    case neutral = 0xFDC209
    case none
}


public class Utils {
    
    
    public static func stateFieldImage(_ stateLogic: StateLogic) -> String {
        switch (stateLogic) {
        case .up: return StateIndicator.up.rawValue
        case .down: return StateIndicator.down.rawValue
        case .neutral: return StateIndicator.neutral.rawValue
        case .none: return StateIndicator.neutral.rawValue
        }
    }
    
    @available(macOS 10.15, *)
    public static func stateFieldColor(_ stateLogic: StateLogic) -> Color {
        switch (stateLogic) {
        case .up: return Color(hex: StateColor.up.rawValue)
        case .down: return Color(hex: StateColor.down.rawValue)
        case .neutral: return Color(hex: StateColor.neutral.rawValue)
        case .none: return Color.clear
        }
    }
    
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
    
    public static func autoscaleCurrency(_ numberString: String, currencyCode: String = "EUR") -> String {
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
    
    public static func delayIndicator(
        lastUpdate: Date,
        boundaryMinutes: Int = 1
    ) -> String? {
        let now: Date = Date()
        let boundarySeconds: Int = boundaryMinutes * 60
        let deltaSeconds: Int = Int(now.timeIntervalSince(lastUpdate))
        
        guard deltaSeconds >= boundarySeconds else {
            return nil
        }
        
        let roundedMinutes = (deltaSeconds / boundarySeconds) * boundaryMinutes
        
        if (roundedMinutes < 60) {
            return "\(roundedMinutes)m ago"
        }
        if (roundedMinutes < 24 * 60) {
            return "\(roundedMinutes/60)h ago"
        }
        return "\(roundedMinutes/(24*60))d ago"
    }

}
