import SwiftSyntax

struct Node {
    let memberOrDeclName: String
    let peripheryNode: Periphery.JSONNode
    let node: Syntax
    let parent: Syntax?
}
