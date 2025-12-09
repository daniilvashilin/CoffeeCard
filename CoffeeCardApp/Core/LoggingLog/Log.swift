import Foundation
import os

enum LogLevel: String {
    case debug   = "🐞 DEBUG"
    case info    = "ℹ️ INFO"
    case warning = "⚠️ WARNING"
    case error   = "❌ ERROR"
}

private extension LogLevel {
    var osType: OSLogType {
        switch self {
        case .debug:   return .debug
        case .info:    return .info
        case .warning: return .default
        case .error:   return .error
        }
    }
}

enum Log {
    
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "CoffeeCard",
        category: "App"
    )
    
    // MARK: - Public API
    
    static func debug(_ message: @autoclosure () -> String,
                      file: String = #fileID,
                      function: String = #function,
                      line: Int = #line) {
        log(level: .debug,
            message: message(),
            file: file,
            function: function,
            line: line)
    }
    
    static func info(_ message: @autoclosure () -> String,
                     file: String = #fileID,
                     function: String = #function,
                     line: Int = #line) {
        log(level: .info,
            message: message(),
            file: file,
            function: function,
            line: line)
    }
    
    static func warning(_ message: @autoclosure () -> String,
                        file: String = #fileID,
                        function: String = #function,
                        line: Int = #line) {
        log(level: .warning,
            message: message(),
            file: file,
            function: function,
            line: line)
    }
    
    static func error(_ message: @autoclosure () -> String,
                      error: Error? = nil,
                      file: String = #fileID,
                      function: String = #function,
                      line: Int = #line) {
        
        var full = message()
        if let error {
            full += " | \(error.localizedDescription)"
        }
        
        log(level: .error,
            message: full,
            file: file,
            function: function,
            line: line)
    }
    
    // MARK: - Internal router
    
    private static func log(level: LogLevel,
                            message: String,
                            file: String,
                            function: String,
                            line: Int) {
#if DEBUG
        printFormatted(level: level,
                       message: message,
                       file: file,
                       function: function,
                       line: line)
#else
        let location = "[\(file):\(line) \(function)]"
        logger.log(level: level.osType,
                   "\(location) – \(message, privacy: .public)")
#endif
    }
    
    // MARK: - Debug printer (для DEBUG билда)
    
    private static func printFormatted(level: LogLevel,
                                       message: String,
                                       file: String,
                                       function: String,
                                       line: Int) {
        
        let fileName = (file as NSString).lastPathComponent
        let prefix = "[\(fileName):\(line) \(function)]"
        
        print("\(level.rawValue) \(prefix) – \(message)")
    }
}
