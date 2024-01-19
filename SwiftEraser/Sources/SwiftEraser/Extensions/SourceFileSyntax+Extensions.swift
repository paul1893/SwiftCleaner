import SwiftSyntax

extension SourceFileSyntax {
    private func findNearestNode(in node: Syntax, position: AbsolutePosition) -> Syntax? {
        for child in node.children(viewMode: .all) {
            if child.position <= position
                && child.endPosition >= position {
                return findNearestNode(in: child, position: position) ?? child
            }
        }
        return nil
    }

    /// Find the nearest parent node that match
    /// ActorDeclSyntax, ClassDeclSyntax, EnumDeclSyntax, ProtocolDeclSyntax, StructDeclSyntax, ExtensionDeclSyntax, or CodeBlockSyntax.
    /// In case of kind child varGlobal we accept the nearest VariableDeclSyntax
    /// In case of kind child  typealias we accept the nearest TypeAliasDeclSyntax
    /// - Parameters:
    ///   - position: position of the child node
    ///   - kind: kind of child node
    /// - Returns: The couple (child, parent). Parent being the nearest parent node.
    func findNearestEnclosingNode(for position: AbsolutePosition) -> (node: Syntax?, parent: Syntax?) {
        var currentNode: Syntax?
        for child in children(viewMode: .all) {
            if child.position <= position
                && child.endPosition >= position {
                currentNode = findNearestNode(in: child, position: position) ?? child
            }
        }

        var localNode: Syntax?
        while let unwrappedNode = currentNode {
            if (unwrappedNode.as(ActorDeclSyntax.self) != nil)
                || (unwrappedNode.as(ClassDeclSyntax.self) != nil)
                || (unwrappedNode.as(EnumDeclSyntax.self) != nil)
                || (unwrappedNode.as(ProtocolDeclSyntax.self) != nil)
                || (unwrappedNode.as(StructDeclSyntax.self) != nil)
                || (unwrappedNode.as(ExtensionDeclSyntax.self) != nil)
                || (unwrappedNode.as(FunctionDeclSyntax.self) != nil)
                || (unwrappedNode.as(VariableDeclSyntax.self) != nil)
                || (unwrappedNode.as(TypeAliasDeclSyntax.self) != nil)
            {
                localNode = unwrappedNode
                break
            }
            currentNode = unwrappedNode.parent
        }

        while let unwrappedNode = currentNode {
            if (unwrappedNode.as(ActorDeclSyntax.self) != nil)
                || (unwrappedNode.as(ClassDeclSyntax.self) != nil)
                || (unwrappedNode.as(EnumDeclSyntax.self) != nil)
                || (unwrappedNode.as(ProtocolDeclSyntax.self) != nil)
                || (unwrappedNode.as(StructDeclSyntax.self) != nil)
                || (unwrappedNode.as(ExtensionDeclSyntax.self) != nil)
                || (unwrappedNode.as(CodeBlockItemSyntax.self) != nil)
            {
                return (node: localNode, parent: unwrappedNode)
            }
            currentNode = unwrappedNode.parent
        }

        return (node: currentNode, parent: nil)
    }

    /// Check if the file becomes empty, contains only comments, or import lines
    var isEmptyOrContainsOnlyCommentsOrImports: Bool {
        statements.allSatisfy { stmt in
            if stmt.item.is(ImportDeclSyntax.self) || stmt.item.is(CodeBlockSyntax.self) {
                return true
            }
            return false
        }
    }
}
