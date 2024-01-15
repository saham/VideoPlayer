import Foundation

extension String {
    var toDate:Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = constant.dateFormat
        return dateFormatter.date(from: self)
    }
}
