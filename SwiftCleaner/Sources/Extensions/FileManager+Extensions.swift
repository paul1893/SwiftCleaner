import Foundation

extension FileManager {
    var currentDirectorySafePath: String {
        currentDirectoryPath.replacingOccurrences(of: " ", with: "\\ ")
    }
    var derivedData: String {
        if let customPath = shellResult("defaults read com.apple.dt.Xcode.plist IDECustomDerivedDataLocation"),
           customPath.contains("The domain/default pair of (com.apple.dt.Xcode.plist, IDECustomDerivedDataLocation) does not exist") == false {
            return customPath
                .replacingOccurrences(of: " ", with: "\\ ")
                .replacingOccurrences(of: "\n", with: "")
        } else if let defaultPath = shellResult("echo /Users/$USER/Library/Developer/Xcode/DerivedData/") {
            return defaultPath
                .replacingOccurrences(of: " ", with: "\\ ")
                .replacingOccurrences(of: "\n", with: "")
        } else {
            return ""
        }
    }
    
    @discardableResult
    private func shellResult(_ command: String) -> String? {
        let process = Process()
        let pipe = Pipe()
        
        process.launchPath = "/bin/bash"
        process.arguments = ["-c", command]
        process.standardOutput = pipe
        process.standardError = pipe
        process.launch()
        process.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)
        
        if process.terminationStatus != 0 {
            return nil
        }
        
        return output
    }
}
