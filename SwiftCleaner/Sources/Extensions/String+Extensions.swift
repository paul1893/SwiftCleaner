import Foundation

extension String {
    var escaped: String {
        let regex = try! NSRegularExpression(pattern: "(?<!\\\\) ", options: [])
        let range = NSRange(location: 0, length: self.utf16.count)
        let result = regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "\\\\ ")
        return result
    }

    var unescaped: String {
        self.replacingOccurrences(of: "\\", with: "")
    }

    var quoted: String {
        var result = self
        if self.hasPrefix("'") == false {
            result = "'" + result
        }
        if self.hasSuffix("'") == false {
            result = result + "'"
        }
        return result
    }
}
