import Foundation

extension Array {
    @inlinable func mapLast(
        _ transform: (Element) throws -> Element
    ) rethrows -> [Element] {
        try enumerated()
            .map { index, element in
                if index == count - 1 {
                    return try transform(element)
                } else {
                    return element
                }
            }
    }
}
