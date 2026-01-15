//
//  DateUtils.swift
//  AlineaStockNews
//
//  Created by Vinicius Reis on 1/14/26.
//

import Foundation

class DateUtils {
    static func formattedDate(date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let interval = now.timeIntervalSince(date)

        if interval < 60 {
            return "Just now"
        } else if interval < 3600 {
            let minutes = Int(interval / 60)
            return "\(minutes) min ago"
        } else if interval < 86400 {
            let hours = Int(interval / 3600)
            return "\(hours)h ago"
        } else if interval < 604800 { // 7 days
            let days = Int(interval / 86400)
            return days == 1 ? "1 day ago" : "\(days) days ago"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            return formatter.string(from: date)
        }
    }
}
