import XCTest
@testable import SwiftCleaner

final class String_ExtensionsTests: XCTestCase {
    func test_escaped() {
        XCTAssertEqual(
            "/Users/jakob/Library/Mobile Documents/Foo.xcodeproj".escaped,
            "/Users/jakob/Library/Mobile\ Documents/Foo.xcodeproj"
        )
        XCTAssertEqual(
            "/Users/jakob/Library/Mobile\ Documents/Foo.xcodeproj".escaped,
            "/Users/jakob/Library/Mobile\ Documents/Foo.xcodeproj"
        )
        XCTAssertEqual(
            "/Users/jakob/Library/Mobile\ Documents/Foo Bar/Foo.xcodeproj".escaped,
            "/Users/jakob/Library/Mobile\ Documents/Foo\ Bar/Foo.xcodeproj"
        )
    }

    func test_unescaped() {
        XCTAssertEqual(
            "/Users/jakob/Library/Mobile\ Documents/Foo.xcodeproj".unescaped,
            "/Users/jakob/Library/Mobile Documents/Foo.xcodeproj"
        )
    }

    func test_quoted() {
        XCTAssertEqual(
            "/Users/jakob/Library/Mobile Documents/Foo.xcodeproj".quoted,
            "'/Users/jakob/Library/Mobile Documents/Foo.xcodeproj'"
        )
        XCTAssertEqual(
            "'/Users/jakob/Library/Mobile Documents/Foo.xcodeproj".quoted,
            "'/Users/jakob/Library/Mobile Documents/Foo.xcodeproj'"
        )
        XCTAssertEqual(
            "/Users/jakob/Library/Mobile Documents/Foo.xcodeproj'".quoted,
            "'/Users/jakob/Library/Mobile Documents/Foo.xcodeproj'"
        )
    }
}
