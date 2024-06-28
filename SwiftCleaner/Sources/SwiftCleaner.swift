import Foundation
import ArgumentParser
import SwiftEraser

@main
struct SwiftCleaner: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "A Swift command-line tool to clean your deadcode",
        subcommands: []
    )
    @Option(
        name: .shortAndLong,
        help: "The xcworkspace to analyze"
    )
    private var workspace: String?

    @Option(
        name: .shortAndLong,
        help: "The xcodeproject to analyze"
    )
    private var project: String?

    @Option(
        name: .shortAndLong,
        help: "The scheme to analyze"
    )
    private var scheme: String?

    @Option(
        name: .shortAndLong,
        help: "The target to analyze"
    )
    private var target: String?

    @Option(
        name: .shortAndLong,
        help: "The destination where building the project to make the analysis"
    )
    private var destination = "platform=iOS Simulator,OS=17.5,name=iPhone 15 Pro"

    @Flag(name: .shortAndLong, help: "Show extra logging for debugging purposes")
    private var verbose = false

    @Flag(name: .long, help: "Skip build if you already made it. Do not use this flag the first time you use SwiftCleaner")
    private var skipBuild = false
    
    private static let reportName = "periphery-report.json"

    init() {}

    func run() async throws {
        func periphery(_ commands: String..., output: String) {
            do {
                let peripheryBinaryURL = Bundle.module.url(
                    forResource: "periphery",
                    withExtension: nil
                )!
                let task = Process()
                task.executableURL = peripheryBinaryURL
                task.arguments = commands
                let filePath = "\(FileManager.default.currentDirectoryPath)/\(output)"
                let fileURL = URL(fileURLWithPath: filePath)
                FileManager.default.createFile(atPath: filePath, contents: nil)
                let outputFileHandle = try FileHandle(forWritingTo: fileURL)
                defer {
                    try? outputFileHandle.close()
                }
                task.standardOutput = outputFileHandle
                try task.run()
                task.waitUntilExit()
                if task.terminationStatus != 0 {
                    SwiftCleaner.exit(
                        withError: Error.code(Int(task.terminationStatus))
                    )
                }
            } catch {
                print("Error: \(error)")
                SwiftCleaner.exit(
                    withError: Error.code(Int(1))
                )
            }
        }
        func shell(_ command: String, exitOnFailure: Bool = true) {
            let process = Process()
            process.launchPath = "/bin/bash"
            process.arguments = ["-c", command]
            process.launch()
            process.waitUntilExit()
            if process.terminationStatus != 0 && exitOnFailure {
                print("Error: \(command) failed")
                SwiftCleaner.exit(
                    withError: Error.code(Int(process.terminationStatus))
                )
            }
        }

        // 0. Extract informations
        let projectName: String? = if let path = workspace {
            URL(fileURLWithPath: path).deletingPathExtension().lastPathComponent
        } else if let path = project {
            URL(fileURLWithPath: path).deletingPathExtension().lastPathComponent
        } else {
            nil
        }
        if workspace == nil && project == nil {
            print("Error: You must provide either a workspace or a project.")
            SwiftCleaner.exit(withError: Error.code(1))
        }
        print("👉 Project Name: \(projectName ?? "Unknown")")

        // 1. Generate DerivedData
        // If space xcodebuild expect space to be escaped & quoted. Ex: '/Users/jakob/Library/Mobile\ Documents/Foo.xcodeproj'
        if !skipBuild {
            print("📦 Building project ...")
            if let path = workspace {
                let unescapedQuotedPath = path.unescaped.quoted
                shell("xcodebuild -workspace \(unescapedQuotedPath) -scheme \(scheme ?? projectName ?? "") -parallelizeTargets -quiet -derivedDataPath \(FileManager.default.derivedData) -destination \"\(destination)\" -quiet clean build CODE_SIGNING_ALLOWED=\"NO\" ENABLE_BITCODE=\"NO\" DEBUG_INFORMATION_FORMAT=\"dwarf\" COMPILER_INDEX_STORE_ENABLE=\"YES\" INDEX_ENABLE_DATA_STORE=\"YES\"")
            } else if let path = project {
                let unescapedQuotedPath = path.unescaped.quoted
                shell("xcodebuild -project \(unescapedQuotedPath) -scheme \(scheme ?? projectName ?? "") -parallelizeTargets -quiet -derivedDataPath \(FileManager.default.derivedData) -destination \"\(destination)\" -quiet clean build CODE_SIGNING_ALLOWED=\"NO\" ENABLE_BITCODE=\"NO\" DEBUG_INFORMATION_FORMAT=\"dwarf\" COMPILER_INDEX_STORE_ENABLE=\"YES\" INDEX_ENABLE_DATA_STORE=\"YES\"")
            } else {
                print("❌ Either PROJECT_PATH: \"\(project ?? "Unspecified project")\" or WORKSPACE_PATH: \"\(workspace ?? "Unspecified workspace")\" is missing")
                SwiftCleaner.exit(withError: Error.code(1))
            }
        }

        // 2. Make analysis through Periphery
        // If space periphery scan expect space to NOT be escaped. Ex: /Users/jakob/Library/Mobile Documents/Foo.xcodeproj
        print("📦 Generating report ...")
        if let workspace {
            periphery(
                "scan",
                "--workspace", workspace.unescaped,
                "--schemes", "\(scheme ?? projectName ?? "")",
                "--targets", "\(target ?? projectName ?? "")",
                "--skip-build",
                "--format", "json",
                "--index-store-path", "\(FileManager.default.derivedData)/Index.noindex/DataStore/",
                "--retain-public",
                "--disable-redundant-public-analysis",
                "--retain-objc-accessible",
                "--retain-objc-annotated",
                "--retain-assign-only-properties",
                "--retain-unused-protocol-func-params",
                "--retain-swift-ui-previews",
                "--disable-update-check",
                output: SwiftCleaner.reportName
            )
        } else if let project {
            periphery(
                "scan",
                "--project", project.unescaped,
                "--schemes", "\(scheme ?? projectName ?? "")",
                "--targets", "\(target ?? projectName ?? "")",
                "--skip-build",
                "--format", "json",
                "--index-store-path", "\(FileManager.default.derivedData)/Index.noindex/DataStore/",
                "--retain-public",
                "--disable-redundant-public-analysis",
                "--retain-objc-accessible",
                "--retain-objc-annotated",
                "--retain-assign-only-properties",
                "--retain-unused-protocol-func-params",
                "--retain-swift-ui-previews",
                "--disable-update-check",
                output: SwiftCleaner.reportName
            )
        }

        // 3. Erase
        try await SwiftEraserCommand(reportPath: SwiftCleaner.reportName).run()

        if !verbose {
            shell("rm \(SwiftCleaner.reportName)", exitOnFailure: false)
            shell("rm default.profraw", exitOnFailure: false)
        }
        print("✅ Cleaned!")
    }
}
