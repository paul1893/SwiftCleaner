import XCTest
import SwiftSyntax
import SwiftParser
@testable import SwiftEraser

final class SourceFileSyntaxExtensionsTests: XCTestCase {
    func test_findNearestNode_when_actor() {
        // GIVEN
        let source = """
         actor MyActor {
            var a = "Hello World!"
         }
        """
        let sourceFile: SourceFileSyntax = Parser.parse(source: source)
        let sourceLocationConverter = SourceLocationConverter(
            fileName: "",
            tree: sourceFile
        )
        
        // WHEN
        let match = sourceFile.findNearestEnclosingNode(
            for: sourceLocationConverter.position(
                ofLine: 2,
                column: 16
            )
        )

        // THEN
        XCTAssertNotNil(match.node?.as(VariableDeclSyntax.self))
        XCTAssertNotNil(match.parent?.as(ActorDeclSyntax.self))
    }

    func test_findNearestNode_when_class() {
        // GIVEN
        let source = """
         final class MyClass {
            var a = "Hello World!"
         }
        """
        let sourceFile: SourceFileSyntax = Parser.parse(source: source)
        let sourceLocationConverter = SourceLocationConverter(
            fileName: "",
            tree: sourceFile
        )

        // WHEN
        let match = sourceFile.findNearestEnclosingNode(
            for: sourceLocationConverter.position(
                ofLine: 2,
                column: 16
            )
        )

        // THEN
        XCTAssertNotNil(match.node?.as(VariableDeclSyntax.self))
        XCTAssertNotNil(match.parent?.as(ClassDeclSyntax.self))
    }

    func test_findNearestNode_when_struct() {
        // GIVEN
        let source = """
         struct MyStruct {
            var a = "Hello World!"
         }
        """
        let sourceFile: SourceFileSyntax = Parser.parse(source: source)
        let sourceLocationConverter = SourceLocationConverter(
            fileName: "",
            tree: sourceFile
        )

        // WHEN
        let match = sourceFile.findNearestEnclosingNode(
            for: sourceLocationConverter.position(
                ofLine: 2,
                column: 16
            )
        )

        // THEN
        XCTAssertNotNil(match.node?.as(VariableDeclSyntax.self))
        XCTAssertNotNil(match.parent?.as(StructDeclSyntax.self))
    }

    func test_findNearestNode_when_enum() {
        // GIVEN
        let source = """
         enum MyEnum {
            var a = "Hello World!"
         }
        """
        let sourceFile: SourceFileSyntax = Parser.parse(source: source)
        let sourceLocationConverter = SourceLocationConverter(
            fileName: "",
            tree: sourceFile
        )

        // WHEN
        let match = sourceFile.findNearestEnclosingNode(
            for: sourceLocationConverter.position(
                ofLine: 2,
                column: 16
            )
        )

        // THEN
        XCTAssertNotNil(match.node?.as(VariableDeclSyntax.self))
        XCTAssertNotNil(match.parent?.as(EnumDeclSyntax.self))
    }

    func test_findNearestNode_when_protocol() {
        // GIVEN
        let source = """
         protocol MyProtocol {
            func foo()
         }
        """
        let sourceFile: SourceFileSyntax = Parser.parse(source: source)
        let sourceLocationConverter = SourceLocationConverter(
            fileName: "",
            tree: sourceFile
        )

        // WHEN
        let match = sourceFile.findNearestEnclosingNode(
            for: sourceLocationConverter.position(
                ofLine: 2,
                column: 8
            )
        )

        // THEN
        XCTAssertNotNil(match.node?.as(FunctionDeclSyntax.self))
        XCTAssertNotNil(match.parent?.as(ProtocolDeclSyntax.self))
    }
    
    func test_findNearestNode_when_extension() {
        // GIVEN
        let source = """
         extension MyClass {
            var a = "Hello World!"
         }
        """
        let sourceFile: SourceFileSyntax = Parser.parse(source: source)
        let sourceLocationConverter = SourceLocationConverter(
            fileName: "",
            tree: sourceFile
        )

        // WHEN
        let match = sourceFile.findNearestEnclosingNode(
            for: sourceLocationConverter.position(
                ofLine: 2,
                column: 16
            )
        )

        // THEN
        XCTAssertNotNil(match.node?.as(VariableDeclSyntax.self))
        XCTAssertNotNil(match.parent?.as(ExtensionDeclSyntax.self))
    }

    func test_findNearestNode_when_variable() {
        // GIVEN
        let source = """
         class MyClass {
            let a = "Hello World!"
         }
        """
        let sourceFile: SourceFileSyntax = Parser.parse(source: source)
        let sourceLocationConverter = SourceLocationConverter(
            fileName: "",
            tree: sourceFile
        )

        // WHEN
        let match = sourceFile.findNearestEnclosingNode(
            for: sourceLocationConverter.position(
                ofLine: 2,
                column: 16
            )
        )

        // THEN
        XCTAssertNotNil(match.node?.as(VariableDeclSyntax.self))
        XCTAssertNotNil(match.parent?.as(ClassDeclSyntax.self))
    }

    func test_findNearestNode_when_typealias() {
        // GIVEN
        let source = """
         extension MyClass {
            typealias Bar = Foo
         }
        """
        let sourceFile: SourceFileSyntax = Parser.parse(source: source)
        let sourceLocationConverter = SourceLocationConverter(
            fileName: "",
            tree: sourceFile
        )

        // WHEN
        let match = sourceFile.findNearestEnclosingNode(
            for: sourceLocationConverter.position(
                ofLine: 2,
                column: 8
            )
        )

        // THEN
        XCTAssertNotNil(match.node?.as(TypeAliasDeclSyntax.self))
        XCTAssertNotNil(match.parent?.as(ExtensionDeclSyntax.self))
    }

    func test_findNearestNode_when_function() {
        // GIVEN
        let source = """
         extension MyClass {
            func foo()
         }
        """
        let sourceFile: SourceFileSyntax = Parser.parse(source: source)
        let sourceLocationConverter = SourceLocationConverter(
            fileName: "",
            tree: sourceFile
        )

        // WHEN
        let match = sourceFile.findNearestEnclosingNode(
            for: sourceLocationConverter.position(
                ofLine: 2,
                column: 8
            )
        )

        // THEN
        XCTAssertNotNil(match.node?.as(FunctionDeclSyntax.self))
        XCTAssertNotNil(match.parent?.as(ExtensionDeclSyntax.self))
    }

    func test_findNearestNode_when_unscoped_variable() {
        // GIVEN
        let source = """
         let a = "HelloWorld!"
        """
        let sourceFile: SourceFileSyntax = Parser.parse(source: source)
        let sourceLocationConverter = SourceLocationConverter(
            fileName: "",
            tree: sourceFile
        )

        // WHEN
        let match = sourceFile.findNearestEnclosingNode(
            for: sourceLocationConverter.position(
                ofLine: 1,
                column: 5
            )
        )

        // THEN
        XCTAssertNotNil(match.node?.as(VariableDeclSyntax.self))
        XCTAssertNotNil(match.parent?.as(CodeBlockItemSyntax.self))
    }

    func test_findNearestNode_when_unscoped_typealias() {
        // GIVEN
        let source = """
         typealias Bar = Foo
        """
        let sourceFile: SourceFileSyntax = Parser.parse(source: source)
        let sourceLocationConverter = SourceLocationConverter(
            fileName: "",
            tree: sourceFile
        )

        // WHEN
        let match = sourceFile.findNearestEnclosingNode(
            for: sourceLocationConverter.position(
                ofLine: 1,
                column: 5
            )
        )

        // THEN
        XCTAssertNotNil(match.node?.as(TypeAliasDeclSyntax.self))
        XCTAssertNotNil(match.parent?.as(CodeBlockItemSyntax.self))
    }
}
