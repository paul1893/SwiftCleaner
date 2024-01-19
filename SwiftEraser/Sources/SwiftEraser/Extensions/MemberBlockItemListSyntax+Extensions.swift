import SwiftSyntax

extension MemberBlockItemListSyntax {
    func removeProperties(matching propertyName: String) -> [MemberBlockItemSyntax] {
        compactMap { block -> MemberBlockItemSyntax? in
            guard let variableDeclSyntax = block
                .decl
                .as(VariableDeclSyntax.self) else {
                return block
            }
            return variableDeclSyntax.matching(propertyName)
            ? nil
            : block
        }
    }

    func removeFunctions(matching functionSignature: String, _ node: SwiftEraser.Node) -> [MemberBlockItemSyntax] {
        let functionName = functionSignature.getFunctionName()
        let functionName2 = node.node.computedName
        let parameters = functionSignature.getParameters()
        let types = node.node.as(FunctionDeclSyntax.self)?.signature.parameterClause.parameters.compactMap { $0.type.as(IdentifierTypeSyntax.self)?.name.description }
        return compactMap { block -> MemberBlockItemSyntax? in
            guard let functionDeclSyntax = block
                .decl
                .as(FunctionDeclSyntax.self),
                  (functionDeclSyntax.name.text == functionName || functionDeclSyntax.name.text == functionName2),
                  functionDeclSyntax
                .signature
                .parameterClause
                .parameters
                .map(\.firstName.text) == parameters,
                  functionDeclSyntax
                .signature
                .parameterClause
                .parameters
                .compactMap({ $0.type.as(IdentifierTypeSyntax.self)?.name.text }) == types
            else {
                return block
            }
            return nil
        }
    }

    func removeSubscripts(matching functionSignature: String, _ node: SwiftEraser.Node) -> [MemberBlockItemSyntax] {
        let parameters = node.node.as(SubscriptDeclSyntax.self)?.parameterClause.parameters.compactMap {
            $0.firstName.text
            // ⚠️ TODO - Handle $0.secondName for accuracy
        }

        let types = node.node.as(SubscriptDeclSyntax.self)?.parameterClause.parameters.compactMap { $0.type.as(IdentifierTypeSyntax.self)?.name.description }
        return compactMap { block -> MemberBlockItemSyntax? in
            guard let subscriptDeclSyntax = block
                .decl
                .as(SubscriptDeclSyntax.self),
                  subscriptDeclSyntax
                .parameterClause
                .parameters
                .map(\.firstName.text) == parameters,
                  subscriptDeclSyntax
                .parameterClause
                .parameters
                .compactMap({ $0.type.as(IdentifierTypeSyntax.self)?.name.text }) == types
            else {
                return block
            }
            return nil
        }
    }

    func removeConstructors(matching functionSignature: String, _ node: SwiftEraser.Node) -> [MemberBlockItemSyntax] {
        let parameters = functionSignature.getParameters()
        let types = node.node.as(FunctionDeclSyntax.self)?.signature.parameterClause.parameters.compactMap { $0.type.as(IdentifierTypeSyntax.self)?.name.description }
        return compactMap { block -> MemberBlockItemSyntax? in
            guard let initializerDeclSyntax = block
                .decl
                .as(InitializerDeclSyntax.self),
                  initializerDeclSyntax
                .signature
                .parameterClause
                .parameters
                .map(\.firstName.text) == parameters,
                  initializerDeclSyntax
                .signature
                .parameterClause
                .parameters
                .compactMap({ $0.type.as(IdentifierTypeSyntax.self)?.name.text }) == types
            else {
                return block
            }
            return nil
        }
    }
}
