import XCTest
@testable import SwiftEraser

final class StringExtensionsTests: XCTestCase {
    func test_getFunctionName(){
        XCTAssertEqual(
            "localized(table: NewAdLocalizeTable, _ args: CVarArg...) -> String".getFunctionName(),
            "localized"
        )
    }

    func test_getParameters(){
        XCTAssertEqual(
            "localized(table:_:)".getParameters(),
            ["table", "_"]
        )
    }
}
