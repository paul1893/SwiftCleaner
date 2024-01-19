import XCTest
import SwiftSyntax
@testable import SwiftEraser

final class RulesTests: XCTestCase {
    func test_should_delete_actor() throws {
        // GIVEN
        let source = """
         actor FooActor {
            init() {}
         }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .class,
            node: .init(
                memberOrDeclName: "FooActor",
                node: .actor("FooActor"),
                parent: nil
            )
        )

        // THEN
        XCTAssertEqual(
            result,
            .delete
        )
    }

    func test_should_delete_class() throws {
        // GIVEN
        let source = """
         final class FooClass {
            init() {}
         }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .class,
            node: .init(
                memberOrDeclName: "FooClass",
                node: .class("FooClass"),
                parent: nil
            )
        )

        // THEN
        XCTAssertEqual(
            result,
            .delete
        )
    }

    func test_should_delete_enum() throws {
        // GIVEN
        let source = """
         enum FooEnum {
            init() {}
         }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .enum,
            node: .init(
                memberOrDeclName: "FooEnum",
                node: .enum("FooEnum"),
                parent: nil
            )
        )

        // THEN
        XCTAssertEqual(
            result,
            .delete
        )
    }

    func test_should_delete_struct() throws {
        // GIVEN
        let source = """
         struct FooStruct {
            init() {}
         }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .struct,
            node: .init(
                memberOrDeclName: "FooStruct",
                node: .struct("FooStruct"),
                parent: nil
            )
        )

        // THEN
        XCTAssertEqual(
            result,
            .delete
        )
    }

    func test_should_delete_extension() throws {
        // GIVEN
        let source = """
         extension FooExtension {
            init() {}
         }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .class,
            node: .init(
                memberOrDeclName: "FooExtension",
                node: .extension("FooExtension"),
                parent: nil
            )
        )

        // THEN
        XCTAssertEqual(
            result,
            .delete
        )
    }

    func test_should_delete_protocol() throws {
        // GIVEN
        let source = """
         protocol FooProtocol {
            init() {}
         }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .protocol,
            node: .init(
                memberOrDeclName: "FooProtocol",
                node: .protocol("FooProtocol"),
                parent: nil
            )
        )

        // THEN
        XCTAssertEqual(
            result,
            .delete
        )
    }

    func test_should_delete_redundant_protocol() throws {
        // GIVEN
        try test_should_delete_protocol()
        let source = """
         protocol FooProtocol {
            init() {}
         }
         final class FooClass: FooProtocol {
            init() {}
         }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.redundantProtocol],
            kind: .protocol,
            node: .init(
                memberOrDeclName: "FooProtocol",
                node: .protocol("FooProtocol"),
                parent: nil
            )
        )

        // THEN
        XCTAssertEqual(
            result.source,
            """

             final class FooClass: FooProtocol {
                init() {}
             }
            """
        )
    }

    func test_should_delete_redundant_protocol_conformance() throws {
        // GIVEN
        try test_should_delete_protocol()
        let source = """
         final class FooClass: FooProtocol {
            init() {}
         }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.redundantConformance],
            kind: .protocol,
            node: .init(
                memberOrDeclName: "FooProtocol",
                node: .protocol("FooProtocol"),
                parent: nil
            )
        )

        // THEN
        XCTAssertEqual(
            result.source,
            """
             final class FooClass{
                init() {}
             }
            """
        )
    }

    func test_should_delete_redundant_protocol_when_multiple_conformance() throws {
        // GIVEN
        try test_should_delete_protocol()
        let source = """
         final class FooClass: FooProtocol, BarProtocol {
            init() {}
         }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.redundantConformance],
            kind: .protocol,
            node: .init(
                memberOrDeclName: "BarProtocol",
                node: .protocol("BarProtocol"),
                parent: nil
            )
        )

        // THEN
        XCTAssertEqual(
            result.source,
            """
             final class FooClass: FooProtocol{
                init() {}
             }
            """
        )
    }

    func test_should_delete_var_unscoped() throws {
        // GIVEN
        let source = """
         var a: String = ""
         final class FooClass {
            init() {}
         }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .varGlobal,
            node: .init(
                memberOrDeclName: "a",
                node: .variable("a"),
                parent: nil
            )
        )

        // THEN
        XCTAssertEqual(
            result.source,
            """

             final class FooClass {
                init() {}
             }
            """
        )
    }

    func test_should_delete_typealias_unscoped() throws {
        // GIVEN
        let source = """
         typealias A = String
         final class FooClass {
            init() {}
         }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .typealias,
            node: .init(
                memberOrDeclName: "A",
                node: .typeAlias("A"),
                parent: nil
            )
        )

        // THEN
        XCTAssertEqual(
            result.source,
            """

             final class FooClass {
                init() {}
             }
            """
        )
    }

    func test_should_delete_property() throws {
        // GIVEN
        try test_should_delete_protocol()
        let source = """
         final class FooClass {
            private var a: FooProtocol

            init() {}
         }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .varInstance,
            node: .init(
                memberOrDeclName: "a",
                node: .variable("a", type: "FooProtocol"),
                parent: .class("FooClass")
            )
        )

        // THEN
        XCTAssertEqual(
            result.source,
            """
             final class FooClass {

                init() {}
             }
            """
        )
    }

    func test_should_delete_existential_property() throws {
        // GIVEN
        try test_should_delete_protocol()
        let source = """
         final class FooClass {
            private var a: any FooProtocol

            init() {}
         }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .varInstance,
            node: .init(
                memberOrDeclName: "a",
                node: .variable("a", type: "FooProtocol"),
                parent: .class("FooClass")
            )
        )

        // THEN
        XCTAssertEqual(
            result.source,
            """
             final class FooClass {

                init() {}
             }
            """
        )
    }

    func test_should_delete_optional_property() throws {
        // GIVEN
        try test_should_delete_protocol()
        let source = """
         final class FooClass {
             private weak var delegate: FooProtocol?

             init() {}
         }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .varInstance,
            node: .init(
                memberOrDeclName: "delegate",
                node: .variable("delegate", type: "FooDelegate", optional: true),
                parent: .class("FooClass")
            )
        )

        // THEN
        XCTAssertEqual(
            result.source,
            """
             final class FooClass {

                 init() {}
             }
            """
        )
    }

    func test_should_delete_function() throws {
        // GIVEN
        let source = """
        final class FooClass {
            private let a = 1
            func foo() {

            }
        }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .functionMethodInstance,
            node: .init(
                memberOrDeclName: "foo()",
                node: .function("foo"),
                parent: .class("FooClass")
            )
        )

        // THEN
        XCTAssertEqual(
            result.source,
            """
            final class FooClass {
                private let a = 1
            }
            """
        )
    }

    func test_should_delete_function_with_parameters() throws {
        // GIVEN
        let source = """
        final class FooClass {
            private let a = 1
            func foo(a: Int, b: String) {

            }
        }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .functionMethodInstance,
            node: .init(
                memberOrDeclName: "foo(a:,b:)",
                node: .function("foo", .parameters(firstName: "a", typeName: "Int"), .parameters(firstName: "b", typeName: "String")),
                parent: .class("FooClass")
            )
        )

        // THEN
        XCTAssertEqual(
            result.source,
            """
            final class FooClass {
                private let a = 1
            }
            """
        )
    }

    func test_should_delete_initializer() throws {
        // GIVEN
        let source = """
        final class FooClass {
            private let a = 1
             init() {

             }
        }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .functionConstructor,
            node: .init(
                memberOrDeclName: "init()",
                node: .function("init"),
                parent: .class("FooClass")
            )
        )

        // THEN
        XCTAssertEqual(
            result.source,
            """
            final class FooClass {
                private let a = 1
            }
            """
        )
    }

    func test_should_delete_initializer_with_parameters() throws {
        // GIVEN
        let source = """
        final class FooClass {
            private let a = 1
            init(a: Int) {

            }
        }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .functionConstructor,
            node: .init(
                memberOrDeclName: "init(a:)",
                node: .function("init", .parameters(firstName: "a", typeName: "Int")),
                parent: .class("FooClass")
            )
        )

        // THEN
        XCTAssertEqual(
            result.source,
            """
            final class FooClass {
                private let a = 1
            }
            """
        )
    }

    func test_should_delete_case() throws {
        // GIVEN
        let source = """
        enum FooEnum {
            case a
            case b
        }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .enumelement,
            node: .init(
                memberOrDeclName: "b",
                node: Syntax(
                    EnumCaseElementListSyntax.Element(
                        name: .identifier("b")
                    )
                ),
                parent: .enum("FooEnum")
            )
        )

        // THEN
        XCTAssertEqual(
            result.source,
            """
            enum FooEnum {
                case a
            }
            """
        )
    }

    func test_should_delete_function_when_unscoped() throws {
        // GIVEN
        let source = """
        func NSLocalizedStringAccount(_ key: String) -> String {
            return Bundle(identifier: "com.my.identifier")?.localizedString(forKey: key, value: "", table: "MY_TABLE") ?? key
        }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .functionFree,
            node: .init(
                memberOrDeclName: "NSLocalizedStringAccount(_:)",
                node: .function(
                    "NSLocalizedStringAccount",
                    .parameters(secondName: "key", typeName: "String")
                ),
                parent: .codeBlockItem(
                    DeclSyntax(
                        FunctionDeclSyntax(
                            name: .identifier("NSLocalizedStringAccount"),
                            signature: .init(
                                parameterClause: FunctionParameterClauseSyntax(
                                    parameters: FunctionParameterListSyntax(
                                        arrayLiteral: .parameters(secondName: "key", typeName: "String")
                                    )
                                )
                            )
                        )
                    )
                )
            )
        )

        // THEN
        XCTAssertEqual(
            result,
            .delete
        )
    }

    func test_should_delete_function_when_protocol() throws {
        // GIVEN
        let source = """
        protocol FooProtocol: AnyObject {
            func didSetField(_ field: String?, value: Any?)
            func reloadRow(_ row: Row)
        }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .functionMethodInstance,
            node: .init(
                memberOrDeclName: "reloadRow(_:)",
                node: .function(
                    "reloadRow",
                    .parameters(secondName: "row", typeName: "Row")
                ),
                parent: .protocol("FooProtocol")
            )
        )

        // THEN
        XCTAssertEqual(
            result.source,
            """
            protocol FooProtocol: AnyObject {
                func didSetField(_ field: String?, value: Any?)
            }
            """
        )
    }

    func test_should_delete_function_when_class() throws {
        // GIVEN
        let source = """
        final class Foo {
            private let a = 1
            func foo() -> Bool {
                return self.text.isEmpty
            }
        }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .functionMethodInstance,
            node: .init(
                memberOrDeclName: "foo()",
                node: .function("foo"),
                parent: .class("Foo")
            )
        )

        // THEN
        XCTAssertEqual(
            result.source,
            """
            final class Foo {
                private let a = 1
            }
            """
        )
    }

    func test_should_delete_function_with_parametes_when_class() throws {
        // GIVEN
        let source = """
        final class Foo {
            private let a = 1
            func setSelectedValue(value: String) {
                self.selectedValue = value
            }
        }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .functionMethodInstance,
            node: .init(
                memberOrDeclName: "setSelectedValue(value:)",
                node: .function(
                    "setSelectedValue",
                    .parameters(firstName: "value", typeName: "String")
                ),
                parent: .class("Foo")
            )
        )

        // THEN
        XCTAssertEqual(
            result.source,
            """
            final class Foo {
                private let a = 1
            }
            """
        )
    }

    func test_should_delete_function_when_extension() throws {
        // GIVEN
        let source = """
        extension String {
            /// Lorem ipsum dolor sit amet, consectetur adipiscing elit.
            /// - note: Ut eget ante id velit.
            /// - Parameters:
            /// - table: Fusce vel vestibulum turpis.
            /// - args: Fusce vel vestibulum turpis.
            /// - Returns: Nullam quis diam dignissim, commodo odio eget, viverra purus.
            func localized(table: LocalizeTable, _ args: CVarArg...) -> String {
                return self.localized(table: table, args: args)
            }
        }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .functionMethodInstance,
            node: .init(
                memberOrDeclName: "localized(table:_:)",
                node: .function(
                    "localized(table:_:)",
                    .parameters(firstName: "table", typeName: "LocalizeTable"),
                    .parameters(secondName: "args", typeName: "CVarArg")
                ),
                parent: .extension("String")
            )
        )

        // THEN
        XCTAssertEqual(
            result,
            .delete
        )
    }

    func test_should_delete_associatedType_when_delete_last_func_that_is_using_it() throws {
        // GIVEN
        let source = """
        protocol FooView: UIContentView {
            associatedtype ViewModel
            private let foo = 1
            var bar: Int {
                1
            }
            init(configuration: UIContentConfiguration)
            func update(with viewModel: ViewModel)
            static func baz() {}
        }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .functionMethodInstance,
            node: .init(
                memberOrDeclName: "update(with:)",
                node: .function(
                    "update(with:)",
                    .parameters(firstName: "with", secondName: "viewModel", typeName: "ViewModel")
                ),
                parent: .protocol("FooView")
            )
        )

        // THEN
        XCTAssertEqual(
            result.source,
            """
            protocol FooView: UIContentView {
                private let foo = 1
                var bar: Int {
                    1
                }
                init(configuration: UIContentConfiguration)
                static func baz() {}
            }
            """
        )
    }

    func test_should_not_delete_associatedType_when_delete_func_is_not_last_one_that_is_using_it() throws {
        // GIVEN
        let source = """
        protocol FooView: UIContentView {
            associatedtype ViewModel
            init(configuration: UIContentConfiguration)
            func update(with viewModel: ViewModel)
            func foo(viewModel: ViewModel)
        }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .functionMethodInstance,
            node: .init(
                memberOrDeclName: "update(with:)",
                node: .function(
                    "update(with:)",
                    .parameters(firstName: "with", secondName: "viewModel", typeName: "ViewModel")
                ),
                parent: .protocol("FooView")
            )
        )

        // THEN
        XCTAssertEqual(
            result.source,
            """
            protocol FooView: UIContentView {
                associatedtype ViewModel
                init(configuration: UIContentConfiguration)
                func foo(viewModel: ViewModel)
            }
            """
        )
    }

    func test_should_delete_the_whole_decl_group_when_delete_last_func_() throws {
        // GIVEN
        let source = """
        internal class FooView {

            /// Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse in libero elit. Sed vel urna sit amet nibh sodales suscipit et eu dolor.
            ///
            /// Phasellus ullamcorper posuere tempus.
            ///
            /// - Returns: The view
            internal static func getView() -> UIView {
                let view = FooView()
                view.translatesAutoresizingMaskIntoConstraints = false
                view.configureView()
                return view
            }
        }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .functionMethodInstance,
            node: .init(
                memberOrDeclName: "getView()",
                node: .function("getView()"),
                parent: .class("FooView")
            )
        )

        // THEN
        XCTAssertEqual(
            result,
            .delete
        )
    }

    func test_should_delete_function_when_extension_is_conforming_to_a_protocol() throws {
        // GIVEN
        let source = """
        extension Foo: FooProtocol {
            func foo() {
                // ...
            }
        }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .functionMethodInstance,
            node: .init(
                memberOrDeclName: "foo(:)",
                node: .function("foo"),
                parent: .extension("Foo")
            )
        )

        // THEN
        XCTAssertEqual(
            result.source,
            """
            extension Foo: FooProtocol {
            }
            """
        )
    }

    func test_should_delete_subscript_when_class_with_parameters() throws {
        // GIVEN
        let source = """
        class Foo {
            subscript(index: Int) -> Int {
            }
        }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .functionSubscript,
            node: .init(
                memberOrDeclName: "subscript(index:)",
                node: .`subscript`(
                    "subscript(index:)",
                    .parameters(firstName: "index", typeName: "Int"),
                    returnType: "Int"
                ),
                parent: .class("Foo")
            )
        )

        // THEN
        XCTAssertEqual(
            result,
            .delete
        )
    }

    func test_should_delete_subscript_when_class_with_anonymous_parameters() throws {
        // GIVEN
        let source = """
        class Foo {
            subscript(_ index: Int) -> Int {
            }
        }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .functionSubscript,
            node: .init(
                memberOrDeclName: "subscript(_:)",
                node: .`subscript`(
                    "subscript(_:)",
                    .parameters(secondName: "index", typeName: "Int"),
                    returnType: "Int"
                ),
                parent: .class("Foo")
            )
        )

        // THEN
        XCTAssertEqual(
            result,
            .delete
        )
    }

    func test_should_delete_one_initializer_when_two_initializers_have_same_parameters_name() throws {
        // GIVEN
        let source = """
        enum FooError: Error {
            case unknown

            init(error _: BarError) {
                self = .unknown
            }

            init(error _: BazError) {
                self = .unknown
            }
        }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .functionConstructor,
            node: .init(
                memberOrDeclName: "init(error:)",
                node: .function("init",
                                .parameters(firstName: "error", typeName: "BazError")
                ),
                parent: .enum("FooError")
            )
        )

        // THEN
        XCTAssertEqual(
            result.source,
            """
            enum FooError: Error {
                case unknown

                init(error _: BarError) {
                    self = .unknown
                }
            }
            """
        )
    }

    func test_should_apply_transitivity_within_same_file_when_delete_protocol() throws {
        // GIVEN
        let source = """
        final class Foo {
            private(set) var ref: (any FooProtocol)?

            func foo(_ foo: Foo) {
                ref = foo
            }
        }

        class Bar: BarProtocol {}
        protocol BarProtocol: FooProtocol where T == Date {}
        class Foo: BarProtocol {}
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .protocol,
            node: .init(
                memberOrDeclName: "BarProtocol",
                node: .protocol("BarProtocol"),
                parent: .protocol("BarProtocol")
            )
        )

        // THEN
        XCTAssertEqual(
            result.source,
            """
            final class Foo {
                private(set) var ref: (any FooProtocol)?

                func foo(_ foo: Foo) {
                    ref = foo
                }
            }

            class Bar: FooProtocol where T == Date {}
            class Foo: FooProtocol where T == Date {}
            """
        )
    }

    func test_should_delete_function_when_unscoped_2() throws {
        // GIVEN
        let source = """
        private func NSLocalizedString(_ key: String, tableName: String?, referenceClass: AnyClass) -> String {
            let bundle = Bundle(for: referenceClass)
            return NSLocalizedString(key, tableName: tableName, bundle: bundle, comment: "")
        }
        """

        // WHEN
        let functionNode = FunctionDeclSyntax(
            name: .identifier("NSLocalizedString"),
            signature: .init(
                parameterClause: FunctionParameterClauseSyntax(
                    parameters: FunctionParameterListSyntax(
                        arrayLiteral: .parameters(secondName: "key", typeName: "String"),
                        .parameters(firstName: "args", typeName: "String"),
                        .parameters(firstName: "referenceClass", typeName: "AnyClass")
                    )
                )
            )
        )
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .functionFree,
            node: .init(
                memberOrDeclName: "NSLocalizedString(_:,tableName:,referenceClass:)",
                node: Syntax(functionNode),
                parent: .codeBlockItem(DeclSyntax(functionNode))
            )
        )

        // THEN
        XCTAssertEqual(
            result,
            .delete
        )
    }

    func test_should_delete_weak_property() throws {
        // GIVEN
        let source = """
        final class FooViewModel {
            private let a = 1
            weak var property: (any FooDelegate)?
        }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .varInstance,
            node: .init(
                memberOrDeclName: "property",
                node: .variable("property", type: "FooDelegate"),
                parent: .class("FooViewModel")
            )
        )

        // THEN
        XCTAssertEqual(
            result.source,
            """
            final class FooViewModel {
                private let a = 1
            }
            """
        )
    }

    func test_should_delete_private_weak_property() throws {
        // GIVEN
        let source = """
        final class FooViewModel {
            private weak var delegate: FooViewModelDelegate?
            var models: [FooModel]

            init(models: [FooModel]) {
                self.models = models
            }
        }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .varInstance,
            node: .init(
                memberOrDeclName: "delegate",
                node: .variable("delegate", type: "FooViewModelDelegate"),
                parent: .class("FooViewModel")
            )
        )

        // THEN
        XCTAssertEqual(
            result.source,
            """
            final class FooViewModel {
                var models: [FooModel]

                init(models: [FooModel]) {
                    self.models = models
                }
            }
            """
        )
    }

    func test_should_delete_let_property() throws {
        // GIVEN
        let source = """
        final class FooViewModel {
            private let a = 1
            let accessibility = AccessibilityIdentifiers.loremIpsum
        }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .varInstance,
            node: .init(
                memberOrDeclName: "accessibility",
                node: .variable("accessibility"),
                parent: .class("FooViewModel")
            )
        )

        // THEN
        XCTAssertEqual(
            result.source,
            """
            final class FooViewModel {
                private let a = 1
            }
            """
        )
    }

    func test_should_delete_the_whole_decl_group_when_last_property_deleted() throws {
        // GIVEN
        let source = """
        final class Foo {
            let accessibility = AccessibilityIdentifiers.loremIpsum
        }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .varInstance,
            node: .init(
                memberOrDeclName: "accessibility",
                node: .variable("accessibility"),
                parent: .class("Foo")
            )
        )

        // THEN
        XCTAssertEqual(
            result,
            .delete
        )
    }

    func test_should_delete_property_when_same_name_in_same_file() throws {
        // GIVEN
        let source = """
        class Foo {
            let name: String
        }
        class Bar {
            let name: String
        }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .varInstance,
            node: .init(
                memberOrDeclName: "name",
                node: .variable("name"),
                parent: .class("Foo")
            )
        )

        // THEN
        XCTAssertEqual(
            result,
            .rewrite(
            """

            class Bar {
                let name: String
            }
            """
            )
        )
    }

    func test_should_not_delete_property_when_has_codingkeys_inside_extension_within_same_file() throws {
        // GIVEN
        let source = """
        import Foundation

        struct Foo {
            let id: Int
            let services: [Service]
        }

        extension Foo: Decodable {
            enum CodingKeys: String, CodingKey {
                case id = "identifier"
                case services
            }
        }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .varInstance,
            node: .init(
                memberOrDeclName: "id",
                node: .variable("id", type: "Int"),
                parent: .struct("Foo")
            )
        )

        // THEN
        XCTAssertEqual(
            result.source,
            """
            import Foundation

            struct Foo {
                let id: Int
                let services: [Service]
            }

            extension Foo: Decodable {
                enum CodingKeys: String, CodingKey {
                    case id = "identifier"
                    case services
                }
            }
            """
        )
    }

    func test_should_delete_property_when_codingkeys_not_from_specified_decl_but_within_same_file() throws {
        // GIVEN
        let source = """
        import Foundation

        struct Bar {
            let id: Int
            let services: [Service]
        }

        extension Foo: Decodable {
            enum CodingKeys: String, CodingKey {
                case home
                case car
            }
        }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .varInstance,
            node: .init(
                memberOrDeclName: "id",
                node: .variable("id", type: "Int"),
                parent: .struct("Bar")
            )
        )

        // THEN
        XCTAssertEqual(
            result.source,
            """
            import Foundation

            struct Bar {
                let services: [Service]
            }

            extension Foo: Decodable {
                enum CodingKeys: String, CodingKey {
                    case home
                    case car
                }
            }
            """
        )
    }

    func test_should_not_delete_property_when_has_codingkeys_nested() throws {
        // GIVEN
        let source = """
        import Foundation
        import ThirdPartyFramework

        struct Foo {
            let id: Int
            let services: [Service]

            enum CodingKeys: String, CodingKey {
                case id = "identifier"
                case services
            }
        }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .varInstance,
            node: .init(
                memberOrDeclName: "id",
                node: .variable("id", type: "Int"),
                parent: .struct("Foo")
            )
        )

        // THEN
        XCTAssertEqual(
            result.source,
            """
            import Foundation
            import ThirdPartyFramework

            struct Foo {
                let id: Int
                let services: [Service]

                enum CodingKeys: String, CodingKey {
                    case id = "identifier"
                    case services
                }
            }
            """
        )
    }

    func test_should_delete_property_unscoped() throws {
        // GIVEN
        let source = """
        let LOREM = "LOREM"
        let IPSUM = "IPSUM"
        let DOLOR = "ERROR_NONE_ACCOUNT"

        let SIT = "SIT"
        let AMET = "AMET"
        let CONSECTETUR_ADIPISCING = "CONSECTETUR_ADIPISCING"
        let ELIT = "ELIT"
        """

        // WHEN
        let `var` = Syntax.variable("SIT").as(VariableDeclSyntax.self)!
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .varGlobal,
            node: .init(
                memberOrDeclName: "SIT",
                node: Syntax(`var`),
                parent: .codeBlockItem(
                    DeclSyntax(`var`)
                )
            )
        )

        // THEN
        XCTAssertEqual(
            result.source,
            """
            let LOREM = "LOREM"
            let IPSUM = "IPSUM"
            let DOLOR = "ERROR_NONE_ACCOUNT"
            let AMET = "AMET"
            let CONSECTETUR_ADIPISCING = "CONSECTETUR_ADIPISCING"
            let ELIT = "ELIT"
            """
        )
    }

    func test_should_delete_property_unscoped_2() throws {
        // GIVEN
        let source = """
        /// Lorem ispum
        let _LOREM_ = "XXX_Foo"

        let _IPSUM_DOLOR_SIT_ = "\\(_LOREM_)Localizable"

        func NSLocalizedStringAccount(_ key: String) -> String {
        return Bundle(identifier: "com.hostname.identifier")?.localizedString(forKey: key, value: "", table: _IPSUM_DOLOR_SIT_) ?? key
        }

        let API_NAME = "api"
        let API_VERSION = "v1"

        // MARK: - Constants

        let PHONE_MAX_LENGTH: Int32 = 10

        // MARK: - ACCOUNT CREATION RESPONSE
        let ACCOUNT_PRO_ACCOUNT = "ACCOUNT_PRO_ACCOUNT"

        // MARK: - ERROR MESSAGES

        let CONFIRMATION_INVALID_EMAIL = "ERROR_INVALID_EMAIL"
        let PERSONAL_DATA_SERVICE_UNAVAILABLE = "ERROR_SERVICE"

        let FABRIC_ERROR_TECHNICAL_PROBLEM = "ERROR_TECHNICAL_PROBLEM"
        let FABRIC_ERROR_NO_NETWORK = "ERROR_NO_NETWORK"
        let FABRIC_CLASS_NAME = "CLASS_NAME"
        let FABRIC_ERROR_SERVER_PARAMETER_NAME = "ERROR_NAME"
        let FABRIC_ERROR_SERVER_TYPE_TIMEOUT = "ERROR_TIMEOUT"
        """

        // WHEN
        let var0 = Syntax.variable("PERSONAL_DATA_SERVICE_UNAVAILABLE").as(VariableDeclSyntax.self)!
        let _0 = try delete(
            sourceText: source,
            types: [.unused],
            kind: .varGlobal,
            node: .init(
                memberOrDeclName: "PERSONAL_DATA_SERVICE_UNAVAILABLE",
                node: Syntax(var0),
                parent: .codeBlockItem(
                    DeclSyntax(var0)
                )
            )
        )
        let var1 = Syntax.variable("ACCOUNT_PRO_ACCOUNT").as(VariableDeclSyntax.self)!
        let _1 = try delete(
            sourceText: _0.source!,
            types: [.unused],
            kind: .varGlobal,
            node: .init(
                memberOrDeclName: "ACCOUNT_PRO_ACCOUNT",
                node: Syntax(var1),
                parent: .codeBlockItem(
                    DeclSyntax(var1)
                )
            )
        )
        let var2 = Syntax.variable("CONFIRMATION_INVALID_EMAIL").as(VariableDeclSyntax.self)!
        let _2 = try delete(
            sourceText: _1.source!,
            types: [.unused],
            kind: .varGlobal,
            node: .init(
                memberOrDeclName: "CONFIRMATION_INVALID_EMAIL",
                node: Syntax(var2),
                parent: .codeBlockItem(
                    DeclSyntax(var2)
                )
            )
        )
        let var3 = Syntax.variable("_IPSUM_DOLOR_SIT_").as(VariableDeclSyntax.self)!
        let _3 = try delete(
            sourceText: _2.source!,
            types: [.unused],
            kind: .varGlobal,
            node: .init(
                memberOrDeclName: "_IPSUM_DOLOR_SIT_",
                node: Syntax(var3),
                parent: .codeBlockItem(
                    DeclSyntax(var3)
                )
            )
        )
        let func1 = Syntax.function("NSLocalizedStringAccount", .parameters(firstName: nil, secondName: "key", typeName: "String")).as(FunctionDeclSyntax.self)!
        let result = try delete(
            sourceText: _3.source!,
            types: [.unused],
            kind: .functionFree,
            node: .init(
                memberOrDeclName: "NSLocalizedStringAccount(_:)",
                node: Syntax(func1),
                parent: .codeBlockItem(
                    DeclSyntax(func1)
                )
            )
        )

        // THEN
        XCTAssertEqual(
            result.source,
            """
            /// Lorem ispum
            let _LOREM_ = "XXX_Foo"

            let API_NAME = "api"
            let API_VERSION = "v1"

            // MARK: - Constants

            let PHONE_MAX_LENGTH: Int32 = 10

            let FABRIC_ERROR_TECHNICAL_PROBLEM = "ERROR_TECHNICAL_PROBLEM"
            let FABRIC_ERROR_NO_NETWORK = "ERROR_NO_NETWORK"
            let FABRIC_CLASS_NAME = "CLASS_NAME"
            let FABRIC_ERROR_SERVER_PARAMETER_NAME = "ERROR_NAME"
            let FABRIC_ERROR_SERVER_TYPE_TIMEOUT = "ERROR_TIMEOUT"
            """
        )
    }

    func test_should_keep_protocol_when_delete_all_functions_of_a_protocol() throws {
        // GIVEN
        let source = """
        protocol FooDelegate: AnyObject {
            func didEditAccount(account: Account)
        }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .functionMethodInstance,
            node: .init(
                memberOrDeclName: "didEditAccount(account:)",
                node: .function(
                    "didEditAccount(account:)",
                    .parameters(firstName: "account", typeName: "Account")
                ),
                parent: .protocol("FooDelegate")
            )
        )

        // THEN
        XCTAssertEqual(
            result.source,
            """
            protocol FooDelegate: AnyObject {
            }
            """
        )
    }

    func test_should_keep_protocol_when_delete_all_properties_of_a_protocol() throws {
        // GIVEN
        let source = """
        protocol FooDelegate: AnyObject {
            var foo: Foo { get set }
        }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .varInstance,
            node: .init(
                memberOrDeclName: "foo",
                node: .variable("foo"),
                parent: .protocol("FooDelegate")
            )
        )

        // THEN
        XCTAssertEqual(
            result.source,
            """
            protocol FooDelegate: AnyObject {
            }
            """
        )
    }

    func test_should_delete_typealias_when_unscoped() throws {
        // GIVEN
        let source = """
        typealias Foo = String
        """

        // WHEN
        let typealiasNode = TypeAliasDeclSyntax(
            name: TokenSyntax.identifier("Foo"),
            initializer: .init(value: IdentifierTypeSyntax(name: TokenSyntax.identifier("String")))
        )
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .typealias,
            node: .init(
                memberOrDeclName: "Foo",
                node: Syntax(typealiasNode),
                parent: .codeBlockItem(
                    DeclSyntax(typealiasNode)
                )
            )
        )

        // THEN
        XCTAssertEqual(
            result,
            .delete
        )
    }

    func test_should_delete_static_property() throws {
        // GIVEN
        let source = """
        struct Foo {
            /// Lorem ispum
            static let a = "A"
            static let b = B.self
            static let c = C.self
            static let d = D.self
            /// dolor sit amet
            static let e = "E"
            static let f = "F"

            /// consectetur adipiscing elit
            static let g = "G"
            static let h = H.self
        }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .varStatic,
            node: .init(
                memberOrDeclName: "b",
                node: .variable("b"),
                parent: .struct("Foo")
            )
        )

        // THEN
        XCTAssertEqual(
            result.source,
            """
            struct Foo {
                /// Lorem ispum
                static let a = "A"
                static let c = C.self
                static let d = D.self
                /// dolor sit amet
                static let e = "E"
                static let f = "F"

                /// consectetur adipiscing elit
                static let g = "G"
                static let h = H.self
            }
            """
        )
    }

    func test_should_delete_static_function() throws {
        // GIVEN
        let source = """
        struct Foo {
            static func foo() { print ("I'm foo") }
        }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .functionMethodStatic,
            node: .init(
                memberOrDeclName: "foo()",
                node: .function("foo"),
                parent: .struct("Foo")
            )
        )

        // THEN
        XCTAssertEqual(
            result,
            .delete
        )
    }

    func test_should_delete_the_whole_decl_group_when_delete_last_initializer() throws {
        // GIVEN
        let source = """
        internal class FooView {

            init(a: Foo) {}
        }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .functionConstructor,
            node: .init(
                memberOrDeclName: "init(a:)",
                node: .function("init(a:)", .parameters(firstName: "a", typeName: "Foo")),
                parent: .class("FooView")
            )
        )

        // THEN
        XCTAssertEqual(
            result,
            .delete
        )
    }

    func test_should_delete_initializer_even_when_both_initializers_have_same_parameters_name() throws {
        // GIVEN
        let source = """
        enum FooError: Error {
            case unknown

            init(error _: BarError) {
                self = .unknown
            }

            init(error _: BazError) {
                self = .unknown
            }
        }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .functionConstructor,
            node: .init(
                memberOrDeclName: "init(error:)",
                node: .function("init", .parameters(firstName: "error", secondName: nil, typeName: "BazError")),
                parent: .enum("FooError")
            )
        )

        // THEN
        XCTAssertEqual(
            result.source,
            """
            enum FooError: Error {
                case unknown

                init(error _: BarError) {
                    self = .unknown
                }
            }
            """
        )
    }

    func test_should_delete_function_when_same_function_name_within_same_file() throws {
        // GIVEN
        let source = """
        extension Foo {
            func foo(x: Int)
        }
        extension Bar {
            func foo(x: Int)
        }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .functionMethodInstance,
            node: .init(
                memberOrDeclName: "foo(x:)",
                node: .function(
                    "foo(x:)",
                    .parameters(firstName: "x", typeName: "Int")
                ),
                parent: .extension("Foo")
            )
        )

        // THEN
        XCTAssertEqual(
            result.source,
            """

            extension Bar {
                func foo(x: Int)
            }
            """
        )
    }
    func test_should_delete_subscript_when_same_subscript_name_within_same_file() throws {
        // GIVEN
        let source = """
        extension Foo {
            subscript(x: Int) -> Int
        }
        extension Bar {
            subscript(x: Int) -> Int
        }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .functionSubscript,
            node: .init(
                memberOrDeclName: "subscript(x:)",
                node: .subscript(
                    "subscript(x:)",
                    .parameters(firstName: "x", typeName: "Int"),
                    returnType: "Int"
                ),
                parent: .extension("Foo")
            )
        )

        // THEN
        XCTAssertEqual(
            result.source,
            """

            extension Bar {
                subscript(x: Int) -> Int
            }
            """
        )
    }
    func test_should_delete_initializer_when_same_initializer_name_within_same_file() throws {
        // GIVEN
        let source = """
        extension Foo {
            init(x: Int)
        }
        extension Bar {
            init(x: Int)
        }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .functionConstructor,
            node: .init(
                memberOrDeclName: "init(x:)",
                node: .function(
                    "init(x:)",
                    .parameters(firstName: "x", typeName: "Int")
                ),
                parent: .extension("Foo")
            )
        )

        // THEN
        XCTAssertEqual(
            result.source,
            """

            extension Bar {
                init(x: Int)
            }
            """
        )
    }

    func test_should_delete_protocol_when_redundant_conformance_and_keep_where_clause() throws {
        // GIVEN
        let source = """
        extension Foo: FooProtocol where T == Date {
        }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.redundantConformance],
            kind: .protocol,
            node: .init(
                memberOrDeclName: "FooProtocol",
                node: .protocol("FooProtocol"),
                parent: .extension("Foo")
            )
        )

        // THEN
        XCTAssertEqual(
            result.source,
            """
            extension Foo where T == Date {
            }
            """
        )
    }

    func test_should_delete_declaration_should_not_impact_side_declaration() throws {
        // GIVEN
        let source = """
        protocol FooDelegate: AnyObject {
            func updateTotalValue(total: Int, type: `Type`)
            func reloadTableView()
            func startLoader()
            func stopLoader()
        }

        protocol FooManager: BarDelegate {
            var transactions: [[Transaction]] { get set }
            var transaction: (any Transaction)? { get set }
            var delegate: (any FooDelegate)? { get set }
            func data(row: Int, section: Int) -> Transaction?
        }
        """

        // WHEN
        let _0: Action = try delete(
            sourceText: source,
            types: [.redundantProtocol],
            kind: .protocol,
            node: .init(
                memberOrDeclName: "FooManager",
                node: .protocol("FooManager"),
                parent: .protocol("FooManager")
            )
        )
        let result: Action = try delete(
            sourceText: _0.source!,
            types: [.redundantConformance],
            kind: .protocol,
            node: .init(
                memberOrDeclName: "FooManager",
                node: .protocol("FooManager"),
                parent: .protocol("FooManager")
            )
        )

        // THEN
        XCTAssertEqual(
            result.source,
            """
            protocol FooDelegate: AnyObject {
                func updateTotalValue(total: Int, type: `Type`)
                func reloadTableView()
                func startLoader()
                func stopLoader()
            }
            """
        )
    }

    func test_should_delete_one_function_even_if_same_name_within_same_file() throws {
        // GIVEN
        let source = """
        struct Foo {
            func updateValue(_ stringValue: String) {
                self._value = .string(stringValue)
            }

            func updateValue(_ boolValue: Bool) {
                self._value = .bool(boolValue)
            }
        }
        """

        // WHEN
        let result = try delete(
            sourceText: source,
            types: [.unused],
            kind: .functionMethodInstance,
            node: .init(
                memberOrDeclName: "updateValue(_:)",
                node: .function("updateValue", .parameters(secondName: "boolValue", typeName: "Bool")),
                parent: .struct("Foo")
            )
        )

        // THEN
        XCTAssertEqual(
            result.source,
            """
            struct Foo {
                func updateValue(_ stringValue: String) {
                    self._value = .string(stringValue)
                }
            }
            """
        )
    }

    func test_should_delete_members_without_impacting_side_declaration() throws {
        // GIVEN
        let source = """
        protocol FooDependenciesProtocol {
            var bar: any BarProtocol { get }
        }

        final class FooDependencies: FooDependenciesProtocol {
            lazy var bar: any BarProtocol = Services.shared.bar
        }
        """

        // WHEN
        let _0 = try delete(
            sourceText: source,
            types: [.unused],
            kind: .varInstance,
            node: .init(
                memberOrDeclName: "bar",
                node: .variable("bar", type: "BarProtocol"),
                parent: .protocol("FooDependenciesProtocol")
            )
        )
        let result = try delete(
            sourceText: _0.source!,
            types: [.unused],
            kind: .varInstance,
            node: .init(
                memberOrDeclName: "bar",
                node: .variable("bar", type: "BarProtocol"),
                parent: .class("FooDependencies")
            )
        )

        // THEN
        XCTAssertEqual(
            result.source,
            """
            protocol FooDependenciesProtocol {
            }

            final class FooDependencies: FooDependenciesProtocol {
            }
            """
        )
    }
}
