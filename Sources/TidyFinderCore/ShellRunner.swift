import Foundation

public struct ShellRunner {
    public enum ShellError: Error {
        case commandFailed(exitCode: Int32, output: String)
        case invalidCommand
    }
    
    @discardableResult
    public static func execute(command: String) throws -> String {
        let task = Process()
        let pipe = Pipe()
        let errorPipe = Pipe()
        
        task.standardOutput = pipe
        task.standardError = errorPipe
        task.arguments = ["-c", command]
        task.launchPath = "/bin/bash"
        task.standardInput = nil
        
        do {
            try task.run()
            task.waitUntilExit()
            
            let outputData = pipe.fileHandleForReading.readDataToEndOfFile()
            let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
            
            let output = String(data: outputData, encoding: .utf8) ?? ""
            let errorOutput = String(data: errorData, encoding: .utf8) ?? ""
            
            if task.terminationStatus != 0 {
                let combinedOutput = output + (errorOutput.isEmpty ? "" : "\nError: \(errorOutput)")
                throw ShellError.commandFailed(exitCode: task.terminationStatus, output: combinedOutput)
            }
            
            if !errorOutput.isEmpty {
                print("Warning: \(errorOutput)")
            }
            
            return output.trimmingCharacters(in: .whitespacesAndNewlines)
        } catch {
            throw ShellError.invalidCommand
        }
    }
}