import SwiftSyntax

struct Node {
    let memberOrDeclName: String
    let node: Syntax
    let parent: Syntax?
}
