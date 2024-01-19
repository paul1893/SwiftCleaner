import Foundation

extension Collection where Self.Element : Equatable {
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    func notContains<C>(_ other: C) -> Bool where C: Collection, C: Equatable, Self.Element == C.Element {
        other.contains(self) == false
    }
}
