import Foundation
import SwiftSyntax
import SwiftParser

private var collectedDeletedProtocols = [ProtocolDeclSyntax]()
private let CodingKey = "CodingKey"

func delete(
    sourceText: String,
    types: [Periphery.JSONNode.Hint],
    kind: Periphery.JSONNode.Kind,
    node: SwiftEraser.Node,
    onlyImport: Bool
) throws -> Action {
    var sourceFile = Parser.parse(source: sourceText)

    // 0. Prepare environment for dedicated feature deletions
    collectedDeletedProtocols = []
    let collectedDeclConformancesToCodingKey: [String: any DeclGroupSyntax] = if sourceFile.description.contains(CodingKey) {
        sourceFile.statements.grouping(byConformingTo: CodingKey)
    } else {
        [:]
    }

    // 1. Iterate through each statements of the source file to remove the declarations matching the entity name
    var statements = sourceFile.statements.compactMap { stmt -> CodeBlockItemListSyntax.Element? in
        // MARK: Import
        // Remove unused import
        if kind == .module,
           types == [.unused],
           stmt.item.as(ImportDeclSyntax.self)?.path.first?.name.text == node.memberOrDeclName
        {
            return nil
        }
        guard !onlyImport else {
            return stmt
        }

        // MARK: Actor, Class, Enum, Struct, Protocol
        if types.notContains([.redundantConformance, .redundantProtocol]),
           stmt.name == node.memberOrDeclName
        {
            if let `protocol` = stmt.item.as(ProtocolDeclSyntax.self) {
                collectedDeletedProtocols.append(`protocol`)
            }
            return nil
        }

        // MARK: Protocol - Redundancy
        if types.contains(.redundantProtocol),
           let `protocol` = stmt.item.as(ProtocolDeclSyntax.self),
           `protocol`.name.text == node.memberOrDeclName
        {
            return nil
        }
        if types.contains(.redundantConformance),
           let declaration = stmt.item.declGroupSyntax {
            return stmt.map {
                declaration.without(protocolConformance: node.memberOrDeclName)
            }
        }

        // MARK: Property section
        // Remove global var
        if kind == .varGlobal,
           let `var` = stmt.item.as(VariableDeclSyntax.self),
           `var`.name?.text == node.memberOrDeclName
        {
            return nil
        }
        // Remove global typealias
        if kind == .typealias,
           let `typealias` = stmt.item.as(TypeAliasDeclSyntax.self),
           `typealias`.name.text == node.memberOrDeclName
        {
            return nil
        }
        // Ignore var instance deletion if have CodingKey conformance
        if kind == .varInstance,
           collectedDeclConformancesToCodingKey.isEmpty == false,
           let statementName = stmt.item.computedName,
           let declaration = stmt.item.declGroupSyntax
        {
            // Iterate once again through the whole file and if found the parent scope name decl that conform to CodingKey and match the name of the current statement then proceed to deletion
            return collectedDeclConformancesToCodingKey[statementName] == nil
            ? stmt.map { declaration.without(property: node.memberOrDeclName) }
            : stmt
        }
        // Remove var instance
        if kind == .varInstance || kind == .varStatic,
           stmt.item.is(into: node.parent),
           let declaration = stmt.item.declGroupSyntax
        {
            let editedStmt = stmt.map {
                declaration.without(property: node.memberOrDeclName)
            }

            return editedStmt.hasNoMembers && !editedStmt.isProtocol && !editedStmt.isConformingToProtocol
            ? nil
            : editedStmt
        }
        // Remove enum case
        if kind == .enumelement,
           stmt.item.is(into: node.parent),
           let `enum` = stmt.item.as(EnumDeclSyntax.self)
        {
            return stmt.map {
                `enum`.without(case: node.memberOrDeclName)
            }
        }

        // MARK: Function section
        // Remove global functions or unscoped functions
        if kind == .functionMethodInstance || kind == .functionFree,
           stmt.computedName == node.node.computedName
        {
            return nil
        }
        // Remove local functions or static functions
        if kind == .functionMethodInstance || kind == .functionMethodStatic,
           stmt.item.is(into: node.parent),
           let declaration = stmt.item.declGroupSyntax
        {
            var editedStmt = stmt.map {
                declaration.without(function: node.memberOrDeclName, node)
            }

            // If we are inside a protocol check and remove associatedType if no longer used
            if let `protocol` = editedStmt.item.as(ProtocolDeclSyntax.self) {
                editedStmt = CodeBlockItemListSyntax.Element(
                    item: .init(
                        `protocol`.removeAssociatedTypesIfNeeded()
                    )
                )
            }

            return editedStmt.hasNoMembers && !editedStmt.isProtocol && !editedStmt.isConformingToProtocol
            ? nil
            : editedStmt
        }

        // Remove local subscript functions
        if kind == .functionSubscript,
           stmt.item.is(into: node.parent),
           let declaration = stmt.item.declGroupSyntax
        {
            let editedStmt = stmt.map {
                declaration.without(functionSubscript: node.memberOrDeclName, node)
            }

            return editedStmt.hasNoMembers && !editedStmt.isProtocol && !editedStmt.isConformingToProtocol
            ? nil
            : editedStmt
        }

        // MARK: Initializer section
        if kind == .functionConstructor,
           stmt.item.is(into: node.parent),
           let declaration = stmt.item.declGroupSyntax
        {
            let editedStmt = stmt.map {
                declaration.without(functionConstructor: node.memberOrDeclName, node)
            }

            return editedStmt.hasNoMembers && !editedStmt.isProtocol && !editedStmt.isConformingToProtocol
            ? nil
            : editedStmt
        }

        return stmt
    }

    // If we deleted some protocols we iterate through the source file again to guarantee conformance transitivity
    if collectedDeletedProtocols.isEmpty == false {
        statements = statements.compactMap { stmt -> CodeBlockItemListSyntax.Element? in
            for `protocol` in collectedDeletedProtocols {
                return stmt.applyTransitivity(for: `protocol`)
            }
            return stmt
        }
    }

    // 2. Remove the statements with the modified tree
    sourceFile.statements = CodeBlockItemListSyntax(statements)

    // 3. Delete the file if needed or write the changes to the file
    if sourceFile.isEmptyOrContainsOnlyCommentsOrImports {
        return .delete
    } else {
        return .rewrite(sourceFile.description)
    }
}
