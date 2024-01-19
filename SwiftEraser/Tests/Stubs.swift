import SwiftSyntax
@testable import SwiftEraser

extension Syntax {
    static func `actor`(_ name: String) -> Syntax {
        Syntax(
            ActorDeclSyntax(
                name: .identifier(name),
                memberBlock: .init(
                    members: .init([])
                )
            )
        )
    }

    static func `class`(_ name: String) -> Syntax {
        Syntax(
            ClassDeclSyntax(
                name: .identifier(name),
                memberBlock: .init(
                    members: .init([])
                )
            )
        )
    }

    static func `enum`(_ name: String) -> Syntax {
        Syntax(
            EnumDeclSyntax(
                name: .identifier(name),
                memberBlock: .init(
                    members: .init([])
                )
            )
        )
    }

    static func `struct`(_ name: String) -> Syntax {
        Syntax(
            StructDeclSyntax(
                name: .identifier(name),
                memberBlock: .init(
                    members: .init([])
                )
            )
        )
    }

    static func `extension`(_ name: String) -> Syntax {
        Syntax(
            ExtensionDeclSyntax(
                extendedType: IdentifierTypeSyntax(name: .identifier(name)),
                memberBlock: .init(
                    members: .init([])
                )
            )
        )
    }

    static func `protocol`(_ name: String) -> Syntax {
        Syntax(
            ProtocolDeclSyntax(
                name: .identifier(name),
                memberBlock: .init(
                    members: .init([])
                )
            )
        )
    }

    static func `variable`(_ name: String, type: String = "", optional: Bool = false) -> Syntax {
        Syntax(
            VariableDeclSyntax(
                bindingSpecifier: .keyword(.var),
                bindings: .init([
                    PatternBindingSyntax(
                        pattern: IdentifierPatternSyntax(identifier: .identifier(name)),
                        typeAnnotation: {
                            if optional {
                                TypeAnnotationSyntax(
                                    type: OptionalTypeSyntax(
                                        wrappedType: IdentifierTypeSyntax(name: .identifier(type)
                                                                         )
                                    )
                                )
                            } else {
                                TypeAnnotationSyntax(
                                    type: IdentifierTypeSyntax(name: .identifier(type))
                                )
                            }
                        }()
                    )
                ])
            )
        )
    }

    static func `typeAlias`(_ name: String) -> Syntax {
        Syntax(
            TypeAliasDeclSyntax(
                name: .identifier(name),
                initializer: TypeInitializerClauseSyntax(
                    value: IdentifierTypeSyntax(name: .identifier(name))
                )
            )
        )
    }

    static func function(_ name: String, _ parameters: FunctionParameterSyntax...) -> Syntax {
        Syntax(
            FunctionDeclSyntax(
                name: .identifier(name),
                signature: .init(
                    parameterClause: FunctionParameterClauseSyntax(
                        parameters: FunctionParameterListSyntax(
                            parameters
                        )
                    )
                )
            )
        )
    }

    static func `subscript`(
        _ name: String,
        _ parameters: FunctionParameterSyntax...,
        returnType: String
    ) -> Syntax {
        Syntax(
            SubscriptDeclSyntax(
                parameterClause: FunctionParameterClauseSyntax(
                    parameters: FunctionParameterListSyntax(
                        parameters
                    )
                ),
                returnClause: ReturnClauseSyntax(
                    type: IdentifierTypeSyntax(name: .identifier(returnType))
                )
            )
        )
    }

    static func codeBlockItem(_ syntax: DeclSyntax) -> Syntax {
        Syntax(
            CodeBlockItemSyntax(
                item: CodeBlockItemSyntax.Item.decl(syntax)
            )
        )
    }
}

extension FunctionParameterSyntax {
    static func parameters(
        firstName: String? = nil,
        secondName: String? = nil,
        typeName: String
    ) -> Self {
        FunctionParameterSyntax(
            firstName: firstName.map { TokenSyntax.identifier($0) } ?? .wildcardToken(),
            secondName: secondName.map { TokenSyntax.identifier($0) },
            type: IdentifierTypeSyntax(name: .identifier(typeName))
        )
    }
}

extension Action {
    var source: String? {
        switch self {
        case .delete:
            return nil
        case .rewrite(let source):
            return source
        }
    }
}
