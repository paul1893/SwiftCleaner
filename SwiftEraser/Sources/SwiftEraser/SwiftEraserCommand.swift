import Foundation
import ArgumentParser
import SwiftSyntax
import SwiftParser

public struct SwiftEraserCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        abstract: "A Swift command-line tool to erase some syntax nodes",
        subcommands: [])

    @Argument(help: "The report path")
    private var reportPath: String

    @Argument(help: "Only delete unused imports")
    private var onlyImport: Bool

    public init() {}

    public init(reportPath: String, onlyImport: Bool = false) {
        self.reportPath = reportPath
        self.onlyImport = onlyImport
    }

    public func run() async throws {
        do {
            // 1. Using JSON file
            print("📦 Decoding report ...")
            guard let json = try String(contentsOfFile: reportPath, encoding: .utf8).data(using: .utf8) else {
                print("❌ Cannot read the JSON file provided")
                SwiftEraserCommand.exit()
            }
            let peripheryNodes = try JSONDecoder()
                .decode(
                    [Periphery.JSONNode].self,
                    from: json
                )
                .filter {
                    $0.hints.contains(.redundantConformance)
                    || $0.hints.contains(.redundantProtocol)
                    || $0.hints.contains(.unused)
                }

            // 2. Collecting nodes
            print("📦 Collecting nodes from report ...")
            var nodes = [SwiftEraser.Node]()
            for peripheryNode in peripheryNodes {
                let pathLineAndColumn = peripheryNode.location.split(separator: ".swift")
                let filePath = "\(String(pathLineAndColumn[0])).swift"
                let positions = pathLineAndColumn[1]
                let lineAndColumn = positions.split(separator: ":")
                guard let line = Int(lineAndColumn[0]),
                      let column = Int(lineAndColumn[1])
                else {
                    print("❌ Cannot convert to line and column")
                    SwiftEraserCommand.exit()
                }
                let fileURL = URL(fileURLWithPath: filePath)
                let sourceText = try String(contentsOf: fileURL)
                let sourceFile = Parser.parse(source: sourceText)
                let sourceLocationConverter = SourceLocationConverter(
                    fileName: filePath,
                    tree: sourceFile
                )
                let match = sourceFile.findNearestEnclosingNode(
                    for: sourceLocationConverter.position(
                        ofLine: line,
                        column: column
                    )
                )

                guard let matchNode = match.node else {
                    print("❌ \(peripheryNode.ids[0]): Cannot find node. This node will be ignored.")
                    continue
                }

                nodes.append(
                    SwiftEraser.Node(
                        memberOrDeclName: peripheryNode.name,
                        peripheryNode: peripheryNode,
                        node: matchNode,
                        parent: match.parent
                    )
                )
            }

            for node in nodes {
                let peripheryNode = node.peripheryNode
                do {
                    let pathLineAndColumn = peripheryNode.location.split(separator: ".swift")
                    let filePath = "\(String(pathLineAndColumn[0])).swift"
                    // Remove line and column (ex: my/path/filename.swift:32:17)
                    let fileURL = URL(fileURLWithPath: filePath)
                    let sourceText = try String(contentsOf: fileURL)
                    let action = try delete(
                        sourceText: sourceText,
                        types: peripheryNode.hints,
                        kind: peripheryNode.kind,
                        node: node,
                        onlyImport: onlyImport
                    )
                    switch action {
                    case .delete:
                        try FileManager.default.removeItem(at: fileURL)
                    case .rewrite(let newSourceText):
                        try newSourceText
                            .write(
                                to: fileURL,
                                atomically: true,
                                encoding: .utf8
                            )
                    }
                    print("✅ Deletion of \(peripheryNode.name) at \(peripheryNode.location)")
                } catch {
                    print("🟠 Nothing to delete \(peripheryNode.name): \(error)")
                }
            }
        } catch {
            print("❌ Cannot decode the JSON file provided as input: \(error)\nBe sure to conform to Periphery format (https://github.com/peripheryapp/periphery)")
        }
    }

}
