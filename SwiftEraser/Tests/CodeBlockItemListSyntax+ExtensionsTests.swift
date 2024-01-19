import XCTest
import SwiftSyntax
import SwiftParser
@testable import SwiftEraser

final class CodeBlockItemListSyntaxTests: XCTestCase {
    func test_grouping_byConformingTo() {
        // GIVEN
        let source = """
        import Foundation

        extension Bar: Decodable {
            enum CodingKeys: String, CodingKey {
                case good
                case bad
            }
        }

        struct Bar {
            let good: Int
            let bad: [String]
        }

        extension Foo: Decodable {
            enum CodingKeys: String, CodingKey {
                case car
                case home
            }
        }
        """
        let sourceFile: SourceFileSyntax = Parser.parse(source: source)

        // WHEN
        let group = sourceFile.statements.grouping(byConformingTo: "CodingKey")

        // THEN
        XCTAssertEqual(
            group.keys.sorted(),
            ["Bar", "Foo"]
        )
    }
}
