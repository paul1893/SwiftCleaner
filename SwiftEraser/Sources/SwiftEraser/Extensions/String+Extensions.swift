import Foundation

extension String {
    func getFunctionName() -> String? {
        let signature = self
        let pattern = "^(\\w+)\\("
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }
        if let match = regex.firstMatch(
            in: signature,
            options: [],
            range: NSRange(location: 0, length: signature.utf16.count)
        ), let range = Range(match.range(at: 1), in: signature) {
            let functionName = String(signature[range])
            return functionName
        } else {
            return nil
        }
    }
    func getParameters() -> [String] {
        let signature = self
        let pattern = "\\b([a-zA-Z0-9_]+):"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return []
        }
        let matches = regex.matches(
            in: signature,
            options: [],
            range: NSRange(location: 0, length: signature.utf16.count)
        )
        let parameters = matches.compactMap { result -> String? in
            guard let range = Range(result.range(at: 1), in: signature) else { return nil }
            return String(signature[range])
        }
        return parameters
    }
}
